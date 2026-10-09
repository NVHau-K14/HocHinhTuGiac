# PROMPT_XUONG_VE_v2_4.md – Thêm tab "Xưởng vẽ": kéo thả hình theo thời gian thực

> Đặt file này ở gốc dự án cùng `DESIGN_BRIEF.md`, `AGENT_PROMPT.md` và các prompt trước.
> Bạn là AI coding agent. Dự án **đã có** nhiều chức năng (khám phá, chi tiết hình, so sánh, sơ đồ IS_A, luyện tập, quiz...). Lần này **thêm một tab mới** vào header, không viết lại dự án. Đọc kỹ toàn bộ file trước khi làm.

---

## 0. Nguyên tắc làm việc

1. **Đọc code hiện có trước** (layout, header/nav, cách dựng trang, CSS vở ô li, KaTeX, Repository, endpoint JSON). Làm theo quy ước đang dùng, không đổi kiến trúc, không đổi tên file/lớp cũ.
2. **Không phá chức năng cũ.** Chạy lại các trang cũ sau mỗi giai đoạn.
3. Làm theo 5 giai đoạn ở mục 9. Hết mỗi giai đoạn: chạy kiểm tra, báo ngắn gọn, dừng chờ người dùng gõ "tiếp".
4. Không bịa. Thiếu thông tin hoặc mâu thuẫn với code hiện có thì hỏi người dùng bằng danh sách câu hỏi ngắn.
5. Mọi Cypher nằm trong Repository, dùng tham số. JavaScript không gọi Neo4j trực tiếp, không chứa mật khẩu.
6. Không tự ghi dữ liệu vào Neo4j. Tính năng này **không cần migration mới** (chỉ đọc dữ liệu đã có).
7. Commit Git sau mỗi giai đoạn.

---

## 1. Ý tưởng

Tab **"Xưởng vẽ"** (route `/lab`) là bảng vẽ trên **trang vở ô li**: người học kéo thả đỉnh của tứ giác hoặc nhập số, và **thấy ngay** độ dài cạnh, góc, đường chéo, chu vi, diện tích, công thức thay đổi theo. Hệ thống tự **nhận dạng** hình đang vẽ (hình thang, bình hành, chữ nhật...) dựa trên cây IS_A trong Neo4j và nói rõ **điều kiện nào vừa được thêm hoặc mất** khi hình đổi loại. Đây là nơi người học "thấy" quan hệ cha–con giữa các hình bằng tay.

Điểm độc đáo cần làm thật tốt (đừng làm mờ nhạt):

1. Kéo một đỉnh của hình chữ nhật → hình tự đổi thành hình bình hành, giao diện nói: "Không còn: có một góc vuông" (lấy từ `condition` của cạnh IS_A).
2. Công thức hiển thị **có thay số** và được **kiểm chứng chéo** với diện tích tính từ tọa độ.
3. Ký hiệu hình học (gạch cạnh bằng nhau, mũi tên song song, ô vuông góc vuông, cung góc) **tự xuất hiện khi tính chất đúng** và biến mất khi sai.

---

## 2. Phạm vi

| Mức | Nội dung |
|---|---|
| **Must** | Tab "Xưởng vẽ"; bảng vẽ SVG có lưới và bắt lưới; 8 hình mẫu; kéo thả đỉnh (chuột, chạm, bàn phím); nhập số; số đo trực tiếp; công thức có thay số + kiểm chứng; ký hiệu tự động; nhận dạng hình + chuỗi IS_A; thông báo thêm/mất điều kiện; hoàn tác/làm lại/đặt lại; chia sẻ bằng URL; giới hạn tứ giác lồi; responsive 360px; trợ năng |
| **Should** | "Áp dụng điều kiện" (10 quy tắc, mục 6.6); "Thử thách" tự sinh từ IS_A; xuất ảnh PNG/SVG; danh sách tính chất đúng/sai của hình hiện tại; lớp trục đối xứng; chọn tỉ lệ ô lưới |
| **Could** | Lưu "Vở của tôi" cho người học; gợi ý "nam châm" khi gần thành hình đặc biệt; thu phóng bằng cử chỉ; đường tròn nội/ngoại tiếp |

Không làm: chỉnh sửa ảnh chụp/bitmap, vẽ đa giác nhiều hơn 4 đỉnh, hình 3D, vẽ tự do bằng bút, AI nhận dạng nét vẽ, thư viện đồ họa lớn (không dùng Konva, Fabric, p5, GeoGebra...). Dùng **SVG thuần + JavaScript thuần** (Pointer Events).

---

## 3. Dữ liệu từ Neo4j (chỉ đọc)

Một endpoint JSON duy nhất `GET /api/lab/meta`, trả:

```
{
  shapes:   [{ slug, name, family, sortOrder }],
  isa:      [{ tu, den, condition, conditionShort }],         // tu = hình con, den = hình cha
  formulas: [{ slug, id, name, expression, note }]            // công thức theo hình
}
```

```cypher
// shapes
MATCH (s:Shape) RETURN s.slug AS slug, s.name AS name, s.family AS family, s.sortOrder AS sortOrder ORDER BY s.sortOrder;

// isa (conditionShort có thể null: dùng condition thay thế)
MATCH (a:Shape)-[r:IS_A]->(b:Shape)
RETURN a.slug AS tu, b.slug AS den, r.condition AS condition, r.conditionShort AS conditionShort
ORDER BY a.sortOrder, b.sortOrder;

// formulas
MATCH (s:Shape)-[:HAS_FORMULA]->(f:Formula)
RETURN s.slug AS slug, f.id AS id, f.name AS name, f.expression AS expression, f.note AS note
ORDER BY s.sortOrder, f.id;
```

Quy tắc:
- **Tên hình, quan hệ cha–con, điều kiện, biểu thức công thức đều lấy từ endpoint này**, không hard-code trong View/JS. (Code chỉ chứa thuật toán hình học, tọa độ hình mẫu và bảng ánh xạ id công thức → hàm tính.)
- Có thể dùng thêm endpoint tính chất hiện có (hoặc thêm `GET /api/lab/properties/{slug}` dùng truy vấn tính chất trực tiếp + kế thừa của dự án) cho mục "Tính chất của hình này" (Should).
- Lỗi Neo4j: bảng vẽ vẫn mở, vùng tên hình/công thức hiển thị "Không tải được dữ liệu hình mẫu" kèm nút "Thử lại"; không lộ stack trace.

---

## 4. Bố cục và giao diện

`DESIGN_BRIEF.md` là nguồn sự thật. Tab mới thêm vào header **sau mục "So sánh"** với nhãn **"Xưởng vẽ"**, trạng thái đang chọn rõ ràng.

### 4.1 Wireframe (màn hình ≥ 992px)

```
+--------------------------------------------------------------------+
| Hình mẫu: [Tứ giác][Hình thang][Thang cân][Bình hành][Chữ nhật]...|
| Chế độ: (•) Theo hình mẫu ( ) Tự do   Bước: [1 ô v]  [x] Bắt lưới  |
| Hiện: [x]Cạnh [x]Góc [x]Đường chéo [x]Ký hiệu   [Hoàn tác][Làm lại]|
+--------------------------------------+-----------------------------+
|                                      | [Số đo][Công thức][Nhận dạng][Thử thách]
|   BẢNG VẼ (SVG, lưới 24px)          |                             |
|   - đỉnh A B C D kéo được            |  (nội dung tab đang chọn)   |
|   - cạnh, góc, đường chéo, ký hiệu   |                             |
|                                      |                             |
+--------------------------------------+-----------------------------+
| Thanh trạng thái: "Hình chữ nhật (cũng là hình bình hành, hình thang cân, hình thang, tứ giác)" |
+--------------------------------------------------------------------+
```

- Màn hình < 992px: bảng vẽ ở trên, các tab xuống dưới (cuộn dọc), thanh công cụ thu gọn thành hàng cuộn ngang **trong khung riêng**. Ở 360px không cuộn ngang toàn trang.
- **Không** dùng lưới thẻ giống hệt nhau cùng bo góc cùng đổ bóng. Panel phải là các khối ghi chép khác nhau (có chỗ tô dạ quang, có chỗ kẻ ô), bo góc nhỏ và không đồng nhất.
- Thanh "Hình mẫu": danh sách hình mẫu lấy từ Neo4j; mỗi nút có tên hình viết tay (Patrick Hand) và hình SVG mini (dùng lại asset SVG của trang chủ nếu có).

### 4.2 Bảng vẽ

- Nền kẻ ô **đồng bộ với hệ tọa độ**: 1 ô = 1 cm = 24px ở mức thu phóng 100% (khớp lưới 24px của brief). Vẽ lưới bằng SVG `<pattern>` hoặc CSS gradient căn theo hệ tọa độ, **không dùng ảnh**.
- Hệ tọa độ toán học: gốc ở góc dưới-trái vùng hiển thị, trục y hướng lên (khi vẽ SVG đổi dấu y). Đánh số trục thưa (mỗi 5 ô) bằng chữ nhỏ.
- Màu: nét hình **Mực xanh**; số đo góc và ký hiệu góc/chấm bài **Lề đỏ**; độ dài cạnh **Chì**; phần vừa thay đổi và khối "điều kiện" **Dạ quang**; nền **Giấy**; lưới **Ô li**.
- Đỉnh: vòng tròn nhỏ (bán kính vẽ ~6px) nhưng **vùng bấm ≥ 44px** (phần tử trong suốt lớn hơn). Khi kéo: hiện chú thích tọa độ gần đỉnh, ví dụ "B(6; 4)".
- Nút: "Vừa khung" (đưa hình vào giữa, phóng vừa), "+" "−" để thu phóng. Chuyển động duy nhất được phép: phản hồi hành động ngắn (≤ 300ms, ví dụ hình mượt đổi sang hình mẫu mới); tôn trọng `prefers-reduced-motion` (tắt hẳn).
- Văn phong giao diện: tiếng Việt đơn giản, câu chủ động, nút nói đúng việc ("Hoàn tác", "Làm lại", "Đặt lại hình", "Tải ảnh PNG"). Lỗi và trạng thái rỗng nói rõ chuyện gì xảy ra và làm gì tiếp, không xin lỗi chung chung.

---

## 5. Mô hình trạng thái

```
state = {
  mode: 'param' | 'free',          // "Theo hình mẫu" | "Tự do"
  preset: <slug hình mẫu>,         // ở chế độ 'param'
  params: { ... },                 // tham số của hình mẫu (mục 6.2)
  vertices: [A, B, C, D],          // mỗi đỉnh {x, y} theo cm; ở 'param' được suy ra từ params
  snap: { on: true, step: 1 },     // step: 1 | 0.5 | 0 (tự do)
  layers: { sides, angles, diagonals, marks },
  history: { undo: [], redo: [] }
}
```

- **Theo hình mẫu:** hình luôn giữ đúng loại khi kéo/nhập (kéo tay nắm là đổi **tham số**). Có nút **"Mở khóa để kéo tự do"** chuyển sang `free` giữ nguyên 4 đỉnh hiện tại.
- **Tự do:** 4 đỉnh kéo độc lập; loại hình được **nhận dạng liên tục**. Nút "Về hình mẫu" quay lại hình mẫu gần nhất (hình cụ thể nhất đang nhận dạng, nếu không có thì Tứ giác).
- **Hoàn tác/Làm lại:** mỗi lần thả chuột/xác nhận ô nhập là một mục lịch sử (tối đa 100). Phím Ctrl+Z / Ctrl+Y (hoặc Ctrl+Shift+Z).
- **Đặt lại hình:** quay về hình mẫu mặc định đang chọn.

### 5.1 Ràng buộc luôn đúng (tứ giác lồi)

Bài học nói về tứ giác lồi, và công thức diện tích/đường chéo chỉ đúng khi lồi. Vì vậy:
- Một thao tác (kéo, nhập số, áp dụng điều kiện) **chỉ được chấp nhận nếu kết quả là tứ giác lồi, không tự cắt**: tích có hướng của các cặp cạnh liên tiếp cùng dấu, và mỗi cạnh dài ≥ 0,5 cm, diện tích ≥ 1 cm².
- Nếu không hợp lệ: đỉnh **giữ ở vị trí hợp lệ cuối cùng**, bảng vẽ rung nhẹ viền hoặc đổi viền sang Lề đỏ, và dòng thông báo (aria-live) nói rõ: "Hình sẽ bị lõm hoặc tự cắt. Hãy kéo đỉnh về phía khác."
- Giới hạn tọa độ: |x|, |y| ≤ 50 cm khi nhập số.

---

## 6. Lõi hình học (viết thành module thuần, không phụ thuộc DOM)

Tạo các module (đặt tên/đường dẫn theo quy ước dự án, ví dụ `wwwroot/js/lab/`): `geometry.js`, `classify.js`, `presets.js`, `formulas.js` (thuần, chạy được bằng Node để kiểm thử) và `lab.js`, `lab.css` (giao diện). Dùng ES module nếu dự án đã dùng; nếu không, dùng IIFE và xuất một đối tượng chung.

### 6.1 Số đo (`geometry.js`)

Từ đỉnh A, B, C, D tính: độ dài AB, BC, CD, DA, hai đường chéo AC, BD; bốn góc trong A, B, C, D (độ, đo giữa hai cạnh kề tại đỉnh, tức góc trong của tứ giác lồi) và tổng (luôn 360°); chu vi; diện tích (công thức tọa độ/"dây giày": S = ½|Σ(xᵢyᵢ₊₁ − xᵢ₊₁yᵢ)|); giao điểm O của hai đường chéo; trung điểm hai đường chéo; chiều cao khi có cặp cạnh song song (khoảng cách giữa hai đường thẳng song song).

Hiển thị số bằng dấu phẩy thập phân tiếng Việt ("7,07"), làm tròn 2 chữ số; số nguyên không có phần thập phân thừa ("6", không phải "6,00"). Đơn vị cm, cm² (viết đúng ký hiệu, độ °).

### 6.2 Hình mẫu và tham số (`presets.js`)

Mỗi hình mẫu khai báo: `slug`, tham số + giới hạn, hàm dựng đỉnh từ tham số, danh sách **tay nắm** (đỉnh nào kéo được) và hàm **ánh xạ ngược** từ vị trí đã bắt lưới sang tham số. Hệ tọa độ cm, y hướng lên. **Giá trị mặc định** (đã kiểm tra thủ công, phải qua kiểm thử mục 8):

| slug | Tham số | Đỉnh mặc định A, B, C, D |
|---|---|---|
| `tu-giac` | (tự do, không tham số) | A(0;0) B(7;1) C(6;5) D(1;3) |
| `hinh-thang` | a (đáy dưới) = 8, b (đáy trên) = 4, h = 3, s (độ lệch) = 1 | A(0;0) B(8;0) C(5;3) D(1;3) |
| `hinh-thang-can` | a = 8, b = 4, h = 3 | A(0;0) B(8;0) C(6;3) D(2;3) |
| `hinh-binh-hanh` | a = 6, b = 3,61 hoặc (dx; dy) = (2; 3) | A(0;0) B(6;0) C(8;3) D(2;3) |
| `hinh-chu-nhat` | a = 6, b = 4 | A(0;0) B(6;0) C(6;4) D(0;4) |
| `hinh-thoi` | d₁ = AC, d₂ = BD (hai đường chéo vuông góc, cắt nhau tại trung điểm) | A(0;0) B(5;0) C(8;4) D(3;4) |
| `hinh-vuong` | a = 5 | A(0;0) B(5;0) C(5;5) D(0;5) |
| `hinh-dieu` | d₁ = AC (trục) = 8, d₂ = BD = 6, p = AO = 2 | A(0;0) B(3;2) C(0;8) D(−3;2) |

Gợi ý: hình bình hành tham số theo vectơ cạnh AB = (a; 0) và AD = (dx; dy); hình thoi nên tham số theo hai đường chéo để khớp với công thức S = d₁·d₂/2; hình diều theo trục AC, đoạn AO và độ dài BD (B, D đối xứng qua AC). Điều chỉnh mặc định của hình thoi/diều/thang cho phù hợp tham số nếu cần, **miễn là qua các kiểm thử ở mục 8** (đặc biệt: mỗi hình mẫu nhận dạng ra đúng chính nó và đúng tập hình cha theo IS_A).

**Tay nắm khi ở chế độ hình mẫu:** kéo đỉnh C của hình chữ nhật đổi (a, b); kéo đỉnh B của hình vuông đổi a (giữ vuông); kéo đỉnh trên của hình thang đổi b, h, s; v.v. Mỗi hình có ít nhất 2 tay nắm. Tay nắm hiển thị khác đỉnh thường (viền đặc, kèm mũi tên nhỏ chỉ hướng kéo được); đỉnh không kéo được vẽ mờ và có chú thích "Đỉnh này đi theo hình mẫu. Bấm 'Mở khóa để kéo tự do' để kéo."

### 6.3 Nhận dạng hình (`classify.js`)

Đầu vào: 4 đỉnh (đã hợp lệ lồi). Dung sai: độ dài bằng nhau nếu |x − y| ≤ 0,02 cm; góc bằng nhau nếu |α − β| ≤ 0,5°; hai cạnh song song nếu góc giữa hai vectơ ≤ 0,5° (hoặc 180°); vuông góc nếu | α − 90° | ≤ 0,5°. (Khi **bắt lưới** bật, tọa độ nguyên nên các so sánh gần như chính xác; khi bắt lưới tắt, hình kéo tay hiếm khi thành hình đặc biệt, đó là hành vi đúng.)

Các điều kiện (theo **định nghĩa bao hàm** của dự án):
- `tu-giac`: luôn đúng.
- `hinh-thang`: có ít nhất một cặp cạnh đối song song (AB ∥ CD hoặc BC ∥ DA).
- `hinh-thang-can`: là hình thang và có hai góc kề một đáy bằng nhau (với cặp đáy song song: ∠A = ∠B hoặc ∠C = ∠D khi đáy là AB, CD; ∠B = ∠C hoặc ∠A = ∠D khi đáy là BC, DA).
- `hinh-binh-hanh`: cả hai cặp cạnh đối song song.
- `hinh-chu-nhat`: hình bình hành có một góc vuông.
- `hinh-thoi`: bốn cạnh bằng nhau.
- `hinh-vuong`: vừa là hình chữ nhật vừa là hình thoi.
- `hinh-dieu`: (AB = AD và CB = CD) hoặc (AB = BC và CD = DA).

Kết quả: tập tất cả hình thỏa; **loại cụ thể nhất** = các hình trong tập mà không có hình con nào (theo `isa` từ Neo4j) cũng nằm trong tập; danh sách "cũng là" = các hình cha (kể cả gián tiếp) qua IS_A. Nếu có nhiều hình cụ thể nhất, nối bằng "vừa là ... vừa là ...".

**Kiểm tra nhất quán với Neo4j:** với mỗi hình mẫu, tập thỏa phải đúng bằng {chính nó} ∪ tổ tiên theo `isa`. Nếu không, **không sửa dữ liệu**; báo người dùng và sửa dung sai/hình mẫu.

### 6.4 Thông báo thêm/mất điều kiện

Khi tập "loại cụ thể nhất" đổi (so với trước thao tác):
- Tìm đường đi ngắn nhất giữa hình cũ và hình mới trong đồ thị `isa` (đi lên hoặc đi xuống) và nối các `condition` dọc đường đi bằng " và ".
- **Đi xuống** (đặc biệt hóa, ví dụ Hình chữ nhật → Hình vuông): "Đã thêm điều kiện: hai cạnh kề bằng nhau. Hình chữ nhật trở thành Hình vuông." (tô dạ quang).
- **Đi lên** (mất tính chất, ví dụ Hình chữ nhật → Hình bình hành): "Không còn: có một góc vuông. Hình chữ nhật trở thành Hình bình hành."
- Không có đường đi trực tiếp (hai hình khác nhánh, ví dụ Hình thang cân → Hình bình hành): "Hình đổi từ A thành B." kèm hai dòng: điều kiện mất (về hình tổng quát chung gần nhất) và điều kiện thêm (xuống hình mới).
- Thông báo cập nhật khi **thả chuột/chạm** (không nhấp nháy khi đang kéo); trong lúc kéo chỉ cập nhật nhãn loại hình ở thanh trạng thái. Có `aria-live="polite"`.

### 6.5 Công thức có thay số (`formulas.js`)

Biểu thức công thức lấy từ Neo4j (chuỗi LaTeX dùng cho KaTeX). Code chỉ chứa **bộ tính theo `Formula.id`**, nhận các đỉnh và trả `{ values, latexFilled, result }`. Hiển thị bằng KaTeX: dòng công thức gốc, dòng thay số, dòng kết quả (đơn vị). Quy ước biến cho mỗi `Formula.id` của bộ seed hiện tại:

| Formula.id | Cách tính từ 4 đỉnh |
|---|---|
| `F-TG-TONG-GOC` | liệt kê bốn góc, tổng = 360° |
| `F-HT-DIEN-TICH` | chọn cặp cạnh song song (ưu tiên AB ∥ CD): a = AB, b = CD, h = khoảng cách giữa hai đường; S = (a + b)·h/2 |
| `F-HT-DUONG-TRUNG-BINH` | m = (a + b)/2 với a, b như trên |
| `F-HBH-DIEN-TICH` | a = AB, h = khoảng cách từ D đến đường AB; S = a·h |
| `F-HBH-CHU-VI`, `F-HCN-CHU-VI` | P = 2(a + b), a = AB, b = BC |
| `F-HCN-DIEN-TICH` | S = a·b, a = AB, b = BC |
| `F-HCN-CHEO` | d = √(a² + b²) |
| `F-S-HAI-CHEO` | d₁ = AC, d₂ = BD; S = d₁·d₂/2 (chỉ hiển thị khi hai đường chéo vuông góc) |
| `F-THOI-CHU-VI`, `F-VUONG-CHU-VI` | P = 4a, a = AB |
| `F-VUONG-DIEN-TICH` | S = a² |
| `F-VUONG-CHEO` | d = a√2 |

- Hiển thị công thức của **hình cụ thể nhất** trước, rồi mục thu gọn "Công thức kế thừa" gồm công thức của các hình cha (một hình có nhiều cách tính diện tích, đó là bài học). Khử trùng theo `Formula.id`; chỉ hiển thị công thức **áp dụng được** với hình hiện tại.
- `Formula.id` không có bộ tính: hiển thị công thức gốc không thay số, kèm ghi chú "Chưa có bộ tính cho công thức này." (không lỗi).
- **Kiểm chứng chéo:** với mọi công thức diện tích, so với diện tích từ tọa độ (6.1). Khớp (sai lệch ≤ 0,01) thì hiển thị "✓ Khớp với diện tích tính từ tọa độ"; lệch thì hiển thị "✗ Lệch ..." kèm gợi ý (thường do hình chưa đúng loại). Không chỉ dùng màu: luôn kèm ký hiệu và chữ.

### 6.6 "Áp dụng điều kiện" (Should)

Ở tab "Nhận dạng": với hình cụ thể nhất hiện tại, liệt kê các hình con trực tiếp (theo `isa`) kèm `condition`, mỗi hình có nút **"Thử điều kiện này"**. Bấm thì **biến đổi hình hiện tại** để thỏa điều kiện (hoàn tác được, có thông báo ở 6.4). Quy tắc (giữ nguyên A, B; ký hiệu û = vectơ đơn vị, n̂ = pháp tuyến hướng vào trong hình):

| Từ → Đến | Cách biến đổi |
|---|---|
| Tứ giác → Hình thang | giữ A, B, C; D' = C − |CD|·û(AB) (CD ∥ AB) |
| Tứ giác → Hình diều | giữ A, B, C; D' = đối xứng của B qua đường AC |
| Hình thang → Hình thang cân | giữ hai đáy và chiều cao; đặt C, D đối xứng qua trung trực AB |
| Hình thang → Hình bình hành | giữ A, B, C; D' = A + (C − B) |
| Hình bình hành → Hình chữ nhật | D' = A + |AD|·n̂(AB); C' = B + (D' − A) |
| Hình thang cân → Hình chữ nhật | D' = A + h·n̂(AB); C' = B + (D' − A) |
| Hình bình hành → Hình thoi | D' = A + |AB|·û(AD); C' = B + (D' − A) |
| Hình diều → Hình thoi | giữ trục AC và độ dài BD; đặt B, D đối xứng qua AC tại trung điểm O của AC |
| Hình chữ nhật → Hình vuông | D' = A + |AB|·n̂(AB); C' = B + (D' − A) |
| Hình thoi → Hình vuông | giữ giao điểm O và đường chéo AC; đặt BD = AC (vuông góc tại O) |

Mỗi phép biến đổi phải **qua kiểm tra lồi (5.1)** và, sau khi áp dụng, kết quả nhận dạng phải đúng hình đích (kiểm thử mục 8). Nếu biến đổi cho kết quả không hợp lệ thì hiện thông báo rõ, không đổi hình.

---

## 7. Tính năng bổ sung để hoàn thiện

### 7.1 Ký hiệu hình học tự động (Must)

Vẽ lớp "Ký hiệu" theo kết quả đo (cùng dung sai ở 6.3): gạch nhỏ trên các cạnh bằng nhau (1 gạch, 2 gạch cho nhóm khác); mũi tên `>` và `>>` trên các cặp cạnh song song; ô vuông ở góc vuông; cung góc kèm số đo (đỏ) ở lớp "Góc"; đường chéo nét đứt, điểm O, dấu trung điểm; dấu vuông góc tại O khi hai đường chéo vuông góc. Mỗi lớp bật/tắt độc lập. Ký hiệu **xuất hiện/biến mất tức thì** theo hình.

### 7.2 Nhập số (Must)

Tab "Số đo" có ô nhập, **thay đổi ô là hình đổi ngay** (khi gõ xong, hoặc sau 300ms ngừng gõ; Enter xác nhận, Esc hoàn lại):
- Chế độ hình mẫu: ô theo tham số của hình (ví dụ chữ nhật: a, b).
- Chế độ tự do: tọa độ x, y của từng đỉnh; thêm ô chiều dài AB, BC, CD (đổi độ dài thì đỉnh cuối của cạnh đó trượt dọc theo hướng cạnh; DA và các góc chỉ đọc).
- Chấp nhận dấu phẩy hoặc dấu chấm thập phân. Giá trị sai/ngoài giới hạn/làm hình lõm: viền Lề đỏ kèm ✗ và câu giải thích cụ thể ("a phải từ 1 đến 20 cm"), **giữ hình cũ**.
- Mỗi ô có nhãn rõ (`<label>`), `inputmode="decimal"`.

### 7.3 Chia sẻ bằng URL (Must)

Trạng thái đồng bộ lên query string để dán link chia sẻ được: `/lab?shape=hinh-chu-nhat&a=6&b=4` (hình mẫu) hoặc `/lab?mode=free&pts=0,0;6,0;6,4;0,4` (tự do), cộng `snap`, `step`. Khi mở link: phân tích và **kiểm tra chặt** (số hợp lệ, trong giới hạn, lồi); sai thì dùng hình mặc định và báo "Liên kết này không hợp lệ, đã mở hình mặc định." Không đưa dữ liệu nhạy cảm vào URL. Nút "Sao chép liên kết".

### 7.4 Tính chất của hình hiện tại (Should)

Tab "Nhận dạng" có danh sách kiểm tra các tính chất của hình cụ thể nhất (từ Neo4j, kể cả kế thừa) với trạng thái ✓/✗ theo số đo thật, ví dụ "Hai đường chéo bằng nhau ✓". Dùng để người học thấy tính chất nào còn giữ được khi kéo. Chỉ hiển thị các tính chất có bộ kiểm tra (bảng ánh xạ `Property.id` → hàm kiểm trong code); tính chất chưa có bộ kiểm thì ẩn, không lỗi.

### 7.5 Thử thách (Should)

Tab "Thử thách", **sinh tự động từ cây IS_A, không cần thêm dữ liệu**:
- Dạng 1: "Biến **[hình cha]** thành **[hình con]**." Bắt đầu từ hình mẫu cha; gợi ý (sau lần thử sai đầu tiên hoặc khi bấm "Gợi ý") là `condition` của cạnh. Đạt khi nhận dạng thấy hình con.
- Dạng 2 (sinh số bằng mẫu trong code, 4 mẫu): hình chữ nhật có chu vi P và diện tích S cho trước (chọn từ cặp (a, b) nguyên, ví dụ P = 20, S = 24); hình vuông có đường chéo cho trước; hình thoi có hai đường chéo cho trước; hình thang có diện tích và chiều cao cho trước.
- Kết quả: "Đúng ✓" hoặc "Chưa đúng ✗" kèm lý do cụ thể (ví dụ "Chu vi hiện là 18 cm, cần 20 cm"), nút "Làm lại" và "Câu khác". Tiến độ chỉ lưu trong phiên (không ghi Neo4j).
- Không chấm bằng so sánh số thập phân chính xác: dùng dung sai 0,02.

### 7.6 Xuất ảnh (Should)

"Tải ảnh PNG" và "Tải SVG" của bảng vẽ hiện tại (kèm lưới và số đo). Với PNG, nhúng/đổi font an toàn để chữ không bị lỗi dấu; nếu không đảm bảo được font thì ghi rõ trong báo cáo.

### 7.7 Trục đối xứng và tỉ lệ ô (Should)

Lớp bật/tắt "Trục đối xứng" vẽ trục đối xứng thực sự của hình hiện tại (tính theo hình học, không theo tên). Tùy chọn "1 ô = 1 cm | 0,5 cm | 2 cm" đổi tỉ lệ số đo hiển thị; công thức dùng đơn vị tương ứng.

---

## 8. Trợ năng, hiệu năng, kiểm thử

**Trợ năng:**
- Điều khiển bằng chuột, chạm (Pointer Events, `touch-action: none` trên bảng vẽ để không cuộn trang khi kéo) và **bàn phím**: Tab chọn đỉnh/tay nắm (`role="slider"` hoặc `button` có `aria-label` nói rõ tên đỉnh và tọa độ), phím mũi tên di chuyển 1 bước lưới, Shift + mũi tên di chuyển 5 bước.
- Mọi thao tác kéo đều có **cách thay thế bằng ô nhập số**.
- Thông báo loại hình và điều kiện qua `aria-live="polite"`; tương phản đủ; focus nhìn thấy; Đúng/Sai luôn kèm ký hiệu và chữ.
- Bảng vẽ có `role="img"` hoặc nhóm có `aria-label` mô tả ngắn hình hiện tại ("Hình chữ nhật ABCD, AB = 6 cm, BC = 4 cm").

**Hiệu năng:** cập nhật SVG theo `requestAnimationFrame`, không dựng lại toàn bộ DOM mỗi lần di chuyển (chỉ cập nhật thuộc tính). Tính toán < 5 ms mỗi khung.

**Kiểm thử (bắt buộc, chạy bằng Node, ví dụ `node --test tests/lab/*.test.js`, hoặc cơ chế kiểm thử sẵn có của dự án):**
1. Mỗi hình mẫu mặc định nhận dạng ra **đúng chính nó** là loại cụ thể nhất và tập thỏa đúng bằng {chính nó} ∪ tổ tiên theo `isa` (dùng dữ liệu `isa` thật hoặc bản sao trong test).
2. Số đo mẫu (làm tròn 2 chữ số): diện tích: tứ giác 21; thang 18; thang cân 18; bình hành 18; chữ nhật 24; thoi 20; vuông 25; diều 24. Chu vi chữ nhật 20; vuông 20; thoi 20. Đường chéo chữ nhật 6×4 ≈ 7,21; hình vuông cạnh 5 ≈ 7,07.
3. Mỗi bộ tính công thức diện tích khớp diện tích từ tọa độ trên các hình mẫu phù hợp (sai lệch ≤ 0,01).
4. Kiểm tra lồi: từ chối hình lõm và hình tự cắt; chấp nhận hình mẫu mặc định.
5. Mười quy tắc "Áp dụng điều kiện" cho kết quả nhận dạng đúng hình đích từ hình mẫu cha mặc định.
6. Thông báo thêm/mất điều kiện: Hình chữ nhật → kéo một đỉnh → "Không còn: có một góc vuông", loại mới là Hình bình hành; Hình chữ nhật → đặt hai cạnh kề bằng nhau → "Đã thêm điều kiện: hai cạnh kề bằng nhau", loại mới Hình vuông.
7. Phân tích URL: URL hợp lệ khôi phục đúng hình; URL xấu (NaN, ngoài giới hạn, hình lõm) quay về mặc định.

Nếu một kiểm thử không đạt, **sửa thuật toán/hình mẫu**, không sửa dữ liệu Neo4j và không nới dung sai để "cho qua" mà không báo người dùng.

---

## 9. Các giai đoạn (mỗi giai đoạn xong thì dừng chờ "tiếp")

**Giai đoạn 1 – Đọc code, kế hoạch thiết kế, khung trang.** Mô tả ngắn (≤ 10 dòng) cấu trúc dự án và danh sách file định thêm/sửa; lập kế hoạch thiết kế ngắn (wireframe 360px và 1280px, bảng màu dùng cho bảng vẽ); hỏi lại điểm chưa rõ. Làm endpoint `/api/lab/meta`, route `/lab`, tab "Xưởng vẽ" ở header, trang khung (bố cục, thanh công cụ, bảng vẽ rỗng có lưới 24px, danh sách hình mẫu lấy từ Neo4j). Kiểm tra: tab hoạt động, lưới đúng, Neo4j tắt thì báo lỗi thân thiện có nút "Thử lại".

**Giai đoạn 2 – Lõi hình học và kiểm thử.** Viết `geometry.js`, `classify.js`, `presets.js`, `formulas.js` và các kiểm thử mục 8 (1–5, 7 nếu đã có phần URL). Báo kết quả chạy kiểm thử. Chưa cần giao diện kéo thả.

**Giai đoạn 3 – Bảng vẽ tương tác (chế độ tự do).** Vẽ SVG, kéo thả đỉnh bằng chuột/chạm/bàn phím, bắt lưới và bước, chú thích tọa độ, ký hiệu tự động, số đo trực tiếp, kiểm tra lồi, hoàn tác/làm lại/đặt lại, chia sẻ URL. Kiểm tra theo mục 10.

**Giai đoạn 4 – Hình mẫu, nhập số, công thức, nhận dạng.** Chế độ "Theo hình mẫu" với tay nắm, nút "Mở khóa để kéo tự do", ô nhập số hai chiều, tab "Công thức" (có thay số, kiểm chứng chéo, công thức kế thừa), tab "Nhận dạng" (loại hình, chuỗi IS_A, thông báo thêm/mất điều kiện).

**Giai đoạn 5 – Should và tài liệu.** Theo thứ tự: "Áp dụng điều kiện" → Thử thách → tính chất ✓/✗ → xuất ảnh → trục đối xứng/tỉ lệ ô. Báo trước nếu thời gian eo hẹp để người dùng chọn. Cập nhật `README.md`, `docs/HUONG_DAN_SU_DUNG.md` (thêm mục "Xưởng vẽ" kèm ảnh chụp), `docs/test-cases.md` (thêm ca kiểm tra mục 10). Chạy lại toàn bộ trang cũ.

---

## 10. Kiểm tra nghiệm thu

| Mã | Ca kiểm tra | Kết quả mong đợi |
|---|---|---|
| L-01 | Mở `/lab` | Tab "Xưởng vẽ" được chọn; lưới ô 24px; danh sách 8 hình mẫu từ Neo4j |
| L-02 | Bấm từng hình mẫu | Hình tự vẽ đúng, nhận dạng đúng loại và đúng chuỗi "cũng là" theo IS_A |
| L-03 | Chế độ tự do, bắt lưới bật: kéo đỉnh hình chữ nhật | Hình đổi thành hình bình hành; thông báo "Không còn: có một góc vuông" |
| L-04 | Kéo lại cho 4 góc vuông | Thông báo thêm điều kiện; ký hiệu góc vuông xuất hiện lại |
| L-05 | Chế độ hình mẫu: nhập a = 6, b = 4 cho chữ nhật | S = 24 cm², P = 20 cm, d ≈ 7,21 cm; công thức có thay số; "✓ Khớp với diện tích tính từ tọa độ" |
| L-06 | Kéo đỉnh làm hình bị lõm | Đỉnh giữ vị trí hợp lệ; thông báo rõ lý do |
| L-07 | Nhập giá trị sai (chữ, âm, quá lớn) | Viền đỏ kèm ✗ và câu giải thích; hình cũ giữ nguyên |
| L-08 | Hoàn tác/Làm lại nhiều bước; "Đặt lại hình" | Đúng trạng thái từng bước |
| L-09 | Sao chép link, mở tab mới | Hình y hệt; link xấu thì mở hình mặc định kèm thông báo |
| L-10 | Chỉ dùng bàn phím | Tab chọn đỉnh, phím mũi tên di chuyển, thông báo đọc được bằng trình đọc màn hình |
| L-11 | 360px, chạm kéo đỉnh | Trang không cuộn khi kéo; không cuộn ngang toàn trang; vùng bấm đủ lớn |
| L-12 | Dừng Neo4j | Bảng vẽ mở được; vùng dữ liệu báo lỗi rõ kèm "Thử lại" |
| L-13 | (Should) Hình chữ nhật → "Thử điều kiện này" → Hình vuông | Hình đổi đúng, thông báo thêm điều kiện, hoàn tác được |
| L-14 | (Should) Thử thách "Biến hình bình hành thành hình thoi" | Gợi ý đúng điều kiện; đạt khi nhận dạng ra hình thoi |

---

## 11. Giao diện: nhắc lại những điều cấm

- Không lưới thẻ giống hệt nhau cùng bo góc cùng đổ bóng; không nhãn IN HOA rải rác; không đánh số 01/02/03 vô nghĩa; không gradient trang trí; không hiệu ứng trượt-hiện từng khu; không chữ giả (lorem).
- Bootstrap chỉ dùng lưới và tiện ích; ghi đè nút xanh mặc định, thẻ bo tròn đổ bóng.
- Font Patrick Hand (tiêu đề, tên hình viết tay), Be Vietnam Pro (nội dung), subset `vietnamese`; kiểm tra dấu hiển thị đúng **kể cả chữ trong SVG** (chỉ định `font-family` bằng font đã tải).
- Trước khi báo xong mỗi giai đoạn có giao diện: mở ở 360px và 1280px, chụp ảnh, tự phê bình theo "Cách kiểm tra" trong `DESIGN_BRIEF.md`; bỏ bớt một thứ trang trí.

---

## 12. Báo cáo cuối mỗi giai đoạn

1. Đã làm gì (2–5 dòng).
2. File đã thêm/sửa.
3. Cách kiểm tra đã chạy và kết quả (kèm ảnh chụp/kết quả kiểm thử).
4. Việc người dùng cần làm tiếp.
5. Điểm chưa chắc chắn hoặc cần hỏi.

## 13. Không làm

- Không viết lại dự án, không đổi công nghệ, không thêm thư viện đồ họa/hình học lớn.
- Không hard-code tên hình, quan hệ IS_A, điều kiện, biểu thức công thức trong View/JS.
- Không tự ghi dữ liệu vào Neo4j; không đưa mật khẩu vào mã, JavaScript hoặc Git.
- Không nới dung sai hoặc sửa dữ liệu chỉ để kiểm thử qua mà không báo người dùng.
