# Vue.js + Spring Boot 로그인 API 연동 시행착오 정리

> 작성일: 2026-04-23
> 참고 프로젝트: meal-management + meal-management-front

---

## 발생했던 문제 전체 목록

1. 403 Forbidden (Spring Security 차단)
2. OPTIONS는 200인데 POST만 403
3. 500 Internal Server Error (비밀번호 불일치)
4. PostgreSQL 비밀번호 오류
5. /error 경로 차단
6. BCrypt 해시값 불일치

---

## 문제 1 - 403 Forbidden (Spring Security 차단)

증상: 로그인 API 호출 시 403 에러 발생

원인: SecurityConfig에서 formLogin, httpBasic 비활성화 누락

해결:
.formLogin(formLogin -> formLogin.disable())
.httpBasic(httpBasic -> httpBasic.disable())

이 두 줄이 없으면 Spring Security가 기본 로그인 방식을 사용하려다가 JWT 방식과 충돌해서 403이 나와요.

---

## 문제 2 - OPTIONS는 200인데 POST만 403

증상: CORS Preflight(OPTIONS)는 성공인데 실제 요청(POST)만 403

원인 1: CORS 설정에서 OPTIONS 메서드 누락
해결: config.setAllowedMethods에 OPTIONS 추가
config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"))

원인 2: authorizeHttpRequests에서 OPTIONS 허용 누락
해결: 아래 줄 추가
.requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()

---

## 문제 3 - /error 경로 차단

증상: Spring Boot에서 에러가 발생하면 /error로 포워딩되는데
이 경로도 Spring Security가 막아서 실제 에러 내용을 볼 수 없었어요.

콘솔 로그:
Securing POST /error
Http403ForbiddenEntryPoint: Pre-authenticated entry point called. Rejecting access

해결: authorizeHttpRequests에 /error 허용 추가
.requestMatchers("/error").permitAll()

---

## 문제 4 - PostgreSQL 비밀번호 오류

증상: 서버 실행 시 아래 에러 발생
Unable to open JDBC Connection for DDL execution
password authentication failed for user "postgres"

원인: application.properties에서 비밀번호를 아래처럼 placeholder로 남겨둔 것
spring.datasource.password=여기에_비밀번호_입력

해결: PostgreSQL 설치 시 설정한 실제 비밀번호로 변경

---

## 문제 5 - BCrypt 해시값 불일치

증상: 로그인 시 "아이디 또는 비밀번호가 올바르지 않습니다" 500 에러 발생

원인: pgAdmin에서 직접 INSERT할 때 사용한 BCrypt 해시값이
실제로 "1234"를 암호화한 값이 아니었어요.
BCrypt는 같은 문자열도 매번 다른 해시값을 생성하기 때문에
임의로 만든 해시값은 절대 일치할 수 없어요!

해결: DataInitializer.java 클래스를 만들어서
서버 시작 시 PasswordEncoder.encode("1234")로 올바르게 암호화된 계정을 생성

DataInitializer 핵심 코드:
if (!userRepository.existsByUsername("admin")) {
    User admin = new User();
        admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("1234")); // 올바른 암호화!
                admin.setRole(User.Role.ADMIN);
                    admin.setIsActive(true);
                        userRepository.save(admin);
                        }

                        ---

                        ## 문제 6 - UserDetailsServiceAutoConfiguration 충돌

                        증상: Spring Boot 기본 보안 설정과 커스텀 SecurityConfig가 충돌

                        해결: MealManagementApplication.java에서 자동 설정 제외
                        @SpringBootApplication(exclude = {UserDetailsServiceAutoConfiguration.class})

                        ---

                        ## 디버깅 방법 - Spring Security 로그 활성화

                        application.properties에 아래 한 줄 추가하면
                        Spring Security가 왜 요청을 차단하는지 자세히 볼 수 있어요.

                        logging.level.org.springframework.security=DEBUG

                        문제 해결 후에는 삭제하거나 INFO로 변경하는 게 좋아요!

                        ---

                        ## 최종 해결 후 결과

                        admin/1234 → 로그인 → /dashboard (대시보드) 이동 성공
                        operator/1234 → 로그인 → /meal-input (식사 입력) 이동 성공
                        viewer/1234 → 로그인 → /meal-view (식사 현황) 이동 성공

                        ---

                        ## 핵심 교훈

                        1. Spring Security 설정 시 formLogin, httpBasic 반드시 비활성화
                        2. CORS 설정에 OPTIONS 메서드 반드시 포함
                        3. /error 경로도 permitAll() 해줘야 실제 에러를 볼 수 있음
                        4. BCrypt 해시값은 직접 만들면 안 되고 PasswordEncoder.encode()로 생성
                        5. DataInitializer로 초기 데이터를 자동 생성하면 편리
                        6. 문제 해결 시 logging.level.org.springframework.security=DEBUG 활용
