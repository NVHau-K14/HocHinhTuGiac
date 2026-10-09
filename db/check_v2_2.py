import neo4j
import sys

sys.stdout.reconfigure(encoding='utf-8')

def main():
    try:
        driver = neo4j.GraphDatabase.driver('bolt://127.0.0.1:7687', auth=('neo4j', '12345678'))
        with driver.session(database='neo4j') as s:
            # Kiểm tra bước 3.1
            res = s.run('''
                MATCH ()-[r:IS_A]->() WHERE r.condition IS NULL OR trim(r.condition) = ''
                WITH count(r) AS canThieuDieuKien
                MATCH (s:Shape)
                WHERE s.specParallel IS NULL OR s.specSides IS NULL OR s.specAngles IS NULL
                   OR s.specDiagonals IS NULL OR s.specSymmetry IS NULL
                RETURN canThieuDieuKien, count(s) AS hinhThieuDacTa
            ''').data()
            print('KẾT QUẢ KIỂM TRA 3.1:', res)

            # Kiểm tra tổng quan
            shapes = s.run('MATCH (s:Shape) RETURN s.slug AS slug, s.name AS name, s.specParallel AS specParallel ORDER BY s.sortOrder').data()
            print('Số Shape:', len(shapes))
            for sh in shapes:
                print(f"  - {sh['slug']}: {sh.get('specParallel')}")

            edges = s.run('MATCH (a:Shape)-[r:IS_A]->(b:Shape) RETURN a.slug AS tu, b.slug AS den, r.condition AS condition ORDER BY a.sortOrder, b.sortOrder').data()
            print('Số cạnh IS_A:', len(edges))
            for ed in edges:
                print(f"  - {ed['tu']} -> {ed['den']}: {ed.get('condition')}")

        driver.close()
    except Exception as ex:
        print('LỖI KẾT NỐI / TRUY VẤN:', ex)

if __name__ == '__main__':
    main()
