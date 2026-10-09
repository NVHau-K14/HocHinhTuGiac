# NEO4J_UPDATE_v2_2.md – Cập nhật CSDL Neo4j đã có lên phiên bản 2.2

Dành cho database **đã được seed bản cũ** (8 Shape, 10 IS_A, nội dung học, 40 câu hỏi). File này **không dựng lại dữ liệu**, chỉ bổ sung hai thứ theo yêu cầu của giáo viên:

1. Mỗi `Shape` có 5 thuộc tính đặc tả: `specParallel`, `specSides`, `specAngles`, `specDiagonals`, `specSymmetry`.
2. Mỗi cạnh `IS_A` có thuộc tính `condition` (điều kiện cần thêm vào hình tổng quát để thành hình đặc biệt).

Các lệnh dùng `MATCH` + `SET`, **chạy lặp được**, không tạo node hay quan hệ mới, không động đến `Learner`, `QuizAttempt`, câu hỏi.

Cách chạy: mở Neo4j Browser (hoặc `cypher-shell`), chọn đúng database của dự án, chạy lần lượt các bước 0 → 4.

---

## Bước 0. Kiểm tra trước khi cập nhật (slug và cạnh IS_A hiện có)

Lệnh `MATCH` ở các bước sau khớp theo `slug`. Nếu slug trong DB của bạn khác, lệnh sẽ không báo lỗi nhưng cũng không cập nhật gì. Vì vậy chạy hai truy vấn này trước.

```cypher
// 0.1 Danh sách Shape hiện có – mong đợi đúng 8 slug sau:
// tu-giac, hinh-thang, hinh-thang-can, hinh-binh-hanh, hinh-chu-nhat, hinh-thoi, hinh-vuong, hinh-dieu
MATCH (s:Shape) RETURN s.slug AS slug, s.name AS ten ORDER BY s.slug;
```

```cypher
// 0.2 Các cạnh IS_A hiện có – mong đợi đúng 10 dòng, chiều: hình đặc biệt -> hình tổng quát
MATCH (a:Shape)-[:IS_A]->(b:Shape) RETURN a.slug AS tu, b.slug AS den ORDER BY tu, den;
```

Nếu slug khác hoặc chiều cạnh IS_A ngược, **dừng lại** và đối chiếu với SRS (mục 8.3, Phụ lục D.2) trước khi chạy tiếp.

---

## Bước 1. Thêm sortOrder, family (nếu bản cũ chưa có) và 5 thuộc tính đặc tả cho Shape

`sortOrder` và `family` dùng để sắp xếp và tô màu theo họ hình (`goc`, `thang`, `binh-hanh`, `dieu`). Nếu bạn đã có thì lệnh chỉ ghi đè bằng đúng giá trị cũ.

```cypher
UNWIND [
  {slug:'tu-giac', family:'goc', sortOrder:1,
   par:'Không bắt buộc', sid:'Không bắt buộc', ang:'Tổng bốn góc bằng 360°',
   dia:'Không bắt buộc (có 2 đường chéo)', sym:'Không bắt buộc'},
  {slug:'hinh-thang', family:'thang', sortOrder:2,
   par:'Có ít nhất một cặp cạnh đối song song (hai đáy)', sid:'Không bắt buộc', ang:'Hai góc kề mỗi cạnh bên bù nhau',
   dia:'Không bắt buộc', sym:'Không bắt buộc'},
  {slug:'hinh-thang-can', family:'thang', sortOrder:3,
   par:'Có ít nhất một cặp cạnh đối song song (hai đáy)', sid:'Hai cạnh bên bằng nhau', ang:'Hai góc kề một đáy bằng nhau',
   dia:'Bằng nhau', sym:'Có ít nhất một trục (qua trung điểm hai đáy)'},
  {slug:'hinh-binh-hanh', family:'binh-hanh', sortOrder:4,
   par:'Hai cặp cạnh đối song song', sid:'Các cạnh đối bằng nhau', ang:'Các góc đối bằng nhau',
   dia:'Cắt nhau tại trung điểm của mỗi đường', sym:'Không bắt buộc (có tâm đối xứng)'},
  {slug:'hinh-chu-nhat', family:'binh-hanh', sortOrder:5,
   par:'Hai cặp cạnh đối song song', sid:'Các cạnh đối bằng nhau', ang:'Bốn góc vuông',
   dia:'Bằng nhau, cắt nhau tại trung điểm của mỗi đường', sym:'2 trục (qua trung điểm các cặp cạnh đối)'},
  {slug:'hinh-thoi', family:'binh-hanh', sortOrder:6,
   par:'Hai cặp cạnh đối song song', sid:'Bốn cạnh bằng nhau', ang:'Các góc đối bằng nhau',
   dia:'Vuông góc, cắt nhau tại trung điểm, là phân giác các góc', sym:'2 trục (hai đường chéo)'},
  {slug:'hinh-vuong', family:'binh-hanh', sortOrder:7,
   par:'Hai cặp cạnh đối song song', sid:'Bốn cạnh bằng nhau', ang:'Bốn góc vuông',
   dia:'Bằng nhau, vuông góc, cắt nhau tại trung điểm, là phân giác các góc', sym:'4 trục'},
  {slug:'hinh-dieu', family:'dieu', sortOrder:8,
   par:'Không bắt buộc', sid:'Hai cặp cạnh kề bằng nhau', ang:'Một cặp góc đối bằng nhau',
   dia:'Vuông góc với nhau', sym:'Có ít nhất một trục (một đường chéo)'}
] AS s
MATCH (x:Shape {slug: s.slug})
SET x.family = s.family, x.sortOrder = s.sortOrder,
    x.specParallel = s.par, x.specSides = s.sid, x.specAngles = s.ang,
    x.specDiagonals = s.dia, x.specSymmetry = s.sym
RETURN count(x) AS soHinhDaCapNhat;
// Mong đợi: 8
```

Ghi chú: “Không bắt buộc” nghĩa là tính chất đó không đúng với mọi hình thuộc loại này. Số trục của hình thang cân và hình diều là tối thiểu.

---

## Bước 2. Thêm condition cho 10 cạnh IS_A

```cypher
UNWIND [
  ['hinh-thang',     'tu-giac',        'Có ít nhất một cặp cạnh đối song song'],
  ['hinh-dieu',      'tu-giac',        'Có hai cặp cạnh kề bằng nhau'],
  ['hinh-thang-can', 'hinh-thang',     'Hai góc kề một đáy bằng nhau'],
  ['hinh-binh-hanh', 'hinh-thang',     'Cặp cạnh đối còn lại cũng song song'],
  ['hinh-chu-nhat',  'hinh-binh-hanh', 'Có một góc vuông'],
  ['hinh-chu-nhat',  'hinh-thang-can', 'Có một góc vuông'],
  ['hinh-thoi',      'hinh-binh-hanh', 'Hai cạnh kề bằng nhau'],
  ['hinh-thoi',      'hinh-dieu',      'Bốn cạnh bằng nhau'],
  ['hinh-vuong',     'hinh-chu-nhat',  'Hai cạnh kề bằng nhau'],
  ['hinh-vuong',     'hinh-thoi',      'Có một góc vuông']
] AS e
MATCH (:Shape {slug: e[0]})-[r:IS_A]->(:Shape {slug: e[1]})
SET r.condition = e[2]
RETURN count(r) AS soCanDaCapNhat;
// Mong đợi: 10
```

---

## Bước 3. Kiểm tra sau khi cập nhật

```cypher
// 3.1 Đủ 10/10 cạnh có condition; đủ 8/8 Shape có 5 thuộc tính spec*
MATCH ()-[r:IS_A]->() WHERE r.condition IS NULL OR trim(r.condition) = ''
WITH count(r) AS canThieuDieuKien
MATCH (s:Shape)
WHERE s.specParallel IS NULL OR s.specSides IS NULL OR s.specAngles IS NULL
   OR s.specDiagonals IS NULL OR s.specSymmetry IS NULL
RETURN canThieuDieuKien, count(s) AS hinhThieuDacTa;
// Mong đợi: 0 | 0
```

```cypher
// 3.2 Bảng đặc tả 8 hình (nguồn cho bảng so sánh trên web)
MATCH (s:Shape)
RETURN s.name AS hinh, s.specParallel AS canhSongSong, s.specSides AS canhBangNhau,
       s.specAngles AS goc, s.specDiagonals AS duongCheo, s.specSymmetry AS trucDoiXung
ORDER BY s.sortOrder;
// Mong đợi: 8 dòng
```

```cypher
// 3.3 Điều kiện trên các cạnh IS_A
MATCH (a:Shape)-[r:IS_A]->(b:Shape)
RETURN a.name AS hinhDacBiet, b.name AS hinhTongQuat, r.condition AS dieuKien
ORDER BY a.sortOrder, b.sortOrder;
// Mong đợi: 10 dòng
```

```cypher
// 3.4 So sánh Hình chữ nhật và Hình thoi: tính chất chỉ có ở hình chữ nhật
MATCH (:Shape {slug: 'hinh-chu-nhat'})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p:Property)
WHERE NOT EXISTS {
  MATCH (:Shape {slug: 'hinh-thoi'})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p)
}
RETURN count(DISTINCT p) AS riengHinhChuNhat;
// Mong đợi: 6   (đổi chỗ hai slug: riêng hình thoi = 7)
```

```cypher
// 3.5 Quan hệ và hình tổng quát chung gần nhất (Hình chữ nhật – Hình thoi)
MATCH (a:Shape {slug: 'hinh-chu-nhat'}), (b:Shape {slug: 'hinh-thoi'})
RETURN EXISTS { (a)-[:IS_A*1..]->(b) } AS chuNhatLaThoi,
       EXISTS { (b)-[:IS_A*1..]->(a) } AS thoiLaChuNhat;
// Mong đợi: false | false

MATCH p1 = (:Shape {slug: 'hinh-chu-nhat'})-[:IS_A*0..]->(c:Shape),
      p2 = (:Shape {slug: 'hinh-thoi'})-[:IS_A*0..]->(c)
RETURN c.name AS hinhChungGanNhat, length(p1) + length(p2) AS khoangCach
ORDER BY khoangCach LIMIT 1;
// Mong đợi: Hình bình hành | 2
```

Nếu 3.4 hoặc 3.5 cho số khác mong đợi, nghĩa là số `Property` hoặc cách gắn `HAS_PROPERTY` trong DB của bạn khác bản seed gốc (26 tính chất; hình chữ nhật kế thừa 16, hình thoi 17). Khi đó hãy cập nhật các con số trong SRS (AC-20, Phụ lục D.5) cho khớp dữ liệu thực tế, đừng sửa dữ liệu cho khớp tài liệu mà chưa kiểm tra lại nội dung toán.

---

## Bước 4. Các truy vấn cho ứng dụng (dùng tham số, đặt trong Repository)

> **Lưu ý:** các truy vấn ở Bước 4 dùng tham số (`$slug`, `$slugA`, `$slugB`) để **code ứng dụng truyền vào**. **Không dán trực tiếp vào Neo4j Browser** vì sẽ báo lỗi `ParameterMissing`. Muốn chạy thử trong Browser, dùng phần "4.0 Chạy thử trong Neo4j Browser" ngay bên dưới. Bước 4 chỉ để đưa vào Repository của ứng dụng; có thể bỏ qua nếu bạn đã giao việc đó cho agent bằng `PROMPT_BO_SUNG_v2_2.md`.

### 4.0 Chạy thử trong Neo4j Browser (dùng slug cụ thể, không cần tham số)

```cypher
// Hình cha trực tiếp của Hình vuông, kèm điều kiện – mong đợi 2 dòng (Hình chữ nhật, Hình thoi)
MATCH (s:Shape {slug: 'hinh-vuong'})-[r:IS_A]->(cha:Shape)
RETURN cha.slug AS slug, cha.name AS name, r.condition AS dieuKien
ORDER BY cha.sortOrder;
```

```cypher
// Hình con trực tiếp của Hình bình hành, kèm điều kiện – mong đợi 2 dòng (Hình chữ nhật, Hình thoi)
MATCH (con:Shape)-[r:IS_A]->(s:Shape {slug: 'hinh-binh-hanh'})
RETURN con.slug AS slug, con.name AS name, r.condition AS dieuKien
ORDER BY con.sortOrder;
```

```cypher
// Tính chất chung của Hình chữ nhật và Hình thoi – mong đợi 10 dòng
MATCH (:Shape {slug: 'hinh-chu-nhat'})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p:Property)
MATCH (:Shape {slug: 'hinh-thoi'})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p)
RETURN DISTINCT p.id AS id, p.content AS noiDung ORDER BY noiDung;
```

Muốn thử đúng bản có tham số, đặt tham số trước rồi mới chạy (mỗi lệnh `:param` chạy riêng một lần):

```
:param slug => 'hinh-vuong'
:param slugA => 'hinh-chu-nhat'
:param slugB => 'hinh-thoi'
```

Sau đó chạy truy vấn 4.3 – 4.7 bên dưới như bình thường. (Tham số chỉ tồn tại trong phiên Browser hiện tại.)

### Truy vấn có tham số cho ứng dụng

```cypher
// 4.1 Bảng đặc tả 8 hình (trang /compare)
MATCH (s:Shape)
RETURN s.slug AS slug, s.name AS name, s.family AS family,
       s.specParallel AS specParallel, s.specSides AS specSides, s.specAngles AS specAngles,
       s.specDiagonals AS specDiagonals, s.specSymmetry AS specSymmetry
ORDER BY s.sortOrder;

// 4.2 Cạnh IS_A kèm điều kiện (sơ đồ /api/graph và danh sách thay thế)
MATCH (a:Shape)-[r:IS_A]->(b:Shape)
RETURN a.slug AS tu, a.name AS tenTu, b.slug AS den, b.name AS tenDen, r.condition AS dieuKien
ORDER BY a.sortOrder, b.sortOrder;

// 4.3 Hình cha trực tiếp kèm điều kiện, và hình con trực tiếp (trang chi tiết hình)
MATCH (s:Shape {slug: $slug})-[r:IS_A]->(cha:Shape)
RETURN cha.slug AS slug, cha.name AS name, r.condition AS dieuKien ORDER BY cha.sortOrder;

MATCH (con:Shape)-[r:IS_A]->(s:Shape {slug: $slug})
RETURN con.slug AS slug, con.name AS name, r.condition AS dieuKien ORDER BY con.sortOrder;

// 4.4 Quan hệ giữa hai hình
MATCH (a:Shape {slug: $slugA}), (b:Shape {slug: $slugB})
RETURN EXISTS { (a)-[:IS_A*1..]->(b) } AS aLaDacBietCuaB,
       EXISTS { (b)-[:IS_A*1..]->(a) } AS bLaDacBietCuaA;

// 4.5 Hình tổng quát chung gần nhất
MATCH p1 = (a:Shape {slug: $slugA})-[:IS_A*0..]->(c:Shape),
      p2 = (b:Shape {slug: $slugB})-[:IS_A*0..]->(c)
RETURN c.name AS hinhChung, length(p1) + length(p2) AS khoangCach
ORDER BY khoangCach LIMIT 1;

// 4.6 Tính chất chung của hai hình (khử trùng theo Property.id)
MATCH (a:Shape {slug: $slugA})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p:Property)
MATCH (b:Shape {slug: $slugB})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p)
RETURN DISTINCT p.id AS id, p.content AS noiDung ORDER BY noiDung;

// 4.7 Tính chất chỉ có ở hình A (gọi lại với A, B đổi chỗ để lấy phần riêng của B)
MATCH (a:Shape {slug: $slugA})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p:Property)
WHERE NOT EXISTS {
  MATCH (:Shape {slug: $slugB})-[:IS_A*0..]->(:Shape)-[:HAS_PROPERTY]->(p)
}
RETURN DISTINCT p.id AS id, p.content AS noiDung ORDER BY noiDung;
```

---

## Phụ lục. Hoàn tác (chỉ dùng khi cần)

Xóa các thuộc tính mới để về lại trạng thái bản 2.1 (không ảnh hưởng dữ liệu khác):

```cypher
MATCH (s:Shape)
REMOVE s.specParallel, s.specSides, s.specAngles, s.specDiagonals, s.specSymmetry;

MATCH ()-[r:IS_A]->()
REMOVE r.condition;
```
