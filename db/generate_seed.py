import neo4j
import json

driver = neo4j.GraphDatabase.driver('bolt://127.0.0.1:7687', auth=('neo4j', '12345678'))

def escape_cypher_str(val):
    if val is None:
        return 'null'
    return json.dumps(str(val), ensure_ascii=False)

def dump_to_seed():
    with driver.session(database='neo4j') as session:
        out = []
        out.append("// ============================================================================")
        out.append("// SEED SCRIPT CHO HỆ THỐNG HỌC HÌNH HỌC PHẲNG: TỨ GIÁC (NEO4J)")
        out.append("// Đáp ứng đầy đủ 8 Shape, 10 IS_A, >= 40 Question với 4 AnswerOption và lời giải.")
        out.append("// Chạy lặp được (MERGE) không gây trùng lặp.")
        out.append("// ============================================================================\n")

        # 1. SHAPES
        out.append("// --------------------------------------------------")
        out.append("// 1. KHỞI TẠO 8 HÌNH (SHAPES)")
        out.append("// --------------------------------------------------\n")
        shapes = session.run("MATCH (s:Shape) RETURN properties(s) AS p ORDER BY s.sortOrder").data()
        for row in shapes:
            p = row['p']
            out.append(f"""MERGE (s:Shape {{slug: '{p['slug']}'}})
ON CREATE SET s.id = '{p['id']}',
              s.name = '{p['name']}',
              s.shortDescription = {escape_cypher_str(p.get('shortDescription', ''))},
              s.searchText = {escape_cypher_str(p.get('searchText', ''))},
              s.sortOrder = {p.get('sortOrder', 0)},
              s.family = {escape_cypher_str(p.get('family', ''))}
ON MATCH SET s.name = '{p['name']}',
             s.shortDescription = {escape_cypher_str(p.get('shortDescription', ''))},
             s.searchText = {escape_cypher_str(p.get('searchText', ''))},
             s.sortOrder = {p.get('sortOrder', 0)},
             s.family = {escape_cypher_str(p.get('family', ''))};
""")

        # 2. IS_A
        out.append("\n// --------------------------------------------------")
        out.append("// 2. QUAN HỆ KẾ THỪA IS_A (ĐÚNG 10 CẠNH: HÌNH ĐẶC BIỆT -> HÌNH TỔNG QUÁT)")
        out.append("// --------------------------------------------------\n")
        isa = session.run("MATCH (a:Shape)-[:IS_A]->(b:Shape) RETURN a.slug AS child, b.slug AS parent ORDER BY a.slug, b.slug").data()
        for row in isa:
            out.append(f"""MATCH (child:Shape {{slug: '{row['child']}'}}), (parent:Shape {{slug: '{row['parent']}'}})
MERGE (child)-[:IS_A]->(parent);
""")

        # 3. DEFINITIONS
        out.append("\n// --------------------------------------------------")
        out.append("// 3. ĐỊNH NGHĨA (DEFINITIONS)")
        out.append("// --------------------------------------------------\n")
        defs = session.run("MATCH (s:Shape)-[:HAS_DEFINITION]->(d:Definition) RETURN s.slug AS slug, properties(d) AS p ORDER BY s.slug").data()
        for row in defs:
            p = row['p']
            out.append(f"""MERGE (d:Definition {{id: '{p['id']}'}})
ON CREATE SET d.content = {escape_cypher_str(p.get('content', ''))},
              d.note = {escape_cypher_str(p.get('note', ''))},
              d.searchText = {escape_cypher_str(p.get('searchText', ''))}
ON MATCH SET d.content = {escape_cypher_str(p.get('content', ''))},
             d.note = {escape_cypher_str(p.get('note', ''))},
             d.searchText = {escape_cypher_str(p.get('searchText', ''))}
WITH d
MATCH (s:Shape {{slug: '{row['slug']}'}})
MERGE (s)-[:HAS_DEFINITION]->(d);
""")

        # 4. PROPERTIES
        out.append("\n// --------------------------------------------------")
        out.append("// 4. TÍNH CHẤT (PROPERTIES - GỒM PROPERTY DÙNG CHUNG KẾ THỪA QUA IS_A)")
        out.append("// --------------------------------------------------\n")
        props = session.run("MATCH (p:Property) RETURN properties(p) AS p ORDER BY p.id").data()
        for row in props:
            p = row['p']
            out.append(f"""MERGE (p:Property {{id: '{p['id']}'}})
ON CREATE SET p.content = {escape_cypher_str(p.get('content', ''))},
              p.searchText = {escape_cypher_str(p.get('searchText', ''))}
ON MATCH SET p.content = {escape_cypher_str(p.get('content', ''))},
             p.searchText = {escape_cypher_str(p.get('searchText', ''))};
""")
        
        # Shape - HAS_PROPERTY
        shape_props = session.run("MATCH (s:Shape)-[:HAS_PROPERTY]->(p:Property) RETURN s.slug AS slug, p.id AS propId ORDER BY s.slug, p.id").data()
        for row in shape_props:
            out.append(f"""MATCH (s:Shape {{slug: '{row['slug']}'}}), (p:Property {{id: '{row['propId']}'}})
MERGE (s)-[:HAS_PROPERTY]->(p);
""")

        # 5. THEOREMS
        out.append("\n// --------------------------------------------------")
        out.append("// 5. ĐỊNH LÝ (THEOREMS)")
        out.append("// --------------------------------------------------\n")
        theorems = session.run("MATCH (s:Shape)-[:HAS_THEOREM]->(t:Theorem) RETURN s.slug AS slug, properties(t) AS p ORDER BY s.slug, t.id").data()
        for row in theorems:
            p = row['p']
            out.append(f"""MERGE (t:Theorem {{id: '{p['id']}'}})
ON CREATE SET t.title = {escape_cypher_str(p.get('title', ''))},
              t.content = {escape_cypher_str(p.get('content', ''))},
              t.searchText = {escape_cypher_str(p.get('searchText', ''))}
ON MATCH SET t.title = {escape_cypher_str(p.get('title', ''))},
             t.content = {escape_cypher_str(p.get('content', ''))},
             t.searchText = {escape_cypher_str(p.get('searchText', ''))}
WITH t
MATCH (s:Shape {{slug: '{row['slug']}'}})
MERGE (s)-[:HAS_THEOREM]->(t);
""")

        # 6. RECOGNITIONS
        out.append("\n// --------------------------------------------------")
        out.append("// 6. DẤU HIỆU NHẬN BIẾT (RECOGNITIONS)")
        out.append("// --------------------------------------------------\n")
        recogs = session.run("MATCH (s:Shape)-[:HAS_RECOGNITION]->(r:Recognition) RETURN s.slug AS slug, properties(r) AS p ORDER BY s.slug, r.id").data()
        for row in recogs:
            p = row['p']
            out.append(f"""MERGE (r:Recognition {{id: '{p['id']}'}})
ON CREATE SET r.content = {escape_cypher_str(p.get('content', ''))},
              r.searchText = {escape_cypher_str(p.get('searchText', ''))}
ON MATCH SET r.content = {escape_cypher_str(p.get('content', ''))},
             r.searchText = {escape_cypher_str(p.get('searchText', ''))}
WITH r
MATCH (s:Shape {{slug: '{row['slug']}'}})
MERGE (s)-[:HAS_RECOGNITION]->(r);
""")

        # 7. FORMULAS
        out.append("\n// --------------------------------------------------")
        out.append("// 7. CÔNG THỨC (FORMULAS - KATEX)")
        out.append("// --------------------------------------------------\n")
        formulas = session.run("MATCH (s:Shape)-[:HAS_FORMULA]->(f:Formula) RETURN s.slug AS slug, properties(f) AS p ORDER BY s.slug, f.id").data()
        for row in formulas:
            p = row['p']
            out.append(f"""MERGE (f:Formula {{id: '{p['id']}'}})
ON CREATE SET f.name = {escape_cypher_str(p.get('name', ''))},
              f.expression = {escape_cypher_str(p.get('expression', ''))},
              f.note = {escape_cypher_str(p.get('note', ''))},
              f.searchText = {escape_cypher_str(p.get('searchText', ''))}
ON MATCH SET f.name = {escape_cypher_str(p.get('name', ''))},
             f.expression = {escape_cypher_str(p.get('expression', ''))},
             f.note = {escape_cypher_str(p.get('note', ''))},
             f.searchText = {escape_cypher_str(p.get('searchText', ''))}
WITH f
MATCH (s:Shape {{slug: '{row['slug']}'}})
MERGE (s)-[:HAS_FORMULA]->(f);
""")

        # 8. EXAMPLES
        out.append("\n// --------------------------------------------------")
        out.append("// 8. VÍ DỤ MINH HỌA (EXAMPLES)")
        out.append("// --------------------------------------------------\n")
        examples = session.run("MATCH (s:Shape)-[:HAS_EXAMPLE]->(e:Example) RETURN s.slug AS slug, properties(e) AS p ORDER BY s.slug, e.id").data()
        for row in examples:
            p = row['p']
            out.append(f"""MERGE (e:Example {{id: '{p['id']}'}})
ON CREATE SET e.title = {escape_cypher_str(p.get('title', ''))},
              e.content = {escape_cypher_str(p.get('content', ''))},
              e.solution = {escape_cypher_str(p.get('solution', ''))}
ON MATCH SET e.title = {escape_cypher_str(p.get('title', ''))},
             e.content = {escape_cypher_str(p.get('content', ''))},
             e.solution = {escape_cypher_str(p.get('solution', ''))}
WITH e
MATCH (s:Shape {{slug: '{row['slug']}'}})
MERGE (s)-[:HAS_EXAMPLE]->(e);
""")

        # 9. QUESTIONS & ANSWER OPTIONS
        out.append("\n// --------------------------------------------------")
        out.append("// 9. CÂU HỎI VÀ ĐÁP ÁN (40 CÂU HỎI, 160 PHƯƠNG ÁN)")
        out.append("// --------------------------------------------------\n")
        qs = session.run("MATCH (s:Shape)-[:HAS_QUESTION]->(q:Question) RETURN s.slug AS slug, properties(q) AS qp ORDER BY qp.id").data()
        for row in qs:
            qp = row['qp']
            out.append(f"""MERGE (q:Question {{id: '{qp['id']}'}})
ON CREATE SET q.content = {escape_cypher_str(qp.get('content', ''))},
              q.type = {escape_cypher_str(qp.get('type', 'THEORY'))},
              q.difficulty = {qp.get('difficulty', 1)},
              q.explanation = {escape_cypher_str(qp.get('explanation', ''))}
ON MATCH SET q.content = {escape_cypher_str(qp.get('content', ''))},
             q.type = {escape_cypher_str(qp.get('type', 'THEORY'))},
             q.difficulty = {qp.get('difficulty', 1)},
             q.explanation = {escape_cypher_str(qp.get('explanation', ''))}
WITH q
MATCH (s:Shape {{slug: '{row['slug']}'}})
MERGE (s)-[:HAS_QUESTION]->(q);
""")

            # Options for this question
            opts = session.run(f"MATCH (q:Question {{id: '{qp['id']}'}})-[:HAS_OPTION]->(o:AnswerOption) RETURN properties(o) AS op ORDER BY op.id").data()
            for opt_row in opts:
                op = opt_row['op']
                is_corr = "true" if op.get('isCorrect') else "false"
                out.append(f"""MERGE (o:AnswerOption {{id: '{op['id']}'}})
ON CREATE SET o.content = {escape_cypher_str(op.get('content', ''))},
              o.isCorrect = {is_corr}
ON MATCH SET o.content = {escape_cypher_str(op.get('content', ''))},
             o.isCorrect = {is_corr}
WITH o
MATCH (q:Question {{id: '{qp['id']}'}})
MERGE (q)-[:HAS_OPTION]->(o);
""")

        with open('db/seed.cypher', 'w', encoding='utf-8') as f:
            f.write('\n'.join(out))
        print("Generated db/seed.cypher successfully!")

if __name__ == '__main__':
    dump_to_seed()
    driver.close()
