// ============================================================================
// SCRIPT KIỂM TRA TÍNH TOÀN VẸN DỮ LIỆU NEO4J (VERIFY.CYPHER)
// ============================================================================

// 1. Kiểm tra số lượng Shape (Kỳ vọng: đúng 8 hình)
MATCH (s:Shape)
RETURN count(s) AS SoLuongShape, 
       CASE WHEN count(s) = 8 THEN 'DAT' ELSE 'KHONG_DAT' END AS KetQua;

// 2. Liệt kê 8 Shape và slug tương ứng
MATCH (s:Shape)
RETURN s.slug AS Slug, s.name AS TenHinh, s.family AS HoHinh
ORDER BY s.sortOrder;

// 3. Kiểm tra số quan hệ IS_A (Kỳ vọng: đúng 10 quan hệ)
MATCH (child:Shape)-[r:IS_A]->(parent:Shape)
RETURN count(r) AS SoQuanHeIS_A,
       CASE WHEN count(r) = 10 THEN 'DAT' ELSE 'KHONG_DAT' END AS KetQua;

// 4. Danh sách 10 quan hệ IS_A (hình đặc biệt -> hình tổng quát)
MATCH (child:Shape)-[:IS_A]->(parent:Shape)
RETURN child.slug + ' -> ' + parent.slug AS QuanHe_IS_A
ORDER BY QuanHe_IS_A;

// 5. Kiểm tra tổng số câu hỏi Question (Kỳ vọng: >= 40)
MATCH (q:Question)
RETURN count(q) AS TongSoCauHoi,
       CASE WHEN count(q) >= 40 THEN 'DAT' ELSE 'KHONG_DAT' END AS KetQua;

// 6. Kiểm tra số câu hỏi trên mỗi Shape (Kỳ vọng: mỗi Shape >= 5 câu)
MATCH (s:Shape)-[:HAS_QUESTION]->(q:Question)
WITH s.slug AS Slug, s.name AS TenHinh, count(q) AS SoCauHoi
RETURN Slug, TenHinh, SoCauHoi,
       CASE WHEN SoCauHoi >= 5 THEN 'DAT' ELSE 'KHONG_DAT' END AS KetQua
ORDER BY SoCauHoi ASC;

// 7. Kiểm tra mỗi Question có đúng 4 AnswerOption
MATCH (q:Question)
OPTIONAL MATCH (q)-[:HAS_OPTION]->(o:AnswerOption)
WITH q.id AS QuestionId, count(o) AS SoDapAn
WHERE SoDapAn <> 4
RETURN count(QuestionId) AS SoCauSaiSoDapAn,
       CASE WHEN count(QuestionId) = 0 THEN 'DAT (Tat ca cau deu co dung 4 dap an)' ELSE 'KHONG_DAT' END AS KetQua;

// 8. Kiểm tra mỗi Question có đúng 1 đáp án đúng (isCorrect = true)
MATCH (q:Question)
OPTIONAL MATCH (q)-[:HAS_OPTION]->(o:AnswerOption {isCorrect: true})
WITH q.id AS QuestionId, count(o) AS SoDapAnDung
WHERE SoDapAnDung <> 1
RETURN count(QuestionId) AS SoCauSaiDapAnDung,
       CASE WHEN count(QuestionId) = 0 THEN 'DAT (Tat ca cau deu co dung 1 dap an dung)' ELSE 'KHONG_DAT' END AS KetQua;

// 9. Kiểm tra mỗi Question đều có trường explanation (lời giải)
MATCH (q:Question)
WHERE q.explanation IS NULL OR trim(q.explanation) = ''
RETURN count(q) AS SoCauThieuLoiGiai,
       CASE WHEN count(q) = 0 THEN 'DAT (Tat ca cau deu co loi giai day du)' ELSE 'KHONG_DAT' END AS KetQua;

// 10. Thống kê số lượng node theo từng nhãn học liệu
CALL db.labels() YIELD label
CALL {
    WITH label
    MATCH (n) WHERE label IN labels(n)
    RETURN count(n) AS SoLuong
}
RETURN label AS Nhan, SoLuong
ORDER BY SoLuong DESC;
