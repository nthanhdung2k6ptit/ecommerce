## Bước 1: Cập nhật code mới nhất và Tạo nhánh riêng
Trước khi bắt đầu code bất kỳ tính năng nào, luôn phải lấy bản cập nhật mới nhất từ nhánh main về máy, sau đó mới tách ra nhánh riêng của mình.

* Mở Terminal (or Git Bash) và chạy lần lượt 3 lệnh sau:
```bash
 git checkout main
 git pull origin main
 git checkout -b <tên-nhánh-của-bạn>
```

Ví dụ đặt tên nhánh: git checkout -b feature-backend-dung

## Bước 2: vào Code
Phần Frontend: Mở thư mục dự án bằng IDE tùy chọn để viết HTML/CSS/JS.

Phần Backend: Mở project bằng NetBeans để cấu hình Java Servlet/JSP, viết Controller, Model.

Database: Đảm bảo MySQL đang chạy ở local và chuỗi kết nối (JDBC URL) trong code khớp với thông tin máy của bạn.

## Bước 3: Lưu lại và Đẩy code lên GitHub (Commit & Push)
code xong một cụm tính năng và chạy thử (test) ko có lỗi, đóng gói code và đẩy lên branch riêng trên GitHub.

Chạy lần lượt 3 lệnh sau:
```bash
git add .
git commit -m "Mô tả ngắn gọn những gì bạn vừa code"
git push origin <tên-nhánh-của-bạn>
```
## Bước 4: Đề xuất Gộp code (Tạo Pull Request)
Sau khi đẩy code ở Bước 3, code của bạn mới chỉ nằm ở nhánh riêng trên mạng. Để lắp nó vào bản chính thức, bạn cần tạo yêu cầu gộp code.

Lên trang web GitHub của dự án.

Hệ thống sẽ tự động hiện thanh thông báo màu xanh lá, hãy bấm vào nút "Compare & pull request".

Điền vài dòng mô tả bạn đã làm tính năng gì và bấm Create pull request.

Nhắn vào nhóm để một thành viên khác vào kiểm tra và bấm nút Merge pull request. (Tuyệt đối không tự Merge code của chính mình).

## Bước 5: Cập nhật lại chu trình mới
Sau khi code đã được gộp thành công vào main, nhánh riêng của bạn đã hoàn thành nhiệm vụ. Hãy quay lại Bước 1 để lấy bộ code mới nhất (đã có tính năng của bạn trong đó) và tiếp tục tạo nhánh mới cho các chức năng tiếp theo.
