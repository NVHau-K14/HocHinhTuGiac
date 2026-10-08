# KẾ HOẠCH THIẾT KẾ GIAO DIỆN (DESIGN PLAN)
## Dự án: Website Học Hình Học Phẳng – Chủ đề Tứ Giác
*Nguồn quy chuẩn: `DESIGN_BRIEF.md` và `AGENT_PROMPT.md` (Mục 6, 7)*

---

### 1. Bảng màu chuẩn (Design Tokens)

Trang web sử dụng đúng 6 màu chốt, tuyệt đối tránh nền kem, màu đất nung và các dải gradient trang trí hiện đại của AI:

| Token | Tên màu | Mã Hex | Vai trò ứng dụng |
|---|---|---|---|
| `--color-paper` | Giấy | `#FAFCFD` | Nền toàn trang |
| `--color-grid` | Ô li | `#CFE3F1` | Lưới kẻ vở ô li (chu kỳ 24px) |
| `--color-margin` | Lề đỏ | `#D64550` | Đường lề vở dọc bên trái, dấu chấm sai ✗ của cô giáo |
| `--color-ink` | Mực xanh | `#1F3A93` | Nét vẽ hình SVG, tiêu đề chữ viết tay, liên kết |
| `--color-pencil` | Chì | `#3B3F46` | Văn bản nội dung, bài tập, lời giải |
| `--color-highlight` | Dạ quang | `#FFE66D` | Vệt bút highlight tô nổi định nghĩa / từ khóa trọng tâm |

**Màu trạng thái kết quả:**
- **Đúng:** Xanh lá cây `#2E8B57` kèm ký hiệu `✓` và chữ "Đúng".
- **Sai:** Lề đỏ `#D64550` kèm ký hiệu `✗` và chữ "Sai" (không phân biệt duy nhất bằng màu sắc).

**Màu nền nhạt theo họ hình (phân cấp cây IS_A):**
- **Họ hình thang** (`hinh-thang`, `hinh-thang-can`): `#E6DDF5`
- **Họ bình hành** (`hinh-binh-hanh`, `hinh-chu-nhat`, `hinh-thoi`, `hinh-vuong`): `#D8F0E4`
- **Họ diều** (`hinh-dieu`): `#FBE0E8`
- **Tứ giác gốc** (`tu-giac`): `#FAFCFD`

---

### 2. Hệ thống Typography

- **Tiêu đề & Chú thích hình học:** `Patrick Hand`, cursive (Google Fonts, subset `vietnamese`). Tạo cảm giác nét chữ viết tay nắn nót của học sinh trên trang vở.
- **Văn bản nội dung & Lời giải:** `Be Vietnam Pro`, sans-serif (Google Fonts, subset `vietnamese`). Độ đậm 400 (regular), 600 (semi-bold).
- **Công thức & Ký hiệu toán học:** KaTeX tải từ CDN. Các ký hiệu hình học $\parallel$, $\perp$, $\angle$, $^\circ$ được render sắc nét.
- **Giới hạn dòng:** Tối đa khoảng 70 ký tự/dòng để tối ưu khả năng đọc.

---

### 3. Hệ thống Lưới & Căn lề Vở Ô Li

- **Lưới cơ sở (Baseline Grid):** Đơn vị chuẩn **24px**.
- **Nền:** Sử dụng CSS `linear-gradient` (không dùng file ảnh PNG/JPG) tạo lưới ca-rô 24px $\times$ 24px.
- **Dòng kẻ ngang:** `line-height` của đoạn văn bản là bội số của 24px (24px, 48px) để dòng chữ nằm chuẩn trên đường kẻ ngang của trang vở.
- **Đường lề đỏ (Margin Line):**
  - Desktop: Đường kẻ dọc 2px `#D64550` cách lề trái nội dung 60px - 80px.
  - Mobile (360px): Thu gọn cách mép trái 16px - 20px, lưới 24px giữ nguyên tỷ lệ, không gây cuộn ngang.

---

### 4. Wireframe Bố Cục (ASCII Wireframes)

#### 4.1. Trang chủ (`/`)
```
+-------------------------------------------------------------------------+
| [Lề đỏ]  Học Hình Học Phẳng: Tứ Giác                 [Chào, Người học]  |
|   |                                                                     |
|   |   "Tập vở trực quan khám phá thế giới các hình tứ giác..."          |
|   |                                                                     |
|   |   +-------------------------------------------------------------+   |
|   |   | BẢNG VẼ 8 TỨ GIÁC (Nét mực Mực xanh, tự vẽ ~1.2s)          |   |
|   |   |                                                             |   |
|   |   |  [ Tứ giác ]    [ Hình thang ]  [ Thang cân ]  [ B bình hành ]|   |
|   |   |   (Gốc)           (Họ thang)     (Họ thang)     (Họ b.hành) |   |
|   |   |                                                             |   |
|   |   |  [ Chữ nhật ]   [ Hình thoi ]   [ Hình vuông ] [ Hình diều ]|   |
|   |   |  (Họ b.hành)    (Họ b.hành)     (Họ b.hành)     (Họ diều)   |   |
|   |   +-------------------------------------------------------------+   |
|   |                                                                     |
|   |   NỘI DUNG VỞ BÀI TẬP:                                             |
|   |   * 1. Khám phá lý thuyết & tính chất kế thừa (8 loại tứ giác)      |
|   |   * 2. Xem sơ đồ quan hệ phân cấp IS_A (vis-network tương tác)      |
|   |   * 3. Luyện tập giải bài tập theo từng hình                        |
|   |   * 4. Tham gia bài kiểm tra Quiz tổng hợp (10 câu trắc nghiệm)    |
|   |   * 5. Tra cứu bảng điểm lớp & Tìm kiếm kiến thức                   |
+-------------------------------------------------------------------------+
```

#### 4.2. Trang Chi tiết hình (`/shape/{slug}`)
```
+-------------------------------------------------------------------------+
| [Lề đỏ]  < Về trang chủ  |  Hình Thang Cân                              |
|   |                                                                     |
|   |  [ CỘT CHÍNH ]                           [ CỘT PHỤ (Phân cấp IS_A)] |
|   |  * Hình vẽ chính xác (SVG nhãn đỉnh)     +------------------------+ |
|   |                                          | Hình tổng quát hơn:    | |
|   |  * Định nghĩa (Tô bút dạ quang vàng):   | - Hình thang           | |
|   |    "Hình thang có hai góc kề một đáy..." | - Tứ giác              | |
|   |                                          +------------------------+ |
|   |  * Tính chất trực tiếp:                  | Hình đặc biệt hơn:     | |
|   |    - Hai cạnh bên bằng nhau              | - Hình chữ nhật        | |
|   |    - Hai đường chéo bằng nhau            | - Hình vuông           | |
|   |                                          +------------------------+ |
|   |  * Tính chất kế thừa qua IS_A:                                      |
|   |    - Kế thừa từ Hình thang: Tổng 2 góc kề 1 cạnh bên = 180°        |
|   |    - Kế thừa từ Tứ giác: Tổng bốn góc bằng 360°                    |
|   |                                                                     |
|   |  * Định lý & Dấu hiệu nhận biết                                     |
|   |  * Công thức tính (KaTeX) & Ví dụ minh họa                         |
+-------------------------------------------------------------------------+
```

#### 4.3. Trang Quiz & Kết quả (`/quiz` & `/quiz/result`)
```
+-------------------------------------------------------------------------+
| [Lề đỏ]  Bài Kiểm Tra Tổng Hợp                                          |
|   |      Tiến độ: Câu 7/10                                              |
|   |                                                                     |
|   |      Câu 7: Khẳng định nào sau đây là đúng?                         |
|   |      ( ) A. Mọi hình chữ nhật đều là hình thoi                      |
|   |      (*) B. Mọi hình vuông đều là hình chữ nhật                     |
|   |      ( ) C. Hình thang cân có hai cạnh bên song song                |
|   |      ( ) D. Hình diều có hai đường chéo bằng nhau                   |
|   |                                                                     |
|   |      [ < Câu trước ]                       [ Câu tiếp theo > ]      |
|   |                                                                     |
|   |  KẾT QUẢ CHẤM BÀI:                                                  |
|   |   +------------------------------------+                            |
|   |   |   /----\                           |                            |
|   |   |  | 8/10 |  (Khoanh tròn mực đỏ     |   80 / 100 điểm            |
|   |   |   \----/    như cô giáo chấm bài)  |                            |
|   |   +------------------------------------+                            |
|   |   Xem lại chi tiết từng câu:                                        |
|   |   - Câu 1: [✓ Đúng] Lời giải: ...                                   |
|   |   - Câu 2: [✗ Sai] Lời giải: ...                                    |
+-------------------------------------------------------------------------+
```

---

### 5. Tự rà soát chống "Dấu hiệu AI làm" (Anti-AI Patterns)

| Biểu hiện AI mặc định | Cách thiết kế của dự án khắc phục triệt để |
|---|---|
| Nền kem, màu đất nung, gradient trang trí | Nền giấy `#FAFCFD`, đường kẻ ô li `#CFE3F1`, lề đỏ `#D64550`. |
| Lưới card bóng bẩy, bo góc tròn xoe giống hệt nhau | Bố cục sắp xếp tự nhiên như các hình vẽ trên trang vở; bo góc nhỏ 4px, viền nét mực; lối vào dạng danh sách gạch đầu dòng. |
| Nhãn chữ IN HOA rải rác khắp nơi | Tiêu đề và nội dung viết hoa chữ đầu câu tự nhiên bằng tiếng Việt chuẩn. |
| Đánh số 01 / 02 / 03 máy móc | Dùng danh sách chấm gạch đầu dòng hoặc tiêu đề mục ngữ nghĩa thực tế. |
| Hiệu ứng trượt hiện rối mắt | Chuyển động duy nhất: nét mực vẽ tay tự vẽ 1.2s ở trang chủ, hỗ trợ `prefers-reduced-motion`. |
