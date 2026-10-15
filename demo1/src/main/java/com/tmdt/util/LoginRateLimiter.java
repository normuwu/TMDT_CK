package com.tmdt.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Brute-force throttle for login attempts, in-memory only (resets on
 * redeploy — acceptable for this scope; no external dependency added).
 * Key: identifier + IP. Rule: 5 failures within the window -> 5 minute lock.
 * A daemon scheduled task prunes old entries so the map cannot grow forever.
 */
public final class LoginRateLimiter {

    private static final Logger LOG = LoggerFactory.getLogger(LoginRateLimiter.class);

    public static final int MAX_FAILURES = 5;
    public static final long LOCK_DURATION_MS = TimeUnit.MINUTES.toMillis(5);
    /** Entries untouched for this long are pruned. */
    private static final long IDLE_PRUNE_MS = TimeUnit.MINUTES.toMillis(30);

    private static final class Entry {
        final AtomicInteger failures = new AtomicInteger(0);
        volatile long lockedUntil = 0L;
        volatile long touchedAt = System.currentTimeMillis();
    }

    private static final Map<String, Entry> ATTEMPTS = new ConcurrentHashMap<>();

    private static final ScheduledExecutorService CLEANER = Executors.newSingleThreadScheduledExecutor(r -> {
        Thread t = new Thread(r, "login-ratelimiter-cleaner");
        t.setDaemon(true);
        return t;
    });

    static {
        CLEANER.scheduleWithFixedDelay(LoginRateLimiter::prune, 1, 1, TimeUnit.MINUTES);
    }

    private LoginRateLimiter() {
    }

    /** True while the key is locked after too many failures. */
    public static boolean isBlocked(String key) {
        if (key == null) return false;
        Entry entry = ATTEMPTS.get(key);
        if (entry == null) return false;
        boolean blocked = entry.lockedUntil > System.currentTimeMillis();
        if (!blocked && entry.failures.get() == 0) {
            ATTEMPTS.remove(key, entry);
        }
        return blocked;
    }

    /** One more wrong attempt for this key (ignored while already blocked). */
    public static void recordFailure(String key) {
        if (key == null) return;
        long now = System.currentTimeMillis();
        Entry created = new Entry();
        Entry existing = ATTEMPTS.putIfAbsent(key, created);
        Entry entry = existing != null ? existing : created;
        entry.touchedAt = now;
        int failures = entry.failures.incrementAndGet();
        if (failures >= MAX_FAILURES) {
            entry.lockedUntil = now + LOCK_DURATION_MS;
            LOG.info("Login throttle: key locked after {} failures", failures);
        }
    }

    /** Successful login clears the counter for this key. */
    public static void reset(String key) {
        if (key != null) {
            ATTEMPTS.remove(key);
        }
    }

    private static void prune() {
        long cutoff = System.currentTimeMillis() - IDLE_PRUNE_MS;
        Iterator<Map.Entry<String, Entry>> it = ATTEMPTS.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, Entry> e = it.next();
            Entry entry = e.getValue();
            long lastTouched = Math.max(entry.touchedAt, entry.lockedUntil);
            if (lastTouched < cutoff) {
                it.remove();
            }
        }
    }
}
