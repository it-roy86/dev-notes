# 일일 식사 입력 기능 개발 정리

> 작성일: 2026-04-29
> 참고 프로젝트: meal-management, meal-management-front

---

## 개발 순서 (기능별 개발 방식)

1. MealInputView.vue 화면 개발 (UI 먼저)
2. Spring Boot MealRecord API 개발
3. MealRecord Entity @JsonIgnore 추가
4. Vue.js API 연동
5. 저장 테스트

---

## Step 1 - MealInputView.vue 화면 개발

화면 구성:
- 날짜 선택 (오늘 날짜 기본값)
- 회사 선택 드롭다운 (API 연동)
- 팀 선택 드롭다운 (회사 선택 시 자동 로드)
- 중식/석식 인원 입력
- 자동 계산 섹션 (단가 x 인원, 합계)
- 저장 버튼
- 홈 버튼 (대시보드 이동)

주요 포인트:
- computed로 금액 자동 계산
- 회사 변경 시 팀 목록 초기화 후 재조회
- 팀 선택 시 selectedTeam에 단가 정보 저장

---

## Step 2 - Spring Boot API 개발

### MealRecordRepository 추가 메서드

findByRecordDate(LocalDate): 날짜별 조회
findByCompanyIdAndRecordDateBetween(Long, LocalDate, LocalDate): 회사+날짜 범위 조회

### MealRecordService 주요 메서드

createMealRecord(): 식사 기록 저장
- 회사/팀 정보로 단가 자동 조회
- 총 인원 및 총 금액 자동 계산
- SecurityContextHolder로 현재 로그인 사용자 조회

getMealRecordsByDate(): 날짜별 조회
getMealRecordsByCompanyAndDateRange(): 회사+날짜 범위 조회

### MealRecordController API 목록

POST /api/meal-records - 식사 기록 저장
GET  /api/meal-records?date=2026-04-29 - 날짜별 조회

요청 데이터 (MealRecordRequest):
{
  "recordDate": "2026-04-29",
  "companyId": 1,
  "companyTeamId": 1,
  "lunchCount": 10,
  "dinnerCount": 5
}

---

## Step 3 - MealRecord Entity @JsonIgnore 추가

순환 참조 방지를 위해 3개 필드에 @JsonIgnore 추가

@JsonIgnore - company 필드
@JsonIgnore - companyTeam 필드
@JsonIgnore - createdBy 필드

---

## Step 4 - Vue.js API 연동

saveMealRecord() 메서드에서 POST /api/meal-records 호출
저장 성공 시 폼 초기화

---

## 자동 계산 로직 (computed)

lunchAmount = lunchPrice x lunchCount
dinnerAmount = dinnerPrice x dinnerCount
totalAmount = lunchAmount + dinnerAmount

computed를 사용하면 인원을 입력할 때마다 자동으로 금액이 계산돼요!

---

## 핵심 정리

1. computed로 반응형 자동 계산 구현
2. 회사 선택 시 팀 목록 자동 로드 (onCompanyChange)
3. SecurityContextHolder로 현재 로그인 사용자 조회
4. MealRecord의 연관 Entity에 @JsonIgnore 필수
5. 총 인원/금액은 서버에서 자동 계산해서 저장
