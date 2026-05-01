USE ecommerce;

-- 1. Bảng products: Thêm image_url (lưu link ảnh) và is_active (trạng thái ẩn/hiện)
ALTER TABLE products 
ADD COLUMN image_url VARCHAR(255) NULL AFTER name,
ADD COLUMN is_active TINYINT(1) NOT NULL DEFAULT 1 AFTER created_at;

-- 2. Bảng sellers: Thêm created_at (ngày đăng ký gian hàng)
ALTER TABLE sellers 
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER is_approved;

-- 3. Bảng orders: Thêm discount_amount (số tiền được giảm giá qua voucher)
ALTER TABLE orders 
ADD COLUMN discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER shipping_fee;

-- 4. Cập nhật voucher_id và discount_amount giả lập cho 5 đơn hàng đầu tiên
UPDATE orders SET voucher_id = 1, discount_amount = 50000.00 WHERE order_id IN (1, 2);
UPDATE orders SET voucher_id = 2, discount_amount = 25000.00 WHERE order_id IN (3, 4);
UPDATE orders SET voucher_id = 5, discount_amount = 100000.00 WHERE order_id = 5;
