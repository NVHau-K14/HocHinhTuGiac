# HỌC HÌNH HỌC PHẲNG: TỨ GIÁC
> **Website Hỗ Trợ Học Tập Hình Học Phẳng Lớp 8 Dựa Trên Cơ Sở Dữ Liệu Đồ Thị Neo4j & ASP.NET Core MVC**  
> *Đồ án môn học: Cơ sở dữ liệu NoSQL (Graph Database)*

---

## 1. Giới thiệu đề tài

Học hình học phẳng — đặc biệt là chuyên đề **Tứ giác** trong chương trình Toán THCS (Lớp 8) — thường gây khó khăn cho học sinh bởi số lượng định nghĩa, tính chất, định lý và dấu hiệu nhận biết dày đặc, đan xen phức tạp (Hình bình hành $\rightarrow$ Hình chữ nhật / Hình thoi $\rightarrow$ Hình vuông, v.v.).

Dự án này ứng dụng **Cơ sở dữ liệu đồ thị Neo4j (Graph Database)** kết hợp **ASP.NET Core MVC (.NET 9)** để:
1. **Mô hình hóa tri thức dạng đồ thị:** Biểu diễn 8 hình tứ giác thành các Node và liên kết quan hệ phân cấp kế thừa `[:IS_A]`.
2. **Kế thừa tính chất đệ quy:** Nhờ cú pháp truy vấn đồ thị Cypher `(s:Shape)-[:IS_A*0..]->(ancestor)-[:HAS_PROPERTY]->(p)`, hình con tự động sở hữu toàn bộ tính chất của các hình tổ tiên mà không cần lưu trữ dư thừa dữ liệu.
3. **Trực quan hóa sơ đồ phả hệ:** Sử dụng thư viện `vis-network` để hiển thị cây phân cấp 5 tầng (từ Tứ giác tổng quát đến Hình vuông đặc biệt nhất) với khả năng thu phóng, kéo thả tương tác.
4. **Hệ thống Luyện tập & Quiz thông minh:** 40 câu hỏi trắc nghiệm chia theo từng hình và bài thi tổng hợp 10 câu chấm điểm bảo mật tại Backend, hiển thị kết quả với con dấu điểm đỏ viết tay của giáo viên.
5. **So sánh hình & Tra cứu:** Tìm tổ tiên chung gần nhất (LCA), đối chiếu tính chất chung / riêng và tìm kiếm tri thức tức thì.
6. **Phong cách thiết kế trang vở học sinh:** Nền giấy ô li 24px, lề kẻ đỏ, typography viết tay (Patrick Hand) kết hợp hiện đại (Be Vietnam Pro), công thức toán học KaTeX mượt mà.

---

## 2. Ngăn xếp công nghệ (Technology Stack)

- **Backend:** C# / .NET 9.0 (ASP.NET Core MVC), `Neo4j.Driver` 6.3.0, `Microsoft.Extensions.Caching.Memory`.
- **Database:** Neo4j Graph Database 5.x (Cypher Query Language).
- **Frontend:** Razor Pages (HTML5, Vanilla CSS Design System), KaTeX (kí hiệu toán LaTeX), `vis-network` (vẽ đồ thị tương tác), SVG thủ công có hiệu ứng nét bút vẽ (`stroke-dashoffset`).
- **Scripts kiểm thử & Seed:** Python 3 (sử dụng thư viện `neo4j` official driver để kiểm chứng toán học và tính toàn vẹn).

---

## 3. Cấu trúc thư mục dự án

```text
HocHinhTuGiac/
├── .gitignore
├── AGENT_PROMPT.md             # Đặc tả yêu cầu chi tiết của bài tập lớn
├── README.md                   # Hướng dẫn tổng quan & cài đặt hệ thống
├── appsettings.Example.json    # Mẫu cấu hình kết nối CSDL Neo4j
├── QuadWeb.sln                 # Solution file Visual Studio / .NET
├── db/                         # Thư mục cơ sở dữ liệu đồ thị
│   ├── constraints.cypher      # Ràng buộc UNIQUE và NOT NULL trên các node
│   ├── seed.cypher             # Tập dữ liệu 8 hình, 10 IS_A, 40 câu hỏi, định nghĩa, tính chất...
│   ├── verify.cypher           # 10 truy vấn Cypher kiểm tra tính toàn vẹn
│   ├── apply_seed.py           # Script nạp seed tự động vào Neo4j
│   ├── run_verify.py           # Script chạy và chấm điểm 10/10 tiêu chí kiểm tra dữ liệu
│   └── check_math.py           # Script kiểm tra tính đúng đắn toán học của 40 câu hỏi
├── docs/                       # Tài liệu hướng dẫn & thiết kế
│   ├── design-plan.md          # Đặc tả design tokens, màu họ hình, lưới ô li
│   ├── HUONG_DAN_SU_DUNG.md    # Cẩm nang hướng dẫn sử dụng chi tiết cho người học
│   └── test-cases.md           # Danh sách 13 kịch bản kiểm thử (Test Cases)
└── src/
    └── QuadWeb/                # Ứng dụng ASP.NET Core MVC
        ├── Controllers/        # Home, Shapes, Practice, Quiz, Leaderboard, Search, Compare, GraphApi
        ├── Models/             # Shape, Quiz, Learner, Search, Compare, Graph DTOs
        ├── Repositories/       # IShapeRepository, IQuestionRepository, ILearnerRepository
        ├── Services/           # Neo4jDriverService, ShapeService, QuizService, LearnerService
        ├── Middleware/         # LearnerMiddleware (Cookie ẩn danh), Neo4jExceptionMiddleware
        ├── Views/              # Giao diện Razor Pages thiết kế sổ tay học sinh
        ├── wwwroot/            # CSS trang vở ô li (site.css), JS vis-network (graph.js)
        ├── appsettings.json    # Cấu hình môi trường runtime
        └── Program.cs          # Đăng ký Dependency Injection và HTTP Pipeline
```

---

## 4. Yêu cầu môi trường

- **Hệ điều hành:** Windows 10/11, macOS hoặc Linux.
- **.NET SDK:** Phiên bản **.NET 9.0 SDK** trở lên (`dotnet --version`).
- **Neo4j Database:** Neo4j Desktop hoặc Neo4j Community Server 5.x đang chạy trên cổng mặc định `7687` (Bolt protocol).
- **Python:** Python 3.8+ (khuyên dùng để chạy các script nạp seed và test dữ liệu).

---

## 5. Hướng dẫn cài đặt & Khởi chạy từng bước

### Bước 1: Khởi động Cơ sở dữ liệu Neo4j
Khởi động cơ sở dữ liệu Neo4j trên máy của bạn:
- URI giao thức Bolt: `bolt://127.0.0.1:7687` (hoặc `neo4j://localhost:7687`)
- Database name: `neo4j`
- Thiết lập tài khoản và mật khẩu (ví dụ: `neo4j` / `12345678`).

### Bước 2: Nạp Ràng buộc & Dữ liệu Tri thức (Seed Data)
Mở terminal trong thư mục gốc của dự án và chạy các script Python hỗ trợ:

```bash
# Cài đặt thư viện Neo4j Driver cho Python (nếu chưa có)
pip install neo4j

# Chạy tạo ràng buộc và nạp seed dữ liệu vào Neo4j
python db/apply_seed.py

# Kiểm tra tính toàn vẹn của dữ liệu (10/10 tiêu chí ĐẠT)
python db/run_verify.py
```

*Hoặc bạn có thể mở công cụ **Neo4j Browser** (`http://localhost:7474`), sao chép nội dung file [db/constraints.cypher](file:///d:/Documents/BaiTap/NoSQL/HocHinhTuGiac/db/constraints.cypher) rồi chạy trước, sau đó sao chép nội dung file [db/seed.cypher](file:///d:/Documents/BaiTap/NoSQL/HocHinhTuGiac/db/seed.cypher) và thực thi.*

### Bước 3: Cấu hình kết nối ứng dụng Web
Tạo hoặc kiểm tra file `src/QuadWeb/appsettings.Development.json` (dựa trên [appsettings.Example.json](file:///d:/Documents/BaiTap/NoSQL/HocHinhTuGiac/appsettings.Example.json)):

```json
{
  "Neo4j": {
    "Uri": "bolt://127.0.0.1:7687",
    "Database": "neo4j",
    "Username": "neo4j",
    "Password": "YOUR_NEO4J_PASSWORD"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
```

> **Lưu ý bảo mật:** Mật khẩu thực tế đã được khai báo trong `appsettings.Development.json` và tệp này được loại trừ khỏi Git qua `.gitignore` để không bị lộ mật khẩu.

### Bước 4: Biên dịch và Khởi chạy ứng dụng Web

```bash
# Biên dịch dự án
dotnet build src/QuadWeb/QuadWeb.csproj

# Chạy website trên cổng 5200
dotnet run --project src/QuadWeb/QuadWeb.csproj --urls "http://localhost:5200"
```

Mở trình duyệt web và truy cập địa chỉ: **[http://localhost:5200](http://localhost:5200)**.

---

## 6. Các chức năng chính của hệ thống

| Nhóm chức năng | Đường dẫn URL | Mô tả nghiệp vụ |
| :--- | :--- | :--- |
| **Trang chủ** | `/` | Trưng bày 8 hình tứ giác vẽ bằng nét SVG hiệu ứng bút chì, tổng quan đồ thị phân cấp và 5 lối vào bài học. |
| **Khám phá lý thuyết** | `/shapes` & `/shapes/{slug}` | Khám phá từng hình: Định nghĩa dạ quang vàng, tính chất trực tiếp & tính chất kế thừa từ tổ tiên qua `IS_A*0..`, định lý, dấu hiệu nhận biết, công thức KaTeX và ví dụ có giải. |
| **Sơ đồ phân cấp** | Modal Đồ thị | Mở cây phân cấp 5 tầng tương tác tương thích kéo/thu phóng bằng `vis-network` (Tứ giác $\rightarrow$ Thang/Diều $\rightarrow$ Thang cân/Bình hành $\rightarrow$ Chữ nhật/Thoi $\rightarrow$ Vuông). |
| **Luyện tập theo hình** | `/practice` & `/practice/{slug}` | 5 câu hỏi trắc nghiệm của hình; nút "Kiểm tra đáp án" hiển thị ngay Đúng/Sai và nút "Xem lời giải" mở lời giải chi tiết. |
| **Kiểm tra Quiz 10 câu** | `/quiz` | Đề thi 10 câu ngẫu nhiên bao phủ đủ 8 hình; thanh tiến độ `n/10`; modal xác nhận nộp bài sổ vở; chấm điểm an toàn tại backend. |
| **Kết quả Quiz** | `/quiz/result/{quizId}` | Điểm số viết tay khoanh tròn đỏ như nét mực cô giáo chấm (`8/10` kèm `80/100 ĐIỂM`), lời phê sư phạm và xem lại 10 câu kèm lời giải. |
| **Bảng điểm lớp** | `/leaderboard` | Bảng vàng vinh danh Top 10 học sinh xuất sắc, huy chương 🥇 🥈 🥉, tự động làm nổi bật dòng của người học hiện tại. |
| **Đổi tên hiển thị** | `/leaderboard` & Navbar | Cập nhật họ tên người học (1-30 ký tự, chống XSS, lưu vào node `Learner`). |
| **Tìm kiếm kiến thức** | `/search` | Tra cứu từ khóa hình học có dấu / không dấu trên 6 loại thực thể tri thức (Hình, Định nghĩa, Tính chất, Định lý, Nhận biết, Công thức). |
| **So sánh hai hình** | `/compare` | Đối chiếu 2 hình bất kỳ: phát hiện quan hệ cha-con hoặc tổ tiên chung gần nhất (LCA), đối chiếu tính chất chung / riêng và công thức. |

---

## 7. Kiểm chứng dữ liệu & Kiểm thử tự động

Hệ thống đã trải qua kiểm tra nghiêm ngặt:
- **Kiểm tra dữ liệu CSDL (db/run_verify.py):** 10/10 tiêu chí ĐẠT:
  - Đúng 8 node `Shape` và 10 cạnh `[:IS_A]`.
  - Không có chu trình kín trong đồ thị phân cấp (DAG chuẩn).
  - 100% 40 câu hỏi có đúng 4 phương án lựa chọn và duy nhất 1 phương án đúng (`isCorrect: true`).
  - 100% câu hỏi có giải thích chi tiết (`explanation`).
- **Kiểm thử API tự động:** 100% các endpoint MVC và API trả về HTTP 200, xử lý cookie ẩn danh an toàn `quad_learner_id` (HttpOnly, SameSite=Lax).
- **Kiểm thử giao diện:** Đảm bảo hiển thị hoàn hảo trên máy tính (1280px) và điện thoại di động (360px).

---

## 8. Tác giả & Giấy phép
- **Đồ án:** Cơ sở dữ liệu NoSQL (Học phần Neo4j Graph Database).
- **Phát triển bởi:** Nhóm sinh viên thực hiện đề tài Tứ Giác Học.
- **Năm thực hiện:** 2026.
