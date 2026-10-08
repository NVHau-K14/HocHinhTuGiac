import neo4j
import sys

sys.stdout.reconfigure(encoding='utf-8')

def apply_seed():
    driver = neo4j.GraphDatabase.driver('bolt://127.0.0.1:7687', auth=('neo4j', '12345678'))
    with open('db/seed.cypher', 'r', encoding='utf-8') as f:
        text = f.read()

    # Split by semicolon followed by newline
    queries = [q.strip() for q in text.split(';\n') if q.strip()]

    print(f"Bắt đầu thực thi {len(queries)} câu lệnh trong seed.cypher...")
    success = 0
    with driver.session(database='neo4j') as session:
        for idx, q in enumerate(queries, 1):
            clean_lines = [l for l in q.splitlines() if not l.strip().startswith('//')]
            query_str = '\n'.join(clean_lines).strip()
            if not query_str:
                continue
            try:
                session.run(query_str)
                success += 1
            except Exception as e:
                print(f"Lỗi ở query #{idx}: {e}")
                print("Query gây lỗi:\n", query_str[:200])
                break

    driver.close()
    print(f"Hoàn thành: {success}/{len(queries)} câu lệnh thực thi thành công.")

if __name__ == '__main__':
    apply_seed()
