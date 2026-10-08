// ==========================================
// RÀNG BUỘC UNIQUE VÀ CHỈ MỤC CHO HỆ THỐNG NEO4J
// ==========================================

// Ràng buộc duy nhất trên Shape slug
CREATE CONSTRAINT c_shape_slug IF NOT EXISTS FOR (s:Shape) REQUIRE s.slug IS UNIQUE;

// Ràng buộc duy nhất trên Question id
CREATE CONSTRAINT c_question_id IF NOT EXISTS FOR (q:Question) REQUIRE q.id IS UNIQUE;

// Ràng buộc duy nhất trên Learner clientId
CREATE CONSTRAINT c_learner_client_id IF NOT EXISTS FOR (l:Learner) REQUIRE l.clientId IS UNIQUE;

// Ràng buộc duy nhất trên QuizAttempt id
CREATE CONSTRAINT c_attempt_id IF NOT EXISTS FOR (a:QuizAttempt) REQUIRE a.id IS UNIQUE;

// Ràng buộc duy nhất trên các nút kiến thức
CREATE CONSTRAINT c_property_id IF NOT EXISTS FOR (p:Property) REQUIRE p.id IS UNIQUE;
CREATE CONSTRAINT c_theorem_id IF NOT EXISTS FOR (t:Theorem) REQUIRE t.id IS UNIQUE;
CREATE CONSTRAINT c_recognition_id IF NOT EXISTS FOR (r:Recognition) REQUIRE r.id IS UNIQUE;
CREATE CONSTRAINT c_formula_id IF NOT EXISTS FOR (f:Formula) REQUIRE f.id IS UNIQUE;
CREATE CONSTRAINT c_example_id IF NOT EXISTS FOR (e:Example) REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT c_answer_option_id IF NOT EXISTS FOR (o:AnswerOption) REQUIRE o.id IS UNIQUE;
CREATE CONSTRAINT c_definition_id IF NOT EXISTS FOR (d:Definition) REQUIRE d.id IS UNIQUE;

// Chỉ mục tìm kiếm văn bản searchText
CREATE INDEX idx_shape_search IF NOT EXISTS FOR (s:Shape) ON (s.searchText);
CREATE INDEX idx_property_search IF NOT EXISTS FOR (p:Property) ON (p.searchText);
CREATE INDEX idx_theorem_search IF NOT EXISTS FOR (t:Theorem) ON (t.searchText);
CREATE INDEX idx_recognition_search IF NOT EXISTS FOR (r:Recognition) ON (r.searchText);
CREATE INDEX idx_formula_search IF NOT EXISTS FOR (f:Formula) ON (f.searchText);
