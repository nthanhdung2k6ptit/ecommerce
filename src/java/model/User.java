package model;

import java.sql.Timestamp;

/**
 * Unified User Model
 * Mapping bảng Users
 * role: 'customer' | 'seller' | 'admin'
 */
public class User {

    // ===== CORE FIELDS (DB) =====
    private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String passwordHash;
    private String role;
    private Timestamp createdAt;

    // ===== CONSTRUCTOR =====

    // Constructor rỗng (JavaBean bắt buộc)
    public User() {}

    // Constructor đầy đủ
    public User(int userId, String fullName, String email, String phone,
                String passwordHash, String role, Timestamp createdAt) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.passwordHash = passwordHash;
        this.role = role;
        this.createdAt = createdAt;
    }

    // ===== GETTER & SETTER =====

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // ===== HELPER METHODS (OPTIONAL - NÊN CÓ) =====

    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(role);
    }

    public boolean isSeller() {
        return "seller".equalsIgnoreCase(role);
    }

    public boolean isCustomer() {
        return "customer".equalsIgnoreCase(role);
    }
}