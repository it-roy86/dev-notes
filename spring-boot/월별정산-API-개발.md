# 월별 정산 기능 개발 정리

> 작성일: 2026-04-29
> 참고 프로젝트: meal-management, meal-management-front

---

## 개발 순서 (기능별 개발 방식)

1. SettlementView.vue 화면 개발 (UI 먼저)
2. DashboardView.vue 메뉴 카드 추가
3. router/index.js 경로 추가
4. Spring Boot 정산 API 개발
5. MealRecord Entity FetchType 변경
6. 테스트

---

## Step 1 - SettlementView.vue 화면 구성

화면 구성:
- 홈 버튼 (대시보드 이동)
- 검색 조건 카드
  - 년월 선택 input type=month (이번 달 기본값)
  - 회사 선택 드롭다운 (ADMIN만 표시)
  - 조회 버튼
- 정산 결과 카드
  - 회사별 섹션 (회사명, 총 금액 뱃지)
  - 팀별 정산 테이블 (팀명, 중식/석식 인원/금액, 합계)
  - 합계 행 (tfoot)
  - 전체 합계 (computed)

주요 포인트:
- type=month 입력으로 yyyy-MM 형식 자동 처리
- ADMIN/VIEWER 역할별 UI 분기
- computed로 전체 합계 자동 계산
- mounted()에서 이번 달 데이터 자동 조회

---

## Step 2 - Spring Boot API 개발

### SettlementController

GET /api/settlement?yearMonth=2026-04&companyId=1(선택)

처리 순서:
1. yearMonth(yyyy-MM) → YearMonth.parse()로 파싱
2. atDay(1), atEndOfMonth()로 시작일/종료일 계산
3. 식사 기록 전체 조회
4. 회사별로 그룹핑 (Collectors.groupingBy)
5. 팀별로 그룹핑 후 집계
6. CompanySettlement 목록 반환

### DTO 구조

TeamSettlement:
- teamName
- lunchCount (중식 총 인원)
- dinnerCount (석식 총 인원)
- lunchAmount (중식 단가 x 인원)
- dinnerAmount (석식 단가 x 인원)
- totalAmount

CompanySettlement:
- companyId
- companyName
- teams (List<TeamSettlement>)
- totalLunchCount
- totalDinnerCount
- totalLunchAmount
- totalDinnerAmount
- totalAmount

---

## Step 3 - MealRecord FetchType 변경

정산 API는 company, companyTeam 정보를 직접 접근해야 해요.
LAZY 로딩이면 트랜잭션 밖에서 데이터 접근 시 LazyInitializationException 발생!

변경 전: FetchType.LAZY
변경 후: FetchType.EAGER

대상 필드:
- company
- companyTeam

---

## LAZY vs EAGER 차이

LAZY (지연 로딩):
- 실제로 사용할 때 쿼리 실행
- 성능에 유리하지만 트랜잭션 밖에서 접근 불가

EAGER (즉시 로딩):
- 조회 시 연관 데이터 즉시 함께 조회
- 트랜잭션 밖에서도 접근 가능
- 정산처럼 연관 데이터를 반드시 사용하는 경우 적합

---

## 집계 로직 (Java Stream)

회사별 그룹핑:
records.stream()
  .collect(Collectors.groupingBy(r -> r.getCompany().getId()))

팀별 그룹핑:
records.stream()
  .collect(Collectors.groupingBy(r -> r.getCompanyTeam().getTeamName()))

합계 계산:
teams.stream().mapToInt(TeamSettlement::getLunchCount).sum()

---

## 테스트 결과

2026년 04월 조회
대박유통 - 개발팀
- 중식: 20명 x 6,500원 = 130,000원
- 석식: 5명 x 7,000원 = 35,000원
- 합계: 165,000원
전체 합계: 165,000원

---

## 핵심 정리

1. type=month 입력으로 yyyy-MM 형식 처리
2. YearMonth로 월의 시작일/종료일 자동 계산
3. Java Stream groupingBy로 회사/팀별 집계
4. 정산처럼 연관 데이터 필수 접근 시 FetchType.EAGER 사용
5. DTO에서 집계 로직 처리 (CompanySettlement, TeamSettlement)
