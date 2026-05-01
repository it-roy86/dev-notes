# VIEWER 로그인 및 데이터 제한 기능 개발 정리

> 작성일: 2026-05-01
> 참고 프로젝트: meal-management, meal-management-front

---

## 왜 만들었나?

기획서에 VIEWER(경리담당자)는 자기 회사 데이터만 조회 가능해야 해요.
하지만 기존에는 VIEWER도 전체 데이터를 조회할 수 있었어요.
또한 회원가입 기능 없이 간단하게 로그인할 수 있는 방법이 필요했어요.

---

## VIEWER 로그인 방식 결정

회원가입 없이 아래 방식으로 로그인해요.

회사 선택 + 사업자번호 뒤 4자리 입력 → VIEWER JWT 토큰 발급

장점:
- 별도 계정 관리 불필요
- 관리자가 회사 등록 시 사업자번호만 입력하면 경리담당자 로그인 가능
- 간단하고 직관적인 인증 방식

---

## 백엔드 개발 내용

### 1. JwtUtil 수정

generateViewerToken(username, companyId): VIEWER 전용 토큰 생성
- 기존 generateToken()과 다르게 companyId를 클레임에 포함해요.
- 이후 API에서 companyId를 DB 조회 없이 JWT에서 바로 꺼낼 수 있어요.

getCompanyIdFromToken(token): 토큰에서 companyId 추출

### 2. AuthService 수정

viewerLogin(companyId, businessNumberLast4):
1. 회사 ID로 회사 조회
2. 활성화 여부 확인
3. 사업자번호 뒤 4자리 일치 여부 확인
4. VIEWER JWT 토큰 발급 (companyId 포함)

### 3. AuthController 수정

POST /api/auth/viewer-login 추가
- companyId + businessNumberLast4 받아서 VIEWER 로그인 처리

### 4. JwtAuthenticationFilter 수정

credentials에 companyId 저장
- 기존: credentials = null
- 변경: credentials = companyId (Long)
- 이렇게 하면 Controller에서 DB 조회 없이 companyId를 꺼낼 수 있어요.

### 5. CompanyController 수정

GET /api/companies/public 추가 (로그인 없이 접근 가능)
- 경리담당자 로그인 화면에서 회사 선택 드롭다운에 사용해요.
- SecurityConfig에 permitAll() 추가

VIEWER 자기 회사만 반환:
- getCurrentRole()이 VIEWER면 JWT의 companyId로 자기 회사만 반환

### 6. MealRecordController 수정

VIEWER 데이터 제한:
- getCurrentRole()로 역할 확인
- VIEWER면 getCurrentCompanyId()로 companyId 가져와서 강제 필터링
- 파라미터로 넘어온 companyId 무시

### 7. SettlementController 수정

MealRecordController와 동일하게 VIEWER 데이터 제한 적용

### 8. SecurityConfig 수정

/api/companies/public permitAll() 추가

---

## 프론트엔드 개발 내용

### LoginView.vue 탭 UI 추가

탭 1 - 관리자/운영자:
- 아이디 + 비밀번호 입력
- ADMIN → 대시보드, OPERATOR → 식사 입력 화면 이동

탭 2 - 경리담당자:
- 회사 선택 드롭다운 (공개 API로 회사 목록 조회)
- 사업자번호 뒤 4자리 입력
- 로그인 성공 시 식사 현황 조회 화면 이동

### DashboardView.vue 역할별 메뉴 제한

| 메뉴 | ADMIN | OPERATOR | VIEWER |
|------|-------|----------|--------|
| 설정 관리 | O | X | X |
| 식사 입력 | O | O | X |
| 현황 조회 | O | O | O |
| 월별 정산 | O | X | O |

localStorage의 role 값으로 v-if 조건 처리

---

## JWT에서 companyId 가져오는 방법

Controller에서 DB 조회 없이 JWT의 companyId를 꺼내는 유틸 메서드예요.

```java
// 현재 역할 조회
private String getCurrentRole() {
    return SecurityContextHolder.getContext()
            .getAuthentication()
            .getAuthorities()
            .iterator()
            .next()
            .getAuthority()
            .replace("ROLE_", "");
}

// VIEWER의 회사 ID 조회
private Long getCurrentCompanyId() {
    Object credentials = SecurityContextHolder.getContext()
            .getAuthentication()
            .getCredentials();
    return credentials instanceof Long ? (Long) credentials : null;
}
```

MealRecordController, SettlementController에 각각 추가해요.

---

## 핵심 정리

1. 회원가입 없이 회사 선택 + 사업자번호 뒤 4자리로 VIEWER 로그인
2. JWT 토큰에 companyId 포함 → DB 조회 없이 데이터 제한 가능
3. JwtAuthenticationFilter credentials에 companyId 저장
4. Controller에서 getCurrentRole(), getCurrentCompanyId()로 VIEWER 판별
5. 공개 API(/api/companies/public)로 로그인 전 회사 목록 조회 가능
6. DashboardView에서 역할별 메뉴 v-if 조건으로 제한
