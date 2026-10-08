import neo4j
import sys

sys.stdout.reconfigure(encoding='utf-8')

def run_verify():
    driver = neo4j.GraphDatabase.driver('bolt://127.0.0.1:7687', auth=('neo4j', '12345678'))
    with open('db/verify.cypher', 'r', encoding='utf-8') as f:
        text = f.read()

    queries = [q.strip() for q in text.split(';') if q.strip()]

    print("==================================================")
    print("BÁO CÁO KIỂM TRA DỮ LIỆU NEO4J (VERIFY.CYPHER)")
    print("==================================================\n")

    with driver.session(database='neo4j') as session:
        for idx, q in enumerate(queries, 1):
            clean_lines = [l for l in q.splitlines() if not l.strip().startswith('//')]
            query_str = '\n'.join(clean_lines).strip()
            if not query_str:
                continue
            try:
                res = session.run(query_str).data()
                print(f"--- [Mục {idx}] ---")
                for row in res:
                    print(row)
                print()
            except Exception as e:
                print(f"Lỗi ở query {idx}: {e}")

    driver.close()

if __name__ == '__main__':
    run_verify()
