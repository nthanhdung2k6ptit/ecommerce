<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CDG - Thông Tin & Hỗ Trợ</title>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/info.css?v=7">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/client/homepage.jsp">Trang chủ</a><span>›</span>
        <span id="breadcrumb-text">Chính sách bảo mật</span>
    </div>

    <div class="info-layout">
        <aside class="info-sidebar">
            <div class="info-menu">
                <div class="menu-title">ĐIỀU HƯỚNG</div>
                <a href="javascript:void(0)" class="menu-item active" data-target="privacy">Chính sách bảo mật</a>
                <a href="javascript:void(0)" class="menu-item" data-target="terms">Điều khoản dịch vụ</a>
                
                <div class="menu-title menu-title-spacing">HỖ TRỢ</div>
                <a href="javascript:void(0)" class="menu-item" data-target="contact">Liên hệ CSKH</a>
                <a href="javascript:void(0)" class="menu-item" data-target="faq">Câu hỏi thường gặp (FAQ)</a>
            </div>
        </aside>

        <main class="info-content">
            
            <div id="privacy" class="content-section active">
                <h1 class="page-title">Chính sách bảo mật thông tin</h1>
                <div class="content-body">
                    <p>Chào mừng bạn đến với CDG Marketplace. Chúng tôi cam kết bảo vệ quyền riêng tư và thông tin cá nhân của bạn. Chính sách này mô tả chi tiết cách chúng tôi thu thập, sử dụng và bảo mật dữ liệu của bạn trong quá trình sử dụng dịch vụ.</p>
                    
                    <h3>1. Mục đích thu thập thông tin</h3>
                    <p>Chúng tôi thu thập thông tin cá nhân của bạn (bao gồm Họ tên, Số điện thoại, Địa chỉ email, Địa chỉ nhận hàng) nhằm các mục đích sau:</p>
                    <ul>
                        <li>Xử lý, xác nhận và bàn giao các kiện hàng bạn đã đặt trên hệ thống cho đơn vị vận chuyển.</li>
                        <li>Hỗ trợ khách hàng, giải đáp thắc mắc và xử lý các khiếu nại phát sinh.</li>
                        <li>Gửi email thông báo về tình trạng đơn hàng, bản tin khuyến mãi (nếu bạn đăng ký nhận).</li>
                        <li>Ngăn ngừa các hoạt động gian lận, phá hoại tài khoản người dùng hoặc giả mạo.</li>
                    </ul>

                    <h3>2. Cam kết chia sẻ thông tin</h3>
                    <p>CDG cam kết tuyệt đối không thương mại hóa dữ liệu cá nhân của khách hàng dưới bất kỳ hình thức nào. Chúng tôi chỉ chia sẻ thông tin trong các trường hợp thật sự cần thiết:</p>
                    <ul>
                        <li>Cung cấp cho các đối tác vận chuyển (Giao Hàng Nhanh, Viettel Post, Ninja Van...) để thực hiện việc giao nhận hàng hóa.</li>
                        <li>Cung cấp cho cơ quan nhà nước có thẩm quyền khi có yêu cầu hợp pháp theo quy định của pháp luật.</li>
                    </ul>

                    <h3>3. Bảo mật dữ liệu thanh toán</h3>
                    <p>Toàn bộ thông tin thẻ tín dụng, tài khoản ngân hàng và giao dịch của bạn đều được mã hóa theo tiêu chuẩn an toàn bảo mật mạng quốc tế (PCI DSS và SSL). CDG không lưu trữ trực tiếp thông tin thẻ của khách hàng trên máy chủ của chúng tôi.</p>

                    <h3>4. Sử dụng Cookie</h3>
                    <p>Chúng tôi sử dụng Cookie để ghi nhớ tùy chọn duyệt web của bạn, giúp cải thiện tốc độ tải trang và mang lại trải nghiệm mua sắm cá nhân hóa tốt hơn. Bạn có thể tự do tắt Cookie trong phần cài đặt của trình duyệt nếu muốn.</p>

                    <h3>5. Quyền lợi và thay đổi thông tin</h3>
                    <p>Bạn có toàn quyền truy cập, chỉnh sửa hoặc yêu cầu xóa bỏ thông tin cá nhân của mình trên hệ thống của CDG bất cứ lúc nào thông qua phần "Tài khoản của tôi". Nếu có bất kỳ sự thay đổi nào về chính sách này, chúng tôi sẽ cập nhật trực tiếp trên trang web và thông báo qua email.</p>
                </div>
            </div>

            <div id="terms" class="content-section">
                <h1 class="page-title">Điều khoản dịch vụ</h1>
                <div class="content-body">
                    <p>Xin vui lòng đọc kỹ các Điều khoản Dịch vụ dưới đây trước khi đăng ký và tham gia mua bán trên nền tảng CDG Marketplace. Khi bạn tạo tài khoản, đồng nghĩa với việc bạn đã chấp thuận những quy định này.</p>
                    
                    <h3>1. Trách nhiệm của thành viên</h3>
                    <p>Người dùng phải cung cấp thông tin định danh chính xác khi tạo tài khoản. Bạn phải tự chịu trách nhiệm bảo mật thông tin đăng nhập, mật khẩu và toàn bộ lịch sử giao dịch phát sinh từ tài khoản của mình. Vui lòng thông báo ngay cho CDG nếu phát hiện truy cập trái phép.</p>
                    
                    <h3>2. Quy định về hàng hóa và giao dịch</h3>
                    <p>Mọi sản phẩm được đăng bán và giao dịch trên CDG phải tuân thủ nghiêm ngặt quy định của pháp luật Việt Nam. Nghiêm cấm các hành vi mua bán hàng giả, hàng nhái, hàng cấm hoặc vi phạm bản quyền.</p>

                    <h3>3. Hành vi bị nghiêm cấm</h3>
                    <ul>
                        <li>Sử dụng phần mềm tự động (bot), tạo tài khoản ảo hàng loạt để trục lợi, săn mã giảm giá hoặc thao túng hệ thống đánh giá.</li>
                        <li>Đăng tải nội dung, hình ảnh phản cảm, bôi nhọ, xúc phạm người dùng khác hoặc gian hàng.</li>
                        <li>Cố tình bom hàng (đặt hàng nhưng từ chối nhận nhiều lần không có lý do chính đáng).</li>
                    </ul>

                    <h3>4. Quyền Sở Hữu Trí Tuệ</h3>
                    <p>Toàn bộ thiết kế giao diện, logo, mã nguồn, nội dung văn bản và hình ảnh thuộc về CDG là tài sản trí tuệ được pháp luật bảo hộ. Việc sao chép, chỉnh sửa hoặc sử dụng vào mục đích thương mại mà không có sự cho phép bằng văn bản là vi phạm pháp luật.</p>

                    <h3>5. Chấm dứt cung cấp dịch vụ</h3>
                    <p>CDG có quyền đình chỉ, khóa tài khoản tạm thời hoặc vĩnh viễn mà không cần báo trước nếu phát hiện tài khoản của bạn vi phạm bất kỳ điều khoản nào nêu trên.</p>
                </div>
            </div>

            <div id="contact" class="content-section">
                <h1 class="page-title">Liên hệ chăm sóc khách hàng</h1>
                <div class="content-body">
                    <p>Sự hài lòng của bạn là ưu tiên hàng đầu của CDG. Đội ngũ Chăm sóc khách hàng của chúng tôi luôn sẵn sàng lắng nghe, hỗ trợ giải quyết mọi khó khăn trong quá trình mua sắm, thanh toán hoặc giao nhận.</p>
                    
                    <h3>Kênh liên lạc chính thức</h3>
                    <ul>
                        <li><strong>Tổng đài hỗ trợ (Hotline):</strong> 1900 1234<br>
                        <em>Thời gian làm việc: 8h00 - 22h00 (Bao gồm cả Thứ 7, Chủ Nhật và ngày Lễ). Nhánh số 1 (Đơn hàng), Nhánh số 2 (Kỹ thuật/Bảo hành).</em></li>
                        <li><strong>Hòm thư điện tử (Email):</strong> cskh@cdgmarketplace.com<br>
                        <em>Mọi email khiếu nại sẽ được tiếp nhận và phản hồi trong vòng 24 giờ làm việc.</em></li>
                        <li><strong>Chat trực tuyến:</strong> Sử dụng biểu tượng "Chat với CDG" ở góc phải màn hình trang chủ.</li>
                    </ul>

                    <h3>Trụ sở chính & Văn phòng làm việc</h3>
                    <p><strong>Công ty Cổ phần Thương mại Điện tử CDG</strong><br>
                    Địa chỉ: Tòa nhà A1, Học viện Công nghệ Bưu chính Viễn thông (PTIT), Km10 Đường Nguyễn Trãi, Quận Hà Đông, TP. Hà Nội, Việt Nam.</p>
                </div>
            </div>

            <div id="faq" class="content-section">
                <h1 class="page-title">Câu hỏi thường gặp (FAQ)</h1>
                <div class="content-body">
                    <h3>1. Tôi muốn thay đổi thông tin nhận hàng sau khi đặt đơn được không?</h3>
                    <p>If đơn hàng chưa chuyển sang trạng thái "Đang giao", bạn hoàn toàn có thể vào mục <strong>Đơn hàng của tôi</strong>, chọn đơn hàng cần sửa và bấm "Thay đổi thông tin". Nếu mục này bị ẩn, vui lòng liên hệ ngay Hotline 1900 1234 để được nhân viên hỗ trợ đổi địa chỉ.</p>
                    
                    <h3>2. Thời gian giao hàng mất bao lâu?</h3>
                    <p>Tùy thuộc vào vị trí của bạn và kho hàng của Shop. Thông thường:
                    <br>- Khu vực nội thành Hà Nội & TP.HCM: 1-2 ngày làm việc.
                    <br>- Các tỉnh thành khác: 3-5 ngày làm việc.
                    <br>Đơn hàng đặt vào cuối tuần có thể sẽ được xử lý vào Thứ 2 tuần kế tiếp.</p>

                    <h3>3. Làm thế nào để theo dõi đường đi của đơn hàng?</h3>
                    <p>Bạn truy cập vào mục "Đơn mua", chọn xem chi tiết đơn hàng. Hệ thống sẽ hiển thị lịch sử vận chuyển theo thời gian thực (Real-time tracking) để bạn biết chính xác kiện hàng đang ở bưu cục nào.</p>

                    <h3>4. CDG hỗ trợ những phương thức thanh toán nào?</h3>
                    <p>Nhằm mang lại sự tiện lợi tối đa, chúng tôi hỗ trợ các hình thức:
                    <br>- Thanh toán tiền mặt khi nhận hàng (COD).
                    <br>- Thanh toán qua thẻ tín dụng/ghi nợ (Visa, Mastercard, JCB).
                    <br>- Thanh toán quét mã VNPAY-QR, ZaloPay, MoMo.</p>

                    <h3>5. Tôi có thể yêu cầu xuất hóa đơn VAT không?</h3>
                    <p>Có. Tại bước Thanh toán (Checkout), bạn chỉ cần tích chọn ô "Yêu cầu xuất hóa đơn công ty" và điền đầy đủ Mã số thuế, Tên công ty, Địa chỉ. Hóa đơn điện tử sẽ được gửi về email của bạn trong vòng 3 ngày sau khi nhận hàng thành công.</p>
                </div>
            </div>

        </main>
    </div>
</div>

<jsp:include page="footer.jsp" />

<script src="${pageContext.request.contextPath}/assets/js/info.js?v=5"></script>
</body>
</html>