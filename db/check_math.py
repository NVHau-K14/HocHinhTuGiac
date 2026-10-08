import neo4j
import sys

sys.stdout.reconfigure(encoding='utf-8')

def check_questions():
    driver = neo4j.GraphDatabase.driver('bolt://127.0.0.1:7687', auth=('neo4j', '12345678'))
    with driver.session(database='neo4j') as s:
        rows = s.run('''
            MATCH (sh:Shape)-[:HAS_QUESTION]->(q:Question)
            OPTIONAL MATCH (q)-[:HAS_OPTION]->(o:AnswerOption)
            RETURN sh.slug AS shape, sh.name AS shapeName, sh.sortOrder AS sortOrder, q.id AS qid, q.content AS content, q.type AS type,
                   collect({id: o.id, content: o.content, isCorrect: o.isCorrect}) AS opts, q.explanation AS exp
            ORDER BY sortOrder, qid
        ''').data()

        print(f"Tổng số câu hỏi: {len(rows)}\n")
        current_shape = ""
        for r in rows:
            if r['shapeName'] != current_shape:
                current_shape = r['shapeName']
                print(f"\n==========================================")
                print(f"HÌNH: {current_shape} ({r['shape']})")
                print(f"==========================================")

            correct = [opt['content'] for opt in r['opts'] if opt['isCorrect']]
            corr_str = correct[0] if correct else "CHƯA CÓ ĐÁP ÁN ĐÚNG!"
            print(f"- [{r['qid']}] [{r['type']}]: {r['content']}")
            print(f"  + Đáp án đúng: {corr_str}")
            print(f"  + Lời giải: {r['exp']}")

    driver.close()

if __name__ == '__main__':
    check_questions()
