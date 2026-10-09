# PROMPT_BO_SUNG_v2_2.md – Bổ sung tính năng "Đặc tả và so sánh các hình" vào dự án đã có

> Đặt file này ở gốc dự án cùng `NEO4J_UPDATE_v2_2.md`, `DESIGN_BRIEF.md` và `AGENT_PROMPT.md`.
> Bạn là AI coding agent. Dự án **đã được xây dựng** (ASP.NET Core MVC + Neo4j) theo `AGENT_PROMPT.md`. Nhiệm vụ lần này là **bổ sung**, không viết lại. Đọc kỹ toàn bộ file này trước khi làm.

---

## 0. Nguyên tắc làm việc

1. **Đọc code hiện có trước.** Xem cấu trúc thư mục, cách đặt tên, cách Controller → Service → Repository đang được tổ chức, cách trang hiện tại dựng layout vở ô li và dùng KaTeX. **Làm theo đúng quy ước đang có**, không đổi kiến trúc, không đổi tên file/lớp cũ, không format lại cả file.
2. **Không phá chức năng cũ** (trang chủ, khám phá, chi tiết hình, sơ đồ quan hệ, luyện tập, quiz, bảng xếp hạng, tìm kiếm nếu đã làm). Sau mỗi giai đoạn chạy lại các trang cũ để chắc chắn vẫn chạy.
3. **Làm theo 4 giai đoạn** ở mục 6. Hết mỗi giai đoạn: chạy kiểm tra, báo kết quả ngắn gọn, dừng chờ người dùng gõ "tiếp".
4. **Không bịa.** Thiếu thông tin hoặc thấy mâu thuẫn với code hiện có thì hỏi người dùng bằng danh sách câu hỏi ngắn. Không tự đoán.
5. Mọi truy vấn Cypher nằm trong Repository, dùng tham số (`$slug`...). Không Cypher trong Controller/View; JavaScript không gọi Neo4j trực tiếp.
6. Commit Git sau mỗi giai đoạn (ví dụ `feat: trang so sánh các hình`). Không commit mật khẩu.

---

## 1. Bối cảnh yêu cầu mới

Giáo viên yêu cầu bổ sung **đặc tả các hình** và **mối tương quan giữa các hình**:

- Mỗi hình có bảng đặc tả theo cùng bộ tiêu chí: cạnh song song, cạnh bằng nhau, góc, đường chéo, trục đối xứng.
- Mỗi cạnh quan hệ IS_A (hình đặc biệt → hình tổng quát) có **điều kiện** cần thêm để từ hình tổng quát thành hình đặc biệt. Ví dụ: Hình vuông là hình chữ nhật khi có hai cạnh kề bằng nhau.
- Người học chọn hai hình để xem **quan hệ**, **điểm giống** và **điểm khác**.

Tài liệu gốc: SRS v2.2 (mục 4.11, UC-09, AC-18…AC-20, Phụ lục D) và Backlog v2.2 (PBI-27, PBI-32, PBI-33). Nếu có các file này trong dự án, đọc để đối chiếu.

---

## 2. Dữ liệu Neo4j (người dùng tự chạy, bạn không chạy)

Người dùng đã/sẽ chạy `NEO4J_UPDATE_v2_2.md` (Bước 0 → 3). Sau đó dữ liệu có thêm:

- `Shape.specParallel`, `specSides`, `specAngles`, `specDiagonals`, `specSymmetry` (chuỗi; "Không bắt buộc" nghĩa là tính chất đó không đúng với mọi hình thuộc loại này).
- `Shape.family` (`goc`, `thang`, `binh-hanh`, `dieu`) và `Shape.sortOrder` (1–8).
- `IS_A.condition` (chuỗi) trên 10 cạnh.

**Việc đầu tiên của bạn:** viết một đoạn kiểm tra nhỏ (hoặc hướng dẫn người dùng chạy truy vấn Bước 3.1 trong `NEO4J_UPDATE_v2_2.md`) để xác nhận 10/10 cạnh có `condition` và 8/8 hình có đủ `spec*`. Nếu thiếu, **dừng và báo người dùng chạy file cập nhật**, không tự tạo dữ liệu trong code.

Lưu ý: nếu code cũ đang map `Shape` sang model C#, thêm các thuộc tính mới vào model **dạng cho phép null** để ứng dụng không hỏng khi dữ liệu chưa được cập nhật.

---

## 3. Việc cần làm

### 3.1 Tầng dữ liệu (Repository/Service)

Thêm các phương thức (tên theo quy ước code hiện có), mỗi phương thức một truy vấn Cypher dưới đây:

```cypher
// A. Bảng đặc tả 8 hình
MATCH (s:Shape)
RETURN s.slug AS slug, s.name AS name, s.family AS family,
       s.specParallel AS specParallel, s.specSides AS specSides, s.specAngles AS specAngles,
       s.specDiagonals AS specDiagonals, s.specSymmetry AS specSymmetry
ORDER BY s.sortOrder;

// B. Cạnh IS_A kèm điều kiện
MATCH (a:Shape)-[r:IS_A]->(b:Shape)
RETURN a.slug AS tu, a.name AS tenTu, b.slug AS den, b.name AS tenDen, r.condition AS dieuKien
ORDER BY a.sortOrder, b.sortOrder;

// C. Hình cha trực tiếp kèm điều kiện (trang chi tiết)
MATCH (s:Shape {slug: $slug})-[r:IS_A]->(cha:Shape)
RETURN cha.slug AS slug, cha.name AS name, r.condition AS dieuKien ORDER BY cha.sortOrder;

// D. Hình con trực tiếp kèm điều kiện (trang chi tiết)
MATCH (con:Shape)-[r:IS_A]->(s:Shape {slug: $slug})
RETURN con.slug AS slug, con.name AS name, r.condition AS dieuKien ORDER BY con.sortOrder;

// E. Quan hệ giữa hai hình
MATCH (a:Shape {slug: $slugA}), (b:Shape {slug: $slugB})
RETURN EXISTS { (a)-[:IS_A*1..]->(b) } AS aLaDacBietCuaB,
       EXISTS { (b)-[:IS_A*1..]->(a) } AS bLaDacBietCuaA;

// F. Hình tổng quát chung gần nhất
MATCH p1 = (a:Shape {slug: $slugA})-[:IS_A*0..]->(c:Shape),
      p2 = (b:Shape {slug: $slugB})-[:IS_A*0..]->(c)
RETURN c.name AS hinhChung, length(p1) + length(p2) AS khoangCach
ORDER BY khoangCach LIMIT 1;

// G. Tính chất chung (khử trùng theo Property.id)
MATCH (a:Shape {slug: $slugA})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p:Property)
MATCH (b:Shape {slug: $slugB})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p)
RETURN DISTINCT p.id AS id, p.content AS noiDung ORDER BY noiDung;

// H. Tính chất chỉ có ở A (gọi lại với A, B đổi chỗ để lấy phần riêng của B)
MATCH (a:Shape {slug: $slugA})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p:Property)
WHERE NOT EXISTS {
  MATCH (:Shape {slug: $slugB})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p)
}
RETURN DISTINCT p.id AS id, p.content AS noiDung ORDER BY noiDung;
```

Service `So sánh(slugA, slugB)`:
- Kiểm tra `slugA != slugB` (nếu bằng nhau trả lỗi nghiệp vụ "chọn hai hình khác nhau"), kiểm tra hai slug tồn tại (không tồn tại → 404 hoặc thông báo rõ).
- Gọi E, F, G, H (hai lần cho H) và trả một model gồm: quan hệ (A là trường hợp đặc biệt của B / B là của A / không bao hàm nhau), hình chung gần nhất (chỉ cần khi không bao hàm), danh sách chung, danh sách riêng A, danh sách riêng B.
- Khi một hình là trường hợp đặc biệt của hình kia: danh sách riêng của hình tổng quát là rỗng, hiển thị "Không có" (đúng toán học, không phải lỗi).

### 3.2 Trang `/compare` (Controller + View)

Một trang gồm ba phần, giữ đúng phong cách vở ô li trong `DESIGN_BRIEF.md`:

1. **Bảng đặc tả 8 hình.** 8 hàng × 5 cột (cạnh song song, cạnh bằng nhau, góc, đường chéo, trục đối xứng), dữ liệu từ truy vấn A. Cột đầu là tên hình (chữ viết tay), nền nhạt theo `family` (họ hình thang `#E6DDF5`, họ bình hành `#D8F0E4`, họ diều `#FBE0E8`, tứ giác không tô). Ô "Không bắt buộc" hiển thị nhạt hơn nhưng vẫn đủ tương phản. Ở 360px: cuộn ngang **trong khung riêng** hoặc chuyển thành từng khối theo hình; **không để cả trang cuộn ngang**.
2. **Điều kiện giữa các hình.** Hiển thị 10 cạnh IS_A kèm `condition` (truy vấn B). Có nút "Xem sơ đồ quan hệ" tái sử dụng sơ đồ hiện có (xem 3.3). Có dạng danh sách luôn hiện, đọc được không cần sơ đồ, ví dụ: "Hình vuông là hình chữ nhật khi: hai cạnh kề bằng nhau". Tô dạ quang cụm điều kiện.
3. **So sánh hai hình.** Hai ô chọn hình (lấy danh sách từ Neo4j, không hard-code) + nút "So sánh". Kết quả chia ba khối "Quan hệ", "Giống nhau", "Khác nhau" (khối "Khác nhau" chia hai cột A/B). Dùng GET `/compare?a=...&b=...` để có thể chia sẻ link. Chọn cùng một hình → thông báo lỗi nhẹ ngay tại form, không gọi so sánh. Công thức/ký hiệu dùng KaTeX như các trang khác.

Thêm mục "So sánh các hình" vào thanh điều hướng/danh sách lối vào theo cách hiện có (không phá bố cục trang chủ).

### 3.3 Sơ đồ quan hệ hiện có: thêm điều kiện (PBI-33)

- Endpoint `/api/graph` (hoặc tên đang dùng) trả thêm `condition` trên mỗi cạnh.
- Trong sơ đồ: bấm vào một mũi tên (hoặc nhãn cạnh) thì hiện điều kiện của cạnh đó (ô ghi chú bên cạnh, có nút đóng).
- Trên màn hình nhỏ hoặc khi sơ đồ lỗi: có danh sách thay thế hiển thị cùng thông tin (chính là danh sách ở 3.2 mục 2).
- Giữ nguyên hành vi cũ: sơ đồ chỉ tải khi bấm nút, có nút đóng, lỗi thì báo rõ.

### 3.4 Trang chi tiết hình (Should, PBI-33)

Cột phụ "hình cha / hình con" (nếu đã có) hiển thị thêm `condition` cho hình cha trực tiếp, ví dụ: "Là hình chữ nhật khi: hai cạnh kề bằng nhau". Truy vấn C và D. Nếu cột phụ chưa có thì làm theo mô tả của `DESIGN_BRIEF.md`.

---

## 4. Giao diện: ràng buộc

`DESIGN_BRIEF.md` là nguồn sự thật. Nhắc lại các điểm hay bị bỏ sót:

- Trang vở ô li: lưới 24px, line-height là bội của 24px; 6 màu đã chốt; Patrick Hand cho tiêu đề, Be Vietnam Pro cho nội dung (subset `vietnamese`, kiểm tra dấu hiển thị đúng).
- **Không** dùng lưới thẻ giống hệt nhau cùng bo góc cùng đổ bóng; không nhãn IN HOA rải rác; không đánh số 01/02/03 vô nghĩa; không hiệu ứng trượt-hiện; không gradient trang trí; không thêm chuyển động mới (chỉ có hiệu ứng tự vẽ ở trang chủ như đã chốt).
- Đúng/Sai (nếu dùng) luôn kèm ký hiệu và chữ, không chỉ dựa vào màu.
- Văn phong: tiếng Việt đơn giản, câu chủ động, nút nói đúng việc ("So sánh", "Xem sơ đồ quan hệ", "Đóng"); lỗi và trạng thái rỗng nói rõ chuyện gì xảy ra và làm gì tiếp, không xin lỗi chung chung.
- Mobile 360px: không cuộn ngang toàn trang, vùng bấm đủ lớn, focus bàn phím nhìn thấy.
- Trước khi báo xong: mở trang ở 360px và 1280px, chụp ảnh, tự phê bình theo "Cách kiểm tra" trong brief và sửa.

---

## 5. Kết quả mẫu để tự kiểm tra (bộ seed gốc)

| Cặp hình | Quan hệ | Chung | Riêng hình 1 | Riêng hình 2 |
|---|---|---|---|---|
| Hình chữ nhật – Hình thoi | Không bao hàm nhau; hình chung gần nhất: Hình bình hành | 10 | 6 | 7 |
| Hình thoi – Hình diều | Hình thoi là trường hợp đặc biệt của hình diều | 7 | 10 | 0 |
| Hình vuông – Hình chữ nhật | Hình vuông là trường hợp đặc biệt của hình chữ nhật | 16 | 10 | 0 |
| Hình thang cân – Hình bình hành | Không bao hàm nhau; hình chung gần nhất: Hình thang | 6 | 4 | 4 |

Điều kiện 10 cạnh IS_A: xem `NEO4J_UPDATE_v2_2.md` Bước 2.
Nếu số liệu thực tế khác bảng trên, **không sửa code cho khớp**; báo người dùng để kiểm tra lại dữ liệu `Property` hoặc cập nhật tài liệu.

---

## 6. Các giai đoạn (mỗi giai đoạn xong thì dừng chờ "tiếp")

**Giai đoạn 1 – Đọc code và kiểm tra dữ liệu.** Mô tả ngắn (≤ 10 dòng) cấu trúc dự án hiện có, danh sách file bạn dự định sửa/thêm, và câu hỏi nếu có điểm chưa rõ. Kiểm tra dữ liệu Neo4j đã có `spec*` và `condition` (mục 2). Chưa viết code chức năng.

**Giai đoạn 2 – Tầng dữ liệu và trang `/compare` phần 1–2.** Repository/Service (truy vấn A–D), model, trang `/compare` với bảng đặc tả và danh sách điều kiện, thêm vào điều hướng. Kiểm tra: đủ 8 hàng × 5 cột từ Neo4j; 10 điều kiện; 360px không cuộn ngang trang; dừng Neo4j thì hiện trang lỗi thân thiện có nút "Thử lại".

**Giai đoạn 3 – So sánh hai hình (PBI-27).** Service so sánh (truy vấn E–H), phần 3 của trang `/compare`. Kiểm tra bằng bảng ở mục 5, kiểm tra chọn cùng một hình, slug sai.

**Giai đoạn 4 – Sơ đồ có điều kiện và trang chi tiết (PBI-33), tài liệu.** Cập nhật `/api/graph` và giao diện sơ đồ; cột hình cha/con ở trang chi tiết; cập nhật `README.md`, `docs/HUONG_DAN_SU_DUNG.md` (thêm mục "So sánh các hình" có ảnh chụp), `docs/test-cases.md` (thêm AC-18, AC-19, AC-20). Chạy lại toàn bộ trang cũ để chắc không lỗi.

---

## 7. Báo cáo cuối mỗi giai đoạn (định dạng)

1. Đã làm gì (2–5 dòng).
2. File đã thêm/sửa (danh sách đường dẫn).
3. Cách kiểm tra bạn đã chạy và kết quả.
4. Việc người dùng cần làm tiếp (nếu có).
5. Điểm chưa chắc chắn hoặc cần hỏi.

---

## 8. Không làm

- Không viết lại dự án, không đổi công nghệ, không thêm thư viện lớn (đã dùng vis-network cho sơ đồ thì dùng tiếp).
- Không hard-code học liệu, tên hình, điều kiện hay đặc tả trong View/JS: tất cả lấy từ Neo4j.
- Không tự chạy lệnh ghi dữ liệu vào Neo4j (migration do người dùng chạy).
- Không đưa mật khẩu Neo4j vào mã, JavaScript hoặc Git.
- Không thêm tính năng ngoài phạm vi (đăng nhập, admin, AI, kéo-thả hình học, offline).
