# IntelliJ 내장 DB 툴 사용법

> 작성일: 2026-05-01
> > 참고 프로젝트: meal-management (PostgreSQL)
> >
> > ---
> >
> > ## IntelliJ 내장 DB 툴 vs DataGrip
> >
> > | | IntelliJ 내장 DB 툴 | DataGrip |
> > |--|--|--|
> > | 비용 | Ultimate 버전에 포함 (추가 비용 없음) | 별도 유료 구독 |
> > | 기능 | 기본 기능 충분 | 더 풍부한 기능 |
> > | 속도 | IntelliJ와 함께 실행 | 가볍고 빠름 |
> > | 학습 난이도 | 쉬움 | 쉬움 |
> > | 추천 상황 | 소규모 프로젝트, 비용 절감 | 대규모 DB 작업 |
> >
> > 소규모 프로젝트에서는 IntelliJ 내장 DB 툴로 충분해요!
> >
> > ---
> >
> > ## PostgreSQL 연결 방법
> >
> > ### 1단계 - Database 탭 열기
> >
> > IntelliJ 우측 세로 탭에서 Database 클릭
> > 없으면 상단 메뉴 View → Tool Windows → Database
> >
> > ### 2단계 - Data Source 추가
> >
> > + 버튼 클릭 → Data Source → PostgreSQL 선택
> >
> > + ### 3단계 - 연결 정보 입력
> >
> > + | 항목 | 값 |
> > + |------|------|
> > + | Host | localhost |
> > + | Port | 5432 |
> > + | Database | meal_management |
> > + | User | postgres |
> > + | Password | 설치 시 설정한 비밀번호 |
> >
> > + ### 4단계 - 드라이버 다운로드
> >
> > + 처음 연결 시 하단에 "Download missing driver files" 메시지가 나와요.
> > + Download 버튼 클릭해서 PostgreSQL 드라이버를 다운로드해요.
> >
> > + ### 5단계 - 연결 테스트
> >
> > + Test Connection 버튼 클릭
> > + "Successful" 메시지가 나오면 OK 클릭
> >
> > + ---
> >
> > + ## 주요 기능 사용법
> >
> > + ### 테이블 조회
> >
> > + 왼쪽 트리에서
> > + meal_management → public → Tables → 테이블명 더블클릭
> >
> > + ### SQL 쿼리 실행
> >
> > + 테이블 우클릭 → Open in Query Console
> > + 또는 상단 + 버튼 → Query Console
> >
> > + 단축키:
> > + - 쿼리 실행: Ctrl + Enter
> >   - - 전체 실행: Ctrl + Shift + Enter
> >    
> >     - ### 자주 쓰는 쿼리
> >    
> >     - 전체 조회:
> >     - SELECT * FROM "user";
> >     - SELECT * FROM company;
> > SELECT * FROM company_team;
> > SELECT * FROM meal_record;
> >
> > 특정 날짜 식사 기록 조회:
> > SELECT * FROM meal_record WHERE record_date = '2026-04-29';
> >
> > 활성 회사 목록 조회:
> > SELECT * FROM company WHERE is_active = true;
> >
> > ### 데이터 직접 수정
> >
> > 테이블 더블클릭 → 셀 직접 수정 → Ctrl + Enter로 저장
> > 또는 UPDATE 쿼리 실행
> >
> > ### ERD 보기 (테이블 관계도)
> >
> > 테이블 선택 후 우클릭 → Diagrams → Show Diagram
> > 테이블 간의 관계를 시각적으로 확인할 수 있어요.
> >
> > ---
> >
> > ## Oracle DB 스키마 조회 쿼리 (참고)
> >
> > Oracle DB 사용 시 테이블 조회 방법이에요.
> >
> > 정확한 테이블명으로 조회:
> > SELECT owner, table_name FROM all_tables WHERE table_name = '테이블명';
> >
> > 부분 검색:
> > SELECT owner, table_name FROM all_tables WHERE table_name LIKE '%검색어%';
> >
> > 시노님 찾기:
> > SELECT owner, synonym_name, table_owner, table_name
> > FROM all_synonyms WHERE synonym_name = '테이블명';
> >
> > ---
> >
> > ## 핵심 정리
> >
> > IntelliJ Ultimate 버전 사용 중이라면 내장 DB 툴로 충분해요.
> > 추가 비용 없이 PostgreSQL 연결, 쿼리 실행, ERD 확인까지 가능해요.
> > pgAdmin4와 병행해서 사용해도 좋아요!
