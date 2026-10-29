package com.tmdt.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Một dòng lịch sử đổi trạng thái đơn (bảng order_status_history).
 * old_status = null nghĩa là trạng thái đầu tiên khi tạo đơn.
 */
public class OrderStatusHistory {

    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private int historyId;
    private int orderId;
    private OrderStatus oldStatus;
    private OrderStatus newStatus;
    private String changedByName;
    private String note;
    private LocalDateTime createdAt;

    public String getCreatedAtText() {
        return createdAt == null ? "" : createdAt.format(DATE_TIME);
    }

    public String getOldStatusLabel() {
        return oldStatus == null ? "—" : oldStatus.getLabel();
    }

    public String getNewStatusLabel() {
        return newStatus == null ? "" : newStatus.getLabel();
    }

    public int getHistoryId() { return historyId; }
    public void setHistoryId(int historyId) { this.historyId = historyId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public OrderStatus getOldStatus() { return oldStatus; }
    public void setOldStatus(OrderStatus oldStatus) { this.oldStatus = oldStatus; }

    public OrderStatus getNewStatus() { return newStatus; }
    public void setNewStatus(OrderStatus newStatus) { this.newStatus = newStatus; }

    public String getChangedByName() { return changedByName; }
    public void setChangedByName(String changedByName) { this.changedByName = changedByName; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
