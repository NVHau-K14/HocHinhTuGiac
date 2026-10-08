# AGENT_PROMPT.md – Xây dựng website học hình học phẳng: Tứ giác

> Đặt file này ở gốc dự án cùng với `DESIGN_BRIEF.md`, `SRS_...docx` (hoặc bản .md của SRS) và `Product_Backlog_...xlsx`.
> Bạn là một AI coding agent. Đọc toàn bộ file này trước khi làm bất cứ việc gì.

---

## 0. Cách làm việc (bắt buộc)

1. **Làm theo từng giai đoạn** ở mục 9. Hết mỗi giai đoạn: chạy kiểm tra, báo kết quả ngắn gọn, rồi dừng chờ người dùng gõ "tiếp". Không làm nhiều giai đoạn trong một lượt.
2. **Không bịa.** Nếu thiếu thông tin hoặc hai tài liệu mâu thuẫn nhau, hỏi người dùng bằng một danh sách câu hỏi ngắn. Không tự đoán.
3. **Thứ tự ưu tiên khi có xung đột:**
   `DESIGN_BRIEF.md` (về giao diện) > SRS v2.1 (về chức năng, dữ liệu) > Product Backlog > file này (về cách làm).
   Riêng PBI-28 trong Backlog ghi "không áp đặt phong cách vở ô li": **bỏ qua câu đó**, người dùng đã chốt dùng phong cách vở ô li trong `DESIGN_BRIEF.md`.
4. **Mỗi giai đoạn phải chạy được** (`dotnet build` không lỗi, trang mở được) trước khi sang giai đoạn sau.
5. Commit Git sau mỗi giai đoạn, thông điệp tiếng Việt hoặc tiếng Anh rõ ràng (ví dụ: `feat: trang chi tiết hình với tính chất kế thừa`).
6. Không commit mật khẩu Neo4j. Tạo `.gitignore` ngay từ giai đoạn 1.

---

## 1. Bài toán

Đồ án kết thúc chương Neo4j (môn NoSQL): **Ứng dụng hỗ trợ học toán hình học phẳng – chủ đề Tứ giác**.

Sản phẩm nộp gồm: (1) hồ sơ đặc tả SRS, (2) Product Backlog, (3) link GitHub source code, (4) hướng dẫn sử dụng.
Phần việc của bạn là **(3) mã nguồn** và **(4) hướng dẫn sử dụng** (cùng README, script seed, kiểm thử). SRS và Backlog đã có sẵn.

Mục tiêu chấm điểm: chứng minh **vai trò của Neo4j** (đồ thị IS_A, Property dùng chung, tính chất kế thừa bằng Cypher) trong một website e-learning nhỏ.

**Đối tượng:** học sinh học và ôn tập tứ giác (SRS ghi THPT, DESIGN_BRIEF ghi lớp 8; kiến thức là hình học THCS). Việc chính: đọc định nghĩa/tính chất, làm bài, làm quiz.

---

## 2. Công nghệ (cố định)

| Thành phần | Lựa chọn |
|---|---|
| Backend | ASP.NET Core MVC, C#, dùng bản .NET LTS đang cài trên máy (hỏi người dùng nếu chưa rõ) |
| CSDL | Neo4j Desktop, truy vấn Cypher, gói NuGet `Neo4j.Driver` |
| Giao diện | Razor View, Bootstrap (chỉ lưới + tiện ích), CSS riêng, JavaScript thuần |
| Công thức | KaTeX |
| Sơ đồ quan hệ | vis-network (bố cục phân cấp), tải từ CDN, **chỉ khi người dùng bấm nút** |
| Chữ | Patrick Hand (tiêu đề), Be Vietnam Pro (nội dung), subset `vietnamese` |

**Không làm:** đăng nhập/đăng ký, trang admin, AI/chatbot, kéo-thả hình học, offline, song ngữ, ORM khác, SPA framework (React/Vue).

---

## 3. Kiến trúc

```
Browser → Controller → Service (interface) → Repository (Cypher) → Neo4j
```

- Controller chỉ nhận request, kiểm tra input, gọi Service, trả View hoặc JSON.
- Mọi Cypher nằm trong lớp Repository/Service. **Không có Cypher trong View hoặc Controller.**
- JavaScript **không bao giờ** nói chuyện trực tiếp với Neo4j và không chứa credential.
- Mọi Cypher có input người dùng phải dùng **tham số** (`$slug`, `$keyword`...), không nối chuỗi.
- Học liệu cốt lõi **không hard-code** trong View. Lấy từ Neo4j. (Riêng hình SVG xem mục 7.)
- Cấu hình kết nối: `appsettings.Development.json` (đã `.gitignore`) hoặc biến môi trường. Commit kèm `appsettings.Example.json` không có mật khẩu.
- Lỗi Neo4j: bắt ở một chỗ chung (middleware hoặc filter), hiện trang lỗi thân thiện có nút "Thử lại", **không** lộ stack trace, URI, mật khẩu.

Cấu trúc thư mục đề xuất:

```
/src/QuadWeb/
  Controllers/  Models/  Views/  Services/  Repositories/  wwwroot/
/db/
  seed.cypher        # chạy lặp được (MERGE)
  verify.cypher      # kiểm tra ràng buộc dữ liệu
/docs/
  HUONG_DAN_SU_DUNG.md
  screenshots/
README.md
DESIGN_BRIEF.md
AGENT_PROMPT.md
```

---

## 4. Mô hình dữ liệu Neo4j

**Node:** `Shape`(id, name, slug, shortDescription, searchText), `Definition`, `Property`, `Theorem`, `Recognition`, `Formula`(id, name, expression, note), `Example`(id, title, content, solution), `Question`(id, content, type, difficulty, explanation), `AnswerOption`(id, content, isCorrect), `Learner`(clientId, displayName, createdAt, updatedAt), `QuizAttempt`(id, score, correctCount, total, completedAt).
Mọi node nội dung có `id` ổn định và `searchText` (viết thường, bỏ dấu tiếng Việt, đ → d).

**Quan hệ:** `IS_A` (Shape→Shape), `HAS_DEFINITION`, `HAS_PROPERTY` (nhiều-nhiều), `HAS_THEOREM`, `HAS_RECOGNITION`, `HAS_FORMULA`, `HAS_EXAMPLE`, `HAS_QUESTION`, `HAS_OPTION`, `MADE_ATTEMPT` (Learner→QuizAttempt), `ANSWERED` (QuizAttempt→Question, lưu `selectedOptionId`, `isCorrect`).

**Constraint bắt buộc:** unique trên `Shape.slug`, `Question.id`, `Learner.clientId`, `QuizAttempt.id`, và `id` của Property/Theorem/Recognition/Formula/Example/AnswerOption/Definition.

### 4.1 Đúng 8 Shape và đúng 10 cạnh IS_A (hình đặc biệt → hình tổng quát)

| slug | tên |
|---|---|
| `tu-giac` | Tứ giác |
| `hinh-thang` | Hình thang |
| `hinh-thang-can` | Hình thang cân |
| `hinh-binh-hanh` | Hình bình hành |
| `hinh-chu-nhat` | Hình chữ nhật |
| `hinh-thoi` | Hình thoi |
| `hinh-vuong` | Hình vuông |
| `hinh-dieu` | Hình diều |

| Từ | Đến |
|---|---|
| hinh-thang | tu-giac |
| hinh-dieu | tu-giac |
| hinh-thang-can | hinh-thang |
| hinh-binh-hanh | hinh-thang |
| hinh-chu-nhat | hinh-binh-hanh |
| hinh-chu-nhat | hinh-thang-can |
| hinh-thoi | hinh-binh-hanh |
| hinh-thoi | hinh-dieu |
| hinh-vuong | hinh-chu-nhat |
| hinh-vuong | hinh-thoi |

Quy ước **định nghĩa bao hàm**: hình thang = tứ giác có **ít nhất** một cặp cạnh đối song song; hình thang cân = hình thang có hai góc kề một đáy bằng nhau; hình diều = tứ giác có hai cặp cạnh kề bằng nhau (gồm cả hình thoi). Dùng nhất quán trong định nghĩa, bài học, câu hỏi, đáp án. Trên trang hình diều ghi rõ đây là định nghĩa nhóm chọn.

### 4.2 Property dùng chung

Gắn mỗi tính chất vào hình **tổng quát nhất** có tính chất đó, các hình con kế thừa qua `IS_A*0..`. Ví dụ `P-DUONG-CHEO-VUONG-GOC` gắn với `hinh-thoi` và `hinh-dieu` (xem Phụ lục C mục 14 của SRS). Kết quả hiển thị phải **khử trùng theo `Property.id`** và kèm danh sách nguồn kế thừa (`collect(DISTINCT a.name)`).

### 4.3 Câu hỏi

- Mỗi Shape ≥ 5 Question, đủ 3 loại `THEORY`, `CALCULATION`, `RECOGNITION`; tổng ≥ 40.
- Mỗi Question có **đúng 4** AnswerOption, **đúng 1** `isCorrect=true`, có `explanation` (lời giải theo từng bước).
- Câu hỏi phải đúng toán học. Mỗi đáp án sai phải là đáp án nhiễu hợp lý, không phải đáp án vô nghĩa.

### 4.4 Kiểm chứng toán học (tránh lỗi phổ biến)

Dùng bảng này làm mốc khi viết nội dung và đáp án. Nếu nghi ngờ điều gì, hỏi người dùng thay vì tự chọn.

| Hình | Điểm cần đúng |
|---|---|
| Tứ giác | Tổng bốn góc = 360° |
| Hình thang | AB ∥ CD thì ∠A + ∠D = 180° và ∠B + ∠C = 180°; S = (a+b)·h/2 |
| Hình thang cân | Hai góc kề đáy bằng nhau; hai đường chéo bằng nhau; hai cạnh bên bằng nhau |
| Hình bình hành | Cạnh đối song song và bằng nhau; góc đối bằng nhau; hai đường chéo cắt nhau tại trung điểm; S = a·h |
| Hình chữ nhật | Bốn góc vuông; hai đường chéo bằng nhau; S = a·b; P = 2(a+b) |
| Hình thoi | Bốn cạnh bằng nhau; hai đường chéo vuông góc và là phân giác các góc; S = d₁·d₂/2 |
| Hình vuông | Có mọi tính chất của hình chữ nhật và hình thoi; S = a²; đường chéo d = a√2 |
| Hình diều | Hai cặp cạnh kề bằng nhau; hai đường chéo vuông góc; S = d₁·d₂/2 |

Bẫy cần tránh:
- "Hai cạnh bên bằng nhau" **không** đủ để kết luận là hình thang cân (hình bình hành không phải chữ nhật cũng có hai cạnh bên bằng nhau). Dùng làm câu nhận biết, đáp án nhiễu cần chặt chẽ.
- Với định nghĩa bao hàm, "Hình chữ nhật có phải hình thang cân không?" → **Có**. "Hình thoi có phải hình diều không?" → **Có**. Các câu hỏi/đáp án không được mâu thuẫn với điều này.

---

## 5. Chức năng và trang

Mức ưu tiên: **Must** = bắt buộc; **Should** = làm sau khi Must xong; **Could** = bỏ qua trừ khi người dùng yêu cầu.

| Trang / route | Nội dung chính | Ưu tiên |
|---|---|---|
| `/` Trang chủ | Giới thiệu ngắn, 8 hình SVG, 5 lối vào (Khám phá, Luyện tập, Quiz, Bảng xếp hạng, Tìm kiếm) | Must |
| `/shapes` Khám phá | 8 hình từ Neo4j (tên, mô tả, SVG), nút "Xem sơ đồ quan hệ" | Must |
| `/shape/{slug}` Chi tiết | Định nghĩa, tính chất trực tiếp + kế thừa, định lý, dấu hiệu nhận biết, công thức, ví dụ; slug sai → 404; mục thiếu dữ liệu → ẩn hoặc báo rõ | Must |
| `/api/graph` | JSON node/edge IS_A, chỉ gọi khi bấm nút; có nút đóng; lỗi → "không tải được sơ đồ" | Must |
| `/practice` và `/practice/{slug}` | Chọn hình, làm 5 câu; "Kiểm tra" → Đúng/Sai + đáp án đúng, không chấm lại; "Xem lời giải" | Must |
| `/quiz` và `/quiz/result` | Server chọn 10 câu; tiến độ n/10; cảnh báo nếu còn câu trống; backend chấm; xem lại; "Làm lại" | Must |
| `/leaderboard` | Hạng, tên, điểm tốt nhất, thời điểm | Should |
| `/search` | Tìm có dấu/không dấu trên Shape, Definition, Property, Theorem, Recognition, Formula | Should |
| Đổi tên hiển thị | 1–30 ký tự sau trim, HTML-encode | Should |
| So sánh hai hình | Tính chất chung qua IS_A + Property dùng chung | Should |
| `/about` Giới thiệu | Mục đích, vai trò Neo4j | Could |

### 5.1 Người học ẩn danh
Lần đầu truy cập, backend tạo `clientId` ngẫu nhiên (GUID), lưu cookie **HttpOnly, SameSite=Lax**, `Secure` khi chạy HTTPS. Tên mặc định "Người học". Không có đăng nhập. Xóa cookie = người học mới.

### 5.2 Quiz (quy tắc chấm điểm, dễ làm sai nhất)
- Backend chọn **10 câu không trùng**, mỗi trong 8 hình ít nhất 1 câu, thêm 2 câu bất kỳ.
- Trình duyệt **không** được gửi điểm lên. Chỉ gửi `{quizId, answers: [{questionId, selectedOptionId|null}]}`.
- Backend kiểm tra `quizId` hợp lệ và danh sách `questionId` đúng bộ 10 câu đã cấp, rồi tự đối chiếu `isCorrect` trong Neo4j. Điểm = số câu đúng × 10. Câu bỏ trống = sai (sau khi người dùng xác nhận cảnh báo).
- Cách ghi nhớ bộ 10 câu đã cấp: lưu phía server (ví dụ `IMemoryCache` theo `quizId`, hết hạn sau ~60 phút). **Không** tạo `QuizAttempt` trong Neo4j khi mới bắt đầu; chỉ tạo khi nộp bài hợp lệ (đúng SRS: chỉ lượt hoàn thành mới tính).
- Nếu lưu `QuizAttempt` lỗi: vẫn hiện điểm và báo "chưa cập nhật được bảng xếp hạng".

### 5.3 Bảng xếp hạng (Should)
Mỗi `clientId` một dòng với điểm tốt nhất; sắp xếp điểm giảm dần, bằng điểm thì lượt sớm hơn đứng trên; tô nổi dòng của người đang xem; chưa có dữ liệu thì hiện thông báo. Không tuyên bố đây là danh tính đáng tin cậy.

### 5.4 Tìm kiếm (Should)
Chuẩn hóa từ khóa ở backend (chữ thường, bỏ dấu, đ→d) rồi `CONTAINS` trên `searchText`. "đường chéo" và "duong cheo" phải cho cùng kết quả. Từ khóa rỗng → báo lỗi nhẹ; không có kết quả → "Không tìm thấy dữ liệu phù hợp".

### 5.5 Truy vấn Cypher mẫu (dùng đúng các mẫu này)

```cypher
// Hình tổng quát hơn
MATCH (s:Shape {slug: $slug})-[:IS_A*1..]->(a:Shape)
RETURN DISTINCT a.name ORDER BY a.name;

// Tính chất trực tiếp + kế thừa, khử trùng, kèm nguồn
MATCH (s:Shape {slug: $slug})-[:IS_A*0..]->(a:Shape)-[:HAS_PROPERTY]->(p:Property)
RETURN p.id AS id, p.content AS tinhChat, collect(DISTINCT a.name) AS nguon
ORDER BY tinhChat;

// Tính chất chung của hai hình
MATCH (a:Shape {slug: $slugA})-[:IS_A*0..]->(x:Shape)-[:HAS_PROPERTY]->(p:Property)
MATCH (b:Shape {slug: $slugB})-[:IS_A*0..]->(y:Shape)-[:HAS_PROPERTY]->(p)
WHERE a.slug <> b.slug
RETURN DISTINCT p.id AS id, p.content AS tinhChatChung ORDER BY tinhChatChung;
```

---

## 6. Giao diện: ĐỌC `DESIGN_BRIEF.md` VÀ LÀM ĐÚNG

`DESIGN_BRIEF.md` là nguồn sự thật về giao diện. Phần dưới đây chỉ nhắc lại những điểm hay bị bỏ sót và nguyên tắc từ skill **frontend-design**.

### 6.1 Cách dùng skill frontend-design
Nếu agent có skill `frontend-design`, đọc nó trước khi viết giao diện. Nếu không có, áp dụng các nguyên tắc sau (đã rút gọn từ skill):

1. **Brief thắng mặc định.** Chỗ nào DESIGN_BRIEF đã chốt thì làm đúng, không "cải tiến".
2. **Lập kế hoạch thiết kế trước khi code** (ngắn gọn, ghi vào `docs/design-plan.md`): bảng màu 6 màu có hex, vai trò hai font, ý tưởng bố cục (kèm ASCII wireframe cho trang chủ, trang chi tiết, quiz), căn lề. Sau đó tự rà: chỗ nào giống mẫu mặc định của AI thì sửa và ghi lý do.
3. **Tránh các dấu hiệu "AI làm":** nền kem + chữ serif đậm + màu đất nung; nền đen + một màu neon; bố cục báo giấy; **lưới thẻ giống hệt nhau cùng bo góc cùng đổ bóng**; nhãn IN HOA rải trên mọi tiêu đề; đánh số 01/02/03 khi nội dung không phải trình tự; chỉ tô riêng một từ trong tiêu đề; dấu "→" gắn vào mọi nút; hiệu ứng trượt-hiện ở từng khu; hover động trên mọi thẻ.
4. **Tiêu đề là một phần của thiết kế**, không phải chỗ để lấp chữ.
5. **Dồn sự táo bạo vào một chỗ:** hình 8 tứ giác nét mực "tự vẽ" ở trang chủ. Mọi thứ khác yên tĩnh. Trước khi xong, **bỏ bớt một thứ trang trí.**
6. **Chuyển động:** chỉ một lần (nét SVG tự vẽ ~1,2 giây khi mở trang chủ) và phản hồi cho hành động. Tôn trọng `prefers-reduced-motion`.
7. **Chất lượng nền:** responsive từ 360px, focus bàn phím nhìn thấy, tương phản đủ, không dựa vào màu để phân biệt Đúng/Sai (luôn kèm ✓/✗ và chữ).
8. **Viết chữ giao diện** bằng tiếng Việt đơn giản, câu chủ động, nút nói đúng việc ("Kiểm tra", "Xem lời giải", "Làm lại", "Xem sơ đồ quan hệ"). Lỗi và trạng thái rỗng nói rõ chuyện gì xảy ra và làm gì tiếp, **không xin lỗi chung chung**. Một hành động giữ cùng một tên trong cả luồng.

### 6.2 Những điều DESIGN_BRIEF đã chốt (không đổi)
- Ý tưởng: trang vở ô li, nền kẻ bằng CSS `linear-gradient` (không dùng ảnh), đơn vị lưới **24px**, line-height nội dung là bội của 24px, lề đỏ bên trái.
- 6 màu: Giấy `#FAFCFD`, Ô li `#CFE3F1`, Lề đỏ `#D64550`, Mực xanh `#1F3A93`, Chì `#3B3F46`, Dạ quang `#FFE66D`. Đúng = `#2E8B57` kèm ✓ và chữ "Đúng"; Sai = lề đỏ kèm ✗ và chữ "Sai".
- Font: Patrick Hand + Be Vietnam Pro, **tải subset `vietnamese` và kiểm tra dấu hiển thị đúng** (ví dụ "Hình thang cân", "đường chéo").
- Dòng nội dung tối đa ~70 ký tự.
- Bootstrap: chỉ dùng lưới và tiện ích; ghi đè `--bs-*`, `.btn`, `.card`, `.navbar` để không còn nút xanh mặc định và thẻ bo tròn đổ bóng. Bo góc nhỏ và **không đồng nhất**; không gradient trang trí.
- Trang chủ: hình 8 tứ giác xếp như vẽ trên vở, mỗi hình có tên viết tay; phía dưới là **5 lối vào dạng danh sách gạch đầu dòng**, không dùng lưới thẻ.
- Trang chi tiết: cột chính bên trái (định nghĩa tô dạ quang, tính chất, định lý); cột phụ nhỏ "hình cha / hình con" lấy từ IS_A; mục "Tính chất kế thừa" tách riêng.
- Kết quả quiz: điểm viết tay khoanh tròn đỏ như cô giáo chấm ("8/10"). Lưu ý: SRS tính điểm theo thang 100 (mỗi câu 10 điểm). Hiển thị **cả hai**: số câu đúng "8/10" khoanh đỏ và "80/100" nhỏ bên cạnh.
- Bảng xếp hạng: "bảng điểm lớp", hàng kẻ như vở.
- Mobile 360px: lề đỏ thu nhỏ, lưới 24px giữ nguyên, không có thanh cuộn ngang toàn trang.

### 6.3 Màu theo họ hình (brief chưa cho mã hex, dùng đề xuất này, người dùng có thể đổi)
Dùng làm nền nhạt phía sau hình vẽ; gom hình theo cây IS_A:

| Họ | Gồm | Hex nền nhạt |
|---|---|---|
| Họ hình thang | hình thang, hình thang cân | `#E6DDF5` |
| Họ bình hành | hình bình hành, hình chữ nhật, hình thoi, hình vuông | `#D8F0E4` |
| Họ diều | hình diều | `#FBE0E8` |
| Tứ giác (gốc) | tứ giác | `#FAFCFD` (không tô) |

Chữ trên các nền này vẫn dùng Chì/Mực xanh và phải đạt tương phản đủ đọc.

---

## 7. Hình SVG (điểm nhớ duy nhất của giao diện)

- Làm **8 SVG tĩnh** vẽ tay bằng code (không ảnh, không thư viện), mỗi hình đúng đặc điểm hình học và có **nhãn đỉnh A, B, C, D**, ký hiệu cạnh bằng nhau (gạch chéo nhỏ), cặp cạnh song song (mũi tên nhỏ), góc vuông (ô vuông nhỏ) khi phù hợp.
- Nét: màu Mực xanh, `stroke-linecap: round`, độ dày khoảng 2–2.5px, hơi "run tay" rất nhẹ nhưng **hình học vẫn phải chính xác** (hình vuông phải vuông, hình thang cân phải đối xứng, hình diều có hai cặp cạnh kề bằng nhau thật).
- `viewBox` cố định, `width:100%`, **không méo** từ 360px đến 1280px. Có `role="img"` và `<title>` mô tả.
- Hiệu ứng tự vẽ: `stroke-dasharray` + `stroke-dashoffset` (dùng `pathLength="1"` cho đơn giản), ~1,2 giây, chạy **một lần** khi mở trang chủ. Với `prefers-reduced-motion: reduce` thì hiển thị ngay, không animate.
- Quy ước: SVG là tài sản giao diện (lưu trong `wwwroot` hoặc partial view theo `slug`), không phải học liệu; vì vậy không vi phạm quy tắc "không hard-code học liệu". Danh sách và tên hình vẫn đến từ Neo4j.

---

## 8. Chất lượng, bảo mật, kiểm thử

- **Lỗi thân thiện** (FR-10, NFR-09/14): dừng Neo4j → mọi trang báo rõ chuyện gì xảy ra + nút "Thử lại", không lộ stack trace/URI/mật khẩu.
- **XSS:** mọi dữ liệu người dùng (tên hiển thị) được HTML-encode; Razor mặc định đã encode, đừng dùng `Html.Raw` cho dữ liệu người dùng.
- **KaTeX:** render công thức và ký hiệu (∥, ⊥, ∠, °) ở bài học, câu hỏi, lời giải; không vỡ ở 360px (bọc công thức dài trong khung cuộn ngang riêng). Nội dung không được ẩn khi JS chưa tải.
- **Script kiểm tra dữ liệu** `db/verify.cypher` (và lệnh chạy trong README) phải in ra: số Shape = 8, số cạnh IS_A = 10, số Question ≥ 40, mỗi Question đúng 4 AnswerOption và đúng 1 đáp án đúng, mỗi Shape ≥ 5 câu, mỗi Question có explanation. Chạy `seed.cypher` hai lần → số node/cạnh không đổi.
- **Kiểm thử tay:** bảng test case ở `docs/test-cases.md` theo AC-01 … AC-17 (AC Should chỉ ghi khi đã làm).
- **Cách tự kiểm tra giao diện:** mở ở 360px và 1280px, chụp ảnh, phê bình theo mục 6.1, sửa, rồi mới báo xong.

---

## 9. Các giai đoạn (mỗi giai đoạn xong thì dừng chờ người dùng)

**Giai đoạn 0 – Đọc và hỏi lại.** Đọc các file đầu vào. Báo lại: bạn hiểu gì về dự án (≤10 dòng), những điểm còn mơ hồ cần hỏi. Chưa viết code.

**Giai đoạn 1 – Nền tảng (PBI-01, 02, 03, 23 phần khung, 30, 07).** Khởi tạo project, cấu trúc thư mục, kết nối Neo4j (truy vấn thử đếm Shape), constraint, trang lỗi chung, cookie clientId, `.gitignore`, `appsettings.Example.json`. Kiểm tra: `dotnet run` mở được, đếm Shape chạy được, dừng Neo4j thì hiện trang lỗi thân thiện.

**Giai đoạn 2 – Dữ liệu (PBI-04, 05, 25, 23).** Viết `seed.cypher` (8 Shape, 10 IS_A, nội dung học, ≥ 40 câu hỏi) và `verify.cypher`. Tạo seed theo từng phần (chạy được sau mỗi phần). Dừng và **đưa người dùng rà lại nội dung toán** (bảng ở mục 4.4) trước khi sang bước sau.

**Giai đoạn 3 – Giao diện nền + SVG (PBI-06, 28, 29, 20 một phần).** Lập kế hoạch thiết kế (6.1), dựng layout vở ô li, font, 8 SVG, trang chủ với hiệu ứng tự vẽ, điều hướng, KaTeX. Chụp ảnh 360px và 1280px, tự phê bình.

**Giai đoạn 4 – Học lý thuyết (PBI-09, 10, 26).** Khám phá, chi tiết hình, tính chất kế thừa bằng một truy vấn Cypher, cột "hình cha/hình con".

**Giai đoạn 5 – Sơ đồ quan hệ (PBI-11).** Nút → gọi `/api/graph` → vis-network; có nút đóng; lỗi báo rõ; trên mobile có kéo/thu phóng hoặc dạng danh sách thay thế.

**Giai đoạn 6 – Luyện tập và Quiz (PBI-12, 13, 14, 15, 16).** Theo mục 5.2 chính xác. Kết quả quiz: điểm khoanh tròn đỏ.

**Giai đoạn 7 – Should (PBI-17, 18, 19, 08, 27).** Làm theo thứ tự: lưu QuizAttempt → bảng xếp hạng → đổi tên → tìm kiếm → so sánh. Báo cáo trước khi bắt đầu nếu thời gian eo hẹp, để người dùng chọn.

**Giai đoạn 8 – Hoàn thiện và bàn giao (PBI-20, 22, 31).** Responsive 360/768/1280 trên Chrome và Edge; bảng test case; README; `docs/HUONG_DAN_SU_DUNG.md` có ảnh chụp từng chức năng; kiểm tra repo không chứa mật khẩu.

---

## 10. Nội dung README và hướng dẫn sử dụng

**README.md** phải có: giới thiệu 3–5 dòng; yêu cầu cài đặt (phiên bản .NET, Neo4j Desktop); cách tạo database và chạy `seed.cypher`; cách chạy `verify.cypher`; cách cấu hình kết nối (copy `appsettings.Example.json` thành `appsettings.Development.json` rồi điền); `dotnet run`; cấu trúc thư mục; các truy vấn Cypher chính (để giảng viên thấy vai trò Neo4j); giới hạn đã biết.

**docs/HUONG_DAN_SU_DUNG.md** viết cho học sinh, theo luồng: Trang chủ → Khám phá → Học một hình → Xem sơ đồ quan hệ → Luyện tập → Làm quiz → Xem điểm và lời giải → Bảng xếp hạng → Tìm kiếm. Mỗi mục có 2–4 câu và 1 ảnh chụp màn hình trong `docs/screenshots/`.

---

## 11. Danh sách "Không làm" (tóm tắt)

- Không hard-code học liệu trong View; không Cypher ngoài Repository.
- Không nhận điểm quiz từ trình duyệt.
- Không đưa mật khẩu Neo4j vào mã, JS, hoặc Git.
- Không dùng lưới thẻ giống nhau, nút xanh Bootstrap mặc định, nền kem, màu đất nung, gradient trang trí.
- Không nhãn IN HOA rải rác, không đánh số 01/02/03 vô nghĩa, không chữ giả (lorem), không hiệu ứng trượt-hiện từng khu.
- Không làm tính năng ngoài phạm vi (đăng nhập, admin, AI, kéo-thả, offline, song ngữ).
