# NEO4J_UPDATE_v2_3.md – Thêm nhãn ngắn và lý do cho 10 cạnh IS_A

Chạy **sau** `NEO4J_UPDATE_v2_2.md` (đã có `condition`). File này thêm hai thuộc tính cho mỗi cạnh `IS_A`, phục vụ việc làm sơ đồ quan hệ trực quan hơn:

- `conditionShort`: nhãn ngắn (≤ 30 ký tự) hiển thị ngay trên mũi tên trong sơ đồ.
- `reason`: câu giải thích **vì sao hai hình có quan hệ cha–con** (hiển thị khi bấm vào mũi tên).

Lệnh dùng `MATCH` + `SET`, chạy lặp được, không tạo node/quan hệ mới. Quy ước chiều: `(hình con)-[:IS_A]->(hình cha)`, tức hình đặc biệt → hình tổng quát.

---

## Bước 1. Thêm conditionShort và reason

```cypher
UNWIND [
  ['hinh-thang', 'tu-giac', 'có 1 cặp cạnh đối song song',
   'Tứ giác có ít nhất một cặp cạnh đối song song thì gọi là hình thang, nên mọi hình thang đều là tứ giác.'],
  ['hinh-dieu', 'tu-giac', 'có 2 cặp cạnh kề bằng nhau',
   'Hình diều là tứ giác có hai cặp cạnh kề bằng nhau, nên mọi hình diều đều là tứ giác.'],
  ['hinh-thang-can', 'hinh-thang', 'có 2 góc kề đáy bằng nhau',
   'Hình thang cân là hình thang có thêm điều kiện hai góc kề một đáy bằng nhau, nên mọi hình thang cân đều là hình thang.'],
  ['hinh-binh-hanh', 'hinh-thang', 'cặp cạnh còn lại cũng song song',
   'Hình bình hành có hai cặp cạnh đối song song, trong đó đã có ít nhất một cặp, nên thỏa định nghĩa hình thang.'],
  ['hinh-chu-nhat', 'hinh-binh-hanh', 'có 1 góc vuông',
   'Hình chữ nhật có bốn góc vuông nên các cạnh đối song song (cùng vuông góc với một cạnh), tức là có hai cặp cạnh đối song song: thỏa định nghĩa hình bình hành.'],
  ['hinh-chu-nhat', 'hinh-thang-can', 'có 1 góc vuông',
   'Hình chữ nhật có hai cạnh đối song song nên là hình thang, và hai góc kề một đáy cùng bằng 90° nên bằng nhau: thỏa định nghĩa hình thang cân (theo định nghĩa bao hàm của bài học).'],
  ['hinh-thoi', 'hinh-binh-hanh', 'có 2 cạnh kề bằng nhau',
   'Hình thoi có bốn cạnh bằng nhau nên các cạnh đối bằng nhau, suy ra các cạnh đối song song: thỏa định nghĩa hình bình hành.'],
  ['hinh-thoi', 'hinh-dieu', 'có 4 cạnh bằng nhau',
   'Hình thoi có bốn cạnh bằng nhau nên có hai cặp cạnh kề bằng nhau: thỏa định nghĩa hình diều (theo định nghĩa của bài học).'],
  ['hinh-vuong', 'hinh-chu-nhat', 'có 2 cạnh kề bằng nhau',
   'Hình vuông có bốn góc vuông nên thỏa định nghĩa hình chữ nhật.'],
  ['hinh-vuong', 'hinh-thoi', 'có 1 góc vuông',
   'Hình vuông có bốn cạnh bằng nhau nên thỏa định nghĩa hình thoi.']
] AS e
MATCH (:Shape {slug: e[0]})-[r:IS_A]->(:Shape {slug: e[1]})
SET r.conditionShort = e[2], r.reason = e[3]
RETURN count(r) AS soCanDaCapNhat;
// Mong đợi: 10
```

---

## Bước 2. Kiểm tra

```cypher
// 2.1 Đủ 10/10 cạnh có condition, conditionShort và reason – mong đợi 0
MATCH ()-[r:IS_A]->()
WHERE r.condition IS NULL OR r.conditionShort IS NULL OR r.reason IS NULL
RETURN count(r) AS canThieu;
```

```cypher
// 2.2 Xem 10 cạnh – mong đợi 10 dòng
MATCH (a:Shape)-[r:IS_A]->(b:Shape)
RETURN a.name AS hinhCon, b.name AS hinhCha, r.conditionShort AS nhan, r.condition AS dieuKien, r.reason AS lyDo
ORDER BY a.sortOrder, b.sortOrder;
```

```cypher
// 2.3 Thử truy vấn cho panel (slug cụ thể, dán chạy được trong Browser): Hình vuông -> Hình chữ nhật
MATCH (c:Shape {slug: 'hinh-vuong'})-[r:IS_A]->(p:Shape {slug: 'hinh-chu-nhat'})
OPTIONAL MATCH (c)-[:HAS_DEFINITION]->(dc:Definition)
OPTIONAL MATCH (p)-[:HAS_DEFINITION]->(dp:Definition)
RETURN c.name AS hinhCon, p.name AS hinhCha, r.condition AS dieuKien, r.reason AS lyDo,
       dc.content AS dinhNghiaCon, dp.content AS dinhNghiaCha;
// Mong đợi: 1 dòng, đủ các cột
```

```cypher
// 2.4 Tính chất hình con được thừa hưởng qua cạnh này – mong đợi vài chục dòng, có cột nguon
MATCH (:Shape {slug: 'hinh-vuong'})-[:IS_A]->(p:Shape {slug: 'hinh-chu-nhat'})
MATCH (p)-[:IS_A*0..]->(a:Shape)-[:HAS_PROPERTY]->(x:Property)
RETURN DISTINCT x.id AS id, x.content AS noiDung, a.name AS nguon
ORDER BY nguon, noiDung;
```

---

## Hoàn tác (chỉ khi cần)

```cypher
MATCH ()-[r:IS_A]->() REMOVE r.conditionShort, r.reason;
```
