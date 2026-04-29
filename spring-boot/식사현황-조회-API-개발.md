# 식사 현황 조회 기능 개발 정리

> 작성일: 2026-04-29
> 참고 프로젝트: meal-management, meal-management-front

---

## 개발 순서 (기능별 개발 방식)

1. MealView.vue 화면 개발 (UI 먼저)
2. Spring Boot 조회 API 수정 (날짜 범위 조회)
3. MealRecordResponse DTO 추가
4. Vue.js API 연동
5. 테스트

---

## Step 1 - MealView.vue 화면 구성

화면 구성:
- 홈 버튼 (대시보드 이동)
- 검색 조건 카드
  - 시작일/종료일 날짜 선택
  - 회사 선택 드롭다운 (ADMIN만 표시)
  - 조회 버튼
- 조회 결과 테이블
  - 날짜, 회사명, 팀명, 중식 인원, 석식 인원, 총 인원, 합계 금액
  - 총 건수 배지
- 합계 섹션 (총 중식, 총 석식, 총 금액)

주요 포인트:
- 이번 달 1일 ~ 오늘 날짜를 기본값으로 자동 설정
- ADMIN은 회사 선택 가능, VIEWER는 자기 회사만 조회
- computed로 합계 자동 계산
- mounted() 에서 자동 조회

---

## Step 2 - Spring Boot API 수정

### MealRecordRepository 추가 메서드

findByRecordDateBetween(LocalDate, LocalDate): 날짜 범위 전체 조회
findByCompanyIdAndRecordDateBetween(Long, LocalDate, LocalDate): 회사+날짜 범위 조회

### MealRecordService 추가 메서드

getMealRecordsByDateRange(LocalDate, LocalDate): 날짜 범위 전체 조회

### MealRecordController API 수정

GET /api/meal-records?startDate=2026-04-01&endDate=2026-04-29
GET /api/meal-records?startDate=2026-04-01&endDate=2026-04-29&companyId=1

companyId가 있으면 회사별 조회, 없으면 전체 조회

---

## Step 3 - MealRecordResponse DTO 추가

@JsonIgnore로 숨겨진 company, companyTeam 정보를
Response DTO에서 꺼내서 Vue.js에 전달해요.

MealRecordResponse 필드:
- id
- recordDate (String)
- companyName (company.getCompanyName())
- teamName (companyTeam.getTeamName())
- lunchCount
- dinnerCount
- totalCount
- totalAmount

---

## Step 4 - Vue.js API 연동

loadMealRecords() 메서드에서 GET /api/meal-records 호출
params로 startDate, endDate, companyId(선택) 전달

---

## 발생한 문제 및 해결

### 문제 - 400 Bad Request

원인: 소스코드 수정 후 서버 재실행을 안 함
해결: Shift + F10 으로 서버 재실행

교훈: 소스 수정 후 반드시 서버 재실행!

---

## 합계 계산 (computed)

totalLunchCount = mealRecords의 lunchCount 합계
totalDinnerCount = mealRecords의 dinnerCount 합계
totalAmount = mealRecords의 totalAmount 합계

Array.reduce()로 합계 계산
mealRecords.reduce((sum, r) => sum + (r.totalAmount || 0), 0)

---

## 핵심 정리

1. ADMIN/VIEWER 역할별 UI 분기 (localStorage의 role 활용)
2. MealRecordResponse DTO로 @JsonIgnore 우회
3. 날짜 범위 파라미터: startDate, endDate
4. computed로 합계 자동 계산
5. 소스 수정 후 반드시 서버 재실행!
