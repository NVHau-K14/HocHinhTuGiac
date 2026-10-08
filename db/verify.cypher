// ==========================================
// KIỂM TRA RÀNG BUỘC VÀ SỐ LƯỢNG DỮ LIỆU NEO4J
// ==========================================

// 1. Kiểm tra các ràng buộc Unique đã được tạo
SHOW CONSTRAINTS;

// 2. Đếm số lượng Shape (Mục tiêu: 8)
MATCH (s:Shape)
RETURN count(s) AS TongSoShape;

// 3. Đếm số quan hệ IS_A (Mục tiêu: 10)
MATCH ()-[r:IS_A]->()
RETURN count(r) AS TongSoIS_A;

// 4. Đếm số lượng câu hỏi Question (Mục tiêu: >= 40)
MATCH (q:Question)
RETURN count(q) AS TongSoQuestion;
