# PROMPT_SUA_SO_DO_v2_3.md – Làm sơ đồ quan hệ IS_A trực quan hơn

> Đặt file này ở gốc dự án cùng `NEO4J_UPDATE_v2_3.md`, `DESIGN_BRIEF.md`, `AGENT_PROMPT.md`, `PROMPT_BO_SUNG_v2_2.md`.
> Bạn là AI coding agent. Dự án **đã có** sơ đồ quan hệ (vis-network) và trang `/compare` từ các prompt trước. Nhiệm vụ lần này là **sửa và bổ sung phần sơ đồ**, không viết lại dự án. Đọc kỹ trước khi làm.

---

## 0. Nguyên tắc làm việc

1. **Đọc code hiện có trước** (view sơ đồ, JavaScript dựng vis-network, endpoint `/api/graph`, Repository liên quan). Làm theo quy ước đang dùng, không đổi kiến trúc, không đổi tên file/lớp cũ.
2. **Không phá chức năng cũ:** bấm vào hình để mở bài học, nút đóng, danh sách thay thế, trang `/compare`, trang chi tiết hình.
3. Làm theo 4 giai đoạn ở mục 7. Hết mỗi giai đoạn: chạy kiểm tra, báo ngắn gọn, dừng chờ "tiếp".
4. Mọi Cypher nằm trong Repository, dùng tham số. JavaScript không gọi Neo4j. Không hard-code điều kiện/lý do trong View/JS: tất cả lấy từ Neo4j.
5. Không tự ghi dữ liệu vào Neo4j. Người dùng tự chạy `NEO4J_UPDATE_v2_3.md`.
6. Thiếu thông tin hoặc mâu thuẫn với code hiện có thì hỏi người dùng. Không tự đoán. Commit Git sau mỗi giai đoạn.

---

## 1. Vấn đề hiện tại (so với ảnh chụp sơ đồ đang chạy)

- Nhãn trên mọi mũi tên chỉ là chữ "IS_A" nhỏ, màu đỏ, **xoay theo mũi tên**, khó đọc và không cho biết gì. Người học không biết "từ hình này thêm điều kiện gì thì thành hình gì".
- Bấm vào mũi tên chưa cho biết hai hình liên quan thế nào, vì sao có quan hệ cha–con.
- Sơ đồ chỉ chiếm một phần nhỏ giữa canvas, còn rất nhiều khoảng trống; chữ và hình nhỏ.
- Nút "Đóng sơ đồ" bị xuống hai dòng.

---

## 2. Dữ liệu mới (người dùng tự chạy `NEO4J_UPDATE_v2_3.md`)

Mỗi cạnh `(hình con)-[:IS_A]->(hình cha)` có 3 thuộc tính:

- `condition`: điều kiện đầy đủ (đã có từ bản 2.2).
- `conditionShort`: nhãn ngắn ≤ 30 ký tự, dùng **trên mũi tên** (ví dụ "có 1 góc vuông").
- `reason`: câu giải thích vì sao hình con là trường hợp đặc biệt của hình cha, dùng **trong panel**.

Việc đầu tiên: kiểm tra 10/10 cạnh có đủ 3 thuộc tính (truy vấn 2.1 trong `NEO4J_UPDATE_v2_3.md`). Thiếu thì **dừng và báo người dùng chạy file cập nhật**. Trong code, nếu `conditionShort` null thì tạm dùng `condition`; nếu `reason` null thì ẩn mục đó, không để trang lỗi.

---

## 3. Yêu cầu: sơ đồ trực quan hơn

### 3.1 Bỏ chữ "IS_A" trên mũi tên, thay bằng điều kiện

- **Xóa nhãn "IS_A"** khỏi mọi mũi tên.
- Mỗi mũi tên có nhãn là `conditionShort` viết dạng **"+ điều kiện"**, ví dụ "+ có 1 góc vuông".
- Nhãn phải **nằm ngang** (không xoay theo mũi tên), cỡ chữ ≥ 13px, có nền để đọc được khi đè lên đường: nền tô dạ quang `#FFE66D`, chữ Chì/Mực xanh, không viền. Không chữ đỏ nhỏ như hiện tại.
- Với vis-network: `edges.font = { align: 'horizontal', size: 13..14, background: '#FFE66D', strokeWidth: 0, color: <Chì> }`. Nếu các nhãn đè lên nhau, tăng khoảng cách giữa các tầng/nút trước, rồi mới cân nhắc rút gọn chữ.

### 3.2 Hai chiều đọc (chuyển bằng một nút)

Dữ liệu vẫn lưu `hình con → hình cha`, nhưng **hiển thị** có hai cách đọc:

- **"Thêm điều kiện" (mặc định):** mũi tên đi **từ hình cha xuống hình con**, đọc là "Hình chữ nhật **+ hai cạnh kề bằng nhau** → Hình vuông". Trả lời đúng câu "từ hình này thêm điều kiện thì thành hình gì". Bố cục dọc: Tứ giác ở trên, Hình vuông ở dưới.
- **"Theo IS_A":** mũi tên đi **từ hình con lên hình cha** như hiện tại (hình đặc biệt → hình tổng quát), nhãn hiển thị "là" kèm tên hình cha thay cho điều kiện, ví dụ "là hình chữ nhật".

Chỉ đổi cách vẽ (đảo hướng mũi tên ở lớp hiển thị); **không đổi dữ liệu hay Cypher**. Dùng hai nút dạng lựa chọn (radio/segmented) "Thêm điều kiện" | "Theo IS_A" phía trên sơ đồ, có trạng thái đang chọn rõ ràng.

Cập nhật dòng chú thích dưới tiêu đề cho khớp. Mặc định: "Mũi tên đi từ hình tổng quát đến hình đặc biệt. Chữ trên mũi tên là điều kiện cần thêm. Bấm vào mũi tên để xem vì sao hai hình có quan hệ; bấm vào hình để mở bài học."

### 3.3 Dùng hết không gian, dễ nhìn hơn

- Canvas cao khoảng `clamp(420px, 70vh, 720px)`; sau khi dựng xong gọi `network.fit({ animation: false })` để sơ đồ lấp đầy khung (có lề nhỏ), **không còn khoảng trống lớn hai bên**.
- Tăng khoảng cách: `layout.hierarchical.levelSeparation` ≈ 140–170, `nodeSpacing` ≈ 160–200 để nhãn không đè nhau. Giữ `physics: false` cho bố cục phân cấp.
- Nút (hình): chữ ≥ 15px, giữ màu nền theo họ hình đang dùng (họ thang `#E6DDF5`, họ bình hành `#D8F0E4`, họ diều `#FBE0E8`, tứ giác không tô), viền Mực xanh.
- Mũi tên: nét Mực xanh dày ~2px, đầu mũi tên rõ.
- **Nút "Đóng sơ đồ" không được xuống dòng** (`white-space: nowrap`, đủ chiều rộng).
- Thêm **chú thích (legend)** nhỏ dưới sơ đồ: ba màu họ hình và một dòng "Nhãn vàng: điều kiện cần thêm".

### 3.4 Dễ bấm vào mũi tên

- Mũi tên mảnh khó bấm. Cho phép bấm vào **nhãn** cũng chọn cạnh (vis-network coi nhãn là một phần của cạnh), tăng `edges.width` và `selectionWidth`, bật `interaction.hover`.
- Khi rê chuột/chạm vào một cạnh: cạnh đổi sang màu Lề đỏ `#D64550`, dày hơn, con trỏ dạng tay (`cursor: pointer`).
- Khi **chọn** một cạnh: tô nổi cạnh đó (Lề đỏ, dày), hai hình ở hai đầu có viền đậm; các hình và cạnh khác mờ đi (đây là phản hồi cho hành động, được phép; **không thêm hiệu ứng chuyển động nào khác**). Bấm ra ngoài hoặc bấm "Đóng" để bỏ chọn.
- Bấm vào **hình** vẫn mở bài học như cũ; chỉ bấm vào **cạnh** mới mở panel.

---

## 4. Yêu cầu: panel thông tin khi bấm vào mũi tên

Khi chọn một cạnh, hiển thị panel (cạnh phải sơ đồ ở màn hình rộng; **bottom sheet trượt từ dưới lên** hoặc khối ngay dưới sơ đồ ở màn hình ≤ 576px). Panel có nút "Đóng", đóng được bằng phím Esc, có `aria-live="polite"`, chuyển focus vào panel khi mở và trả focus về sơ đồ khi đóng.

Nội dung theo thứ tự (viết như ghi chép trên vở, không dùng ba thẻ giống hệt nhau):

1. **Tiêu đề:** "Hình vuông → Hình chữ nhật" (tên hai hình lấy từ dữ liệu).
2. **Quan hệ:** "Hình vuông là trường hợp đặc biệt của Hình chữ nhật." Chú thích nhỏ: hình con – hình cha.
3. **Thêm điều kiện (khối nổi bật, tô dạ quang):** "Hình chữ nhật **+ hai cạnh kề bằng nhau** = Hình vuông" (dùng `condition` đầy đủ).
4. **Vì sao có quan hệ cha–con:** hiển thị `reason`, bên dưới trích **định nghĩa của hai hình** (từ `Definition`) đặt cạnh nhau hoặc nối tiếp, dưới nhãn "Định nghĩa hình con" và "Định nghĩa hình cha".
5. **Hình con thừa hưởng gì từ hình cha:** danh sách tính chất hình con nhận được qua cạnh này (truy vấn 4.3 bên dưới), hiển thị tối đa 5 mục kèm dòng "Xem thêm n tính chất" mở rộng khi bấm; mỗi mục ghi nguồn (hình mà tính chất gắn vào). Nếu rỗng thì ẩn mục.
6. **Hành động:** nút "Mở bài học Hình vuông", "Mở bài học Hình chữ nhật", "So sánh hai hình này" (đi tới `/compare` với hai hình đã chọn; nếu trang so sánh hiện chưa hỗ trợ truyền tham số thì làm thêm tham số `a` và `b` trên query string, hoặc hỏi người dùng).

Công thức/ký hiệu trong nội dung dùng KaTeX như các trang khác. Văn phong: tiếng Việt đơn giản, câu chủ động.

Lỗi/rỗng: nếu truy vấn lỗi, panel hiển thị "Không tải được thông tin quan hệ này" kèm nút "Thử lại", **không** làm hỏng sơ đồ. Thiếu `reason` thì ẩn mục 4 phần lý do nhưng vẫn hiện định nghĩa.

---

## 5. Thay đổi phía backend

### 5.1 `/api/graph` (đã có)

Mỗi cạnh trả thêm `conditionShort`, `condition`, và (để ghép nhãn "Theo IS_A") tên hình cha. Giữ nguyên các trường đang có để không phá giao diện cũ.

```cypher
MATCH (a:Shape)-[r:IS_A]->(b:Shape)
RETURN a.slug AS tu, a.name AS tenTu, b.slug AS den, b.name AS tenDen,
       r.condition AS dieuKien, r.conditionShort AS dieuKienNgan
ORDER BY a.sortOrder, b.sortOrder;
```

### 5.2 Endpoint mới: thông tin một cạnh

`GET /api/relation?child={slugCon}&parent={slugCha}` trả JSON. Kiểm tra cả hai slug tồn tại và có cạnh `IS_A` giữa chúng (không có thì 404 với thông báo rõ). Hai truy vấn:

```cypher
// 4.1 Thông tin cạnh và định nghĩa hai hình
MATCH (c:Shape {slug: $child})-[r:IS_A]->(p:Shape {slug: $parent})
OPTIONAL MATCH (c)-[:HAS_DEFINITION]->(dc:Definition)
OPTIONAL MATCH (p)-[:HAS_DEFINITION]->(dp:Definition)
RETURN c.name AS hinhCon, p.name AS hinhCha, r.condition AS dieuKien, r.conditionShort AS dieuKienNgan,
       r.reason AS lyDo, dc.content AS dinhNghiaCon, dp.content AS dinhNghiaCha;

// 4.3 Tính chất hình con thừa hưởng qua cạnh này (khử trùng theo Property.id)
MATCH (:Shape {slug: $child})-[:IS_A]->(p:Shape {slug: $parent})
MATCH (p)-[:IS_A*0..]->(a:Shape)-[:HAS_PROPERTY]->(x:Property)
RETURN DISTINCT x.id AS id, x.content AS noiDung, a.name AS nguon
ORDER BY nguon, noiDung;
```

Model C# cho `conditionShort`, `reason` phải **cho phép null**.

---

## 6. Giao diện: ràng buộc từ `DESIGN_BRIEF.md`

- Phong cách vở ô li; 6 màu đã chốt (Giấy, Ô li, Lề đỏ, Mực xanh, Chì, Dạ quang). Nhãn điều kiện và khối "Thêm điều kiện" tô Dạ quang; cạnh được chọn dùng Lề đỏ.
- Patrick Hand cho tiêu đề, Be Vietnam Pro cho nội dung (subset `vietnamese`, dấu hiển thị đúng, kể cả chữ trong canvas vis-network: chỉ định `font.face` bằng font đã tải).
- Không lưới thẻ giống hệt nhau cùng bo góc cùng đổ bóng; không nhãn IN HOA rải rác; không đánh số vô nghĩa; không gradient trang trí; không thêm chuyển động ngoài phản hồi cho hành động (chọn/bỏ chọn cạnh, mở/đóng panel).
- Màu không phải kênh duy nhất truyền thông tin: cạnh được chọn còn đổi độ dày; tương phản chữ đủ đọc.
- Mobile 360px: không cuộn ngang toàn trang; panel là bottom sheet không che kín sơ đồ (tối đa ~60% chiều cao, cuộn nội dung bên trong); vùng bấm ≥ 44px; có **danh sách thay thế** (đã có từ bản 2.2) hiển thị đủ điều kiện và lý do khi bấm từng mục, cho người không dùng được sơ đồ.
- Trước khi báo xong: mở ở 360px và 1280px, chụp ảnh, tự phê bình theo "Cách kiểm tra" trong brief; so sánh với ảnh chụp cũ để chắc các vấn đề ở mục 1 đã hết.

---

## 7. Các giai đoạn (mỗi giai đoạn xong thì dừng chờ "tiếp")

**Giai đoạn 1 – Đọc code và kiểm tra dữ liệu.** Mô tả ngắn (≤ 10 dòng) cách sơ đồ và `/api/graph` đang hoạt động, danh sách file dự định sửa/thêm, câu hỏi nếu có. Kiểm tra 10/10 cạnh có `condition`, `conditionShort`, `reason`. Chưa viết code chức năng.

**Giai đoạn 2 – Nhãn và bố cục sơ đồ (mục 3.1, 3.3).** Bỏ "IS_A", nhãn điều kiện ngang trên nền dạ quang, fit canvas, tăng khoảng cách, legend, nút "Đóng sơ đồ" không xuống dòng. Kiểm tra: không nhãn nào bị cắt hoặc đè nhau; ảnh chụp 360px và 1280px.

**Giai đoạn 3 – Hai chiều đọc và tương tác cạnh (mục 3.2, 3.4).** Nút chọn chiều đọc, hover/chọn cạnh, làm mờ phần còn lại, phân biệt bấm cạnh với bấm hình. Kiểm tra bằng chuột và bằng chạm.

**Giai đoạn 4 – Panel thông tin cạnh và tài liệu (mục 4, 5).** Endpoint `/api/relation`, panel đủ 6 mục, bottom sheet trên mobile, Esc/focus, xử lý lỗi. Cập nhật `docs/HUONG_DAN_SU_DUNG.md` (mục sơ đồ quan hệ, kèm ảnh chụp mới) và `docs/test-cases.md` (thêm ca kiểm tra bấm mũi tên). Chạy lại các trang cũ để chắc không lỗi.

---

## 8. Kiểm tra nghiệm thu

| Ca kiểm tra | Kết quả mong đợi |
|---|---|
| Mở sơ đồ | Không còn chữ "IS_A" trên mũi tên; mỗi mũi tên có nhãn điều kiện nằm ngang, đọc được |
| Chế độ "Thêm điều kiện" | Mũi tên đi từ Tứ giác xuống Hình vuông; Hình chữ nhật → Hình vuông ghi "+ có 2 cạnh kề bằng nhau" |
| Chế độ "Theo IS_A" | Mũi tên đi từ hình con lên hình cha, nhãn ghi "là ..." |
| Bấm mũi tên Hình vuông – Hình chữ nhật | Panel đủ 6 mục; điều kiện "hai cạnh kề bằng nhau"; lý do "bốn góc vuông nên thỏa định nghĩa hình chữ nhật"; hai định nghĩa; tính chất thừa hưởng (hình chữ nhật có 16 tính chất kể cả kế thừa) |
| Bấm mũi tên Hình thoi – Hình diều | Điều kiện "bốn cạnh bằng nhau"; lý do giải thích định nghĩa bao hàm |
| Bấm vào hình | Vẫn mở bài học như cũ |
| Dữ liệu thiếu `reason` | Panel vẫn hiện, ẩn phần lý do, không lỗi |
| Dừng Neo4j rồi bấm mũi tên | Panel báo không tải được kèm "Thử lại"; sơ đồ vẫn dùng được |
| 360px | Không cuộn ngang trang; panel là bottom sheet; danh sách thay thế dùng được |
| Phím Esc | Đóng panel, bỏ chọn cạnh, focus về sơ đồ |

---

## 9. Báo cáo cuối mỗi giai đoạn

1. Đã làm gì (2–5 dòng).
2. File đã thêm/sửa.
3. Cách kiểm tra đã chạy và kết quả (kèm ảnh chụp nếu có).
4. Việc người dùng cần làm tiếp.
5. Điểm chưa chắc chắn hoặc cần hỏi.

## 10. Không làm

- Không viết lại dự án, không đổi công nghệ, không thêm thư viện lớn (tiếp tục dùng vis-network).
- Không hard-code nhãn, điều kiện, lý do, định nghĩa trong View/JS.
- Không đổi chiều lưu `IS_A` trong Neo4j (vẫn hình con → hình cha); chỉ đổi cách hiển thị.
- Không tự ghi dữ liệu vào Neo4j; không đưa mật khẩu vào mã hoặc Git.
