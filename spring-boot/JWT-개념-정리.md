# JWT (JSON Web Token) 개념 정리

> 작성일: 2026-04-22
> 참고 프로젝트: meal-management

---

## JWT가 뭐야?

JWT는 쉽게 말하면 디지털 신분증이에요.

놀이공원에서 입장권을 받으면 그걸 보여주고 들어가듯이,
로그인하면 JWT 토큰을 받고 그걸로 API를 사용하는 거예요.

---

## 왜 JWT를 쓸까?

### 기존 방식 (세션)

1. 로그인 → 서버가 "이 사람 로그인했다" 고 기억
2. 요청할 때마다 서버가 기억하는지 확인

문제점: 사용자가 많아지면 서버가 너무 많은 걸 기억해야 해서 부담이 커요.

### JWT 방식

1. 로그인 → 서버가 토큰 발급 후 잊어버림
2. 사용자가 토큰을 가지고 있다가 요청할 때마다 보여줌
3. 서버는 토큰만 확인하면 됨

장점: 서버가 아무것도 기억 안 해도 돼서 훨씬 가벼워요!

---

## JWT 토큰 생김새

JWT는 점(.)으로 구분된 3개의 파트로 이루어져 있어요.

eyJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6InJveSIsInJvbGUiOiJBRE1JTiJ9.SflKxwRJSMeKKF2QT4fwpMeJf36POk6

파트 1 - Header (어떤 방식으로 암호화했는지)
파트 2 - Payload (사용자 정보)
파트 3 - Signature (위조 방지 서명)

---

## Payload 안에 들어있는 정보

Payload를 디코딩하면 이렇게 생겼어요.

{
  "username": "roy",
    "role": "ADMIN",
      "exp": 1234567890
      }

      - username: 누구인지
      - role: 어떤 권한인지 (ADMIN / OPERATOR / VIEWER)
      - exp: 토큰 만료 시간 (언제까지 유효한지)

      ---

      ## meal-management에서 JWT 흐름

      1. 어머니가 아이디/비밀번호 입력
      2. Spring Boot가 확인 후 JWT 토큰 발급
      3. Vue.js가 토큰을 브라우저에 저장 (localStorage)
      4. 이후 모든 API 요청에 토큰을 같이 보냄
      5. Spring Boot가 토큰 확인 후 응답

      역할별 화면 이동
      - ADMIN  → 대시보드
      - OPERATOR → 식사 입력 화면
      - VIEWER → 현황 조회 화면

      ---

      ## 토큰이 없거나 만료되면?

      토큰 없이 API 요청하면 Spring Security가 막아버려요.
      그러면 로그인 화면으로 돌아가야 해요.

      ---

      ## 기존 방식 vs JWT 비교

      | | 세션 방식 | JWT 방식 |
      |--|--|--|
      | 정보 저장 위치 | 서버 | 클라이언트 (브라우저) |
      | 서버 부담 | 높음 | 낮음 |
      | 확장성 | 낮음 | 높음 |
      | Vue.js 연동 | 불편 | 편리 |

      ---

      ## 핵심 정리

      JWT는 로그인하면 발급받는 디지털 신분증이에요.
      서버가 아무것도 기억 안 해도 되서 가볍고
      Vue.js + Spring Boot 조합에 딱 맞는 인증 방식이에요!
