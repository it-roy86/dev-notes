로그인개발# JWT 로그인 API 개발 정리

> 작성일: 2026-04-23
> 참고 프로젝트: meal-management

---

## 개발 순서

```
1. pom.xml에 JWT 라이브러리 추가
2. JwtUtil 작성 (토큰 생성/검증)
3. DTO 작성 (LoginRequestDto, LoginResponseDto)
4. JwtAuthenticationFilter 작성 (경비원)
5. SecurityConfig 작성 (접근 권한 설정)
6. AuthService 작성 (로그인 로직)
7. AuthController 작성 (로그인 API)
8. DB에 테스트 계정 INSERT
9. IntelliJ HTTP Client로 테스트
```

---

## Step 1 - pom.xml JWT 라이브러리 추가

```xml
<!-- JWT -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.5</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId>
    <version>0.11.5</version>
    <scope>runtime</scope>
</dependency>
```

추가 후 Maven 재동기화: Ctrl + Shift + O

---

## Step 2 - JwtUtil.java (util 패키지)

토큰 생성, 검증, 사용자 정보 추출을 담당해요.

주요 메서드:
- generateToken(username, role): 토큰 생성
- getUsernameFromToken(token): 토큰에서 사용자명 추출
- getRoleFromToken(token): 토큰에서 역할 추출
- validateToken(token): 토큰 유효성 검사

---

## Step 3 - DTO 작성 (dto 패키지)

LoginRequestDto: 로그인 요청 데이터 (username, password)
LoginResponseDto: 로그인 응답 데이터 (token, role, username)

---

## Step 4 - JwtAuthenticationFilter.java (util 패키지)

모든 API 요청마다 실행되는 경비원이에요.
요청 헤더에서 JWT 토큰을 꺼내서 유효한지 확인하고
유효하면 Spring Security에 인증 정보를 등록해요.

Authorization 헤더 형식: Bearer {토큰}

---

## Step 5 - SecurityConfig.java (config 패키지)

API별 접근 권한을 설정해요.

```
/api/auth/**     → 누구나 접근 가능 (로그인 API)
/api/admin/**    → ADMIN만 접근 가능
/api/meal/input/ → ADMIN, OPERATOR만 접근 가능
나머지          → 로그인한 사람이면 모두 접근 가능
```

중요 설정:
- CSRF 비활성화 (JWT 방식에서 불필요)
- formLogin 비활성화
- httpBasic 비활성화
- 세션 STATELESS 설정
- CORS 설정 (Vue.js localhost:5173 허용)
- BCryptPasswordEncoder 빈 등록

---

## Step 6 - AuthService.java (service 패키지)

로그인 처리 순서:
1. 아이디로 사용자 조회
2. 계정 활성화 여부 확인 (is_active)
3. 비밀번호 확인 (BCrypt 비교)
4. JWT 토큰 발급
5. 토큰 + 역할 + 사용자명 반환

---

## Step 7 - AuthController.java (controller 패키지)

POST /api/auth/login

요청:
{
  "username": "admin",
  "password": "1234"
}

응답:
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "role": "ADMIN",
  "username": "admin"
}

---

## Step 8 - 테스트 계정 DB INSERT

비밀번호 "1234"를 BCrypt로 암호화한 값을 사용해요.

```sql
INSERT INTO "user" (username, password, role, is_active, created_at, updated_at)
VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBpwTTyU9WQfYi', 'ADMIN', true, NOW(), NOW()),
('operator', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBpwTTyU9WQfYi', 'OPERATOR', true, NOW(), NOW()),
('viewer', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBpwTTyU9WQfYi', 'VIEWER', true, NOW(), NOW());
```

---

## Step 9 - IntelliJ HTTP Client 테스트

src/main/resources/test.http 파일 생성 후 아래 내용 입력

### 로그인 테스트
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "1234"
}

각 ### 위에 초록색 실행 버튼을 클릭하면 바로 테스트 가능해요!

---

## 자주 발생하는 에러

| 에러 | 원인 | 해결 방법 |
|------|------|----------|
| 403 Forbidden | formLogin, httpBasic 비활성화 안 됨 | SecurityConfig에 disable() 추가 |
| 노란 경고 | 코드 스타일 제안 | 무시해도 됨 (작동에 문제 없음) |

---

## 핵심 정리

JWT 로그인 API는 이 순서로 만들어요.
JwtUtil(토큰 도구) → Filter(경비원) → SecurityConfig(권한 설정) → Service(로직) → Controller(API)
테스트는 IntelliJ 내장 HTTP Client로 Postman 없이도 가능해요!
