-- 1. 테이블 스키마 찾기
SELECT owner, table_name 
FROM all_tables 
WHERE table_name = '테이블명';

-- 2. 테이블명 부분 검색
SELECT owner, table_name 
FROM all_tables 
WHERE table_name LIKE '%검색어%';

-- 3. 시노님(별명)으로 연결된 경우
SELECT owner, synonym_name, table_owner, table_name
FROM all_synonyms
WHERE synonym_name = '테이블명';

-- 시노님이란?
-- 다른 스키마에 있는 테이블에 별명을 붙여주는 기능
-- 예) BILLING.TB_INET_CONTRACT 를 TB_INET_CONTRACT 로 줄여서 사용 가능
-- 쿼리에서 테이블명만 있고 스키마가 없다면 시노님일 가능성 있음
