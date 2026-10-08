# DESIGN BRIEF – Website học hình học phẳng: Tứ giác

Đặt file này ở gốc dự án và cho agent đọc trước khi viết giao diện. Brief này thắng mọi mặc định của skill/agent.

## Đối tượng và việc chính
Học sinh lớp 8 (ôn lại ở THPT). Việc chính: đọc định nghĩa/tính chất, làm bài, làm quiz.

## Ý tưởng chủ đạo: trang vở ô li
Mỗi trang giống một trang vở: nền kẻ ô, lề đỏ bên trái, chữ như viết bằng mực, hình vẽ bằng thước và compa. Điểm nhớ duy nhất của giao diện là **hình vẽ SVG 8 loại tứ giác nét mực** ở trang chủ. Mọi thứ khác giữ yên tĩnh.

## Design tokens
**Màu (6 màu, tránh nền kem và màu đất nung):**
| Tên | Hex | Dùng cho |
|---|---|---|
| Giấy | #FAFCFD | nền trang |
| Ô li | #CFE3F1 | đường kẻ lưới |
| Lề đỏ | #D64550 | đường lề, dấu chấm bài của cô giáo |
| Mực xanh | #1F3A93 | chữ tiêu đề, nét vẽ hình, liên kết |
| Chì | #3B3F46 | chữ nội dung |
| Dạ quang | #FFE66D | tô nổi định nghĩa/từ khóa |
Đúng = xanh lá #2E8B57 kèm dấu ✓ và chữ "Đúng"; Sai = lề đỏ kèm dấu ✗ và chữ "Sai" (không chỉ dựa vào màu).
Màu theo họ hình (nhạt, dùng làm nền hình vẽ): họ hình thang, họ bình hành, họ diều. Theo cây IS_A.

**Chữ:** tiêu đề Patrick Hand; nội dung Be Vietnam Pro. Bắt buộc tải subset `vietnamese` và kiểm tra dấu hiển thị đúng. Công thức dùng KaTeX. Nội dung dài tối đa ~70 ký tự/dòng.

**Lưới:** đơn vị 24px; line-height của nội dung bằng bội của 24px để chữ nằm trên dòng kẻ. Nền vẽ bằng CSS (`linear-gradient`), không dùng ảnh.

## Bố cục
- Trang chủ: ở giữa là hình 8 tứ giác xếp như vẽ trên vở, mỗi hình có tên viết tay bên dưới; dưới cùng là 5 lối vào dạng danh sách có dấu gạch đầu dòng, không dùng lưới thẻ giống nhau.
- Trang chi tiết hình: cột chính ở lề trái (định nghĩa tô dạ quang, tính chất, định lý); cột phụ nhỏ là "hình cha / hình con" lấy từ IS_A; mục "Tính chất kế thừa" tách riêng.
- Quiz/kết quả: điểm viết tay khoanh tròn đỏ như cô giáo chấm ("8/10").
- Bảng xếp hạng: "bảng điểm lớp", hàng kẻ như vở.
- Mobile 360px: lề đỏ thu nhỏ, lưới 24px giữ nguyên.

## Chuyển động
Duy nhất một lần: khi mở trang chủ, nét 8 hình "tự vẽ" (stroke-dashoffset) trong ~1,2 giây. Ngoài ra chỉ có phản hồi cho hành động (mở sơ đồ, hiện lời giải). Tôn trọng `prefers-reduced-motion`.

## Bootstrap
Chỉ dùng lưới và tiện ích. Ghi đè biến `--bs-*` và `.btn`, `.card`, `.navbar` để không còn nút xanh, thẻ bo tròn đổ bóng mặc định. Bo góc nhỏ và không đồng nhất; không gradient trang trí.

## Không làm
Nhãn viết hoa rải rác trên tiêu đề; đánh số 01/02/03 khi nội dung không phải trình tự; chỉ tô riêng một từ trong tiêu đề; mọi thẻ cùng bo góc cùng bóng; hiệu ứng trượt-hiện ở từng khu; chữ giả (lorem), phải dùng dữ liệu thật từ Neo4j.

## Văn phong giao diện
Tiếng Việt đơn giản, câu chủ động, nút nói đúng việc ("Kiểm tra", "Xem lời giải", "Làm lại"). Trạng thái rỗng/lỗi nói rõ chuyện gì xảy ra và làm gì tiếp, không xin lỗi chung chung.

## Cách kiểm tra
Mở trang ở 360px và 1280px, chụp ảnh, tự phê bình trước khi báo xong: có chỗ nào giống "mẫu AI mặc định" thì sửa; bỏ bớt một thứ trang trí.
