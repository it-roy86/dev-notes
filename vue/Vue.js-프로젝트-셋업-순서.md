# Vue.js 프로젝트 올바른 셋업 순서

> 작성일: 2026-04-22
> 참고 프로젝트: meal-management-front

---

## 문제점 발견

Vue.js 프로젝트를 처음 세팅할 때 순서가 잘못되어 아래와 같은 문제가 발생했어요.

- router 등록 전에 axios 설치 및 LoginView.vue 작성을 먼저 시도
- main.js에 router 등록이 누락되어 화면이 빈 채로 나옴
- View 파일이 없는 상태에서 router에 등록하여 Vite 에러 발생

---

## 올바른 셋업 순서

### 1단계 - router/index.js 설정

라우터 파일에 사용할 경로와 View 파일을 미리 등록해요.

### 2단계 - App.vue 수정

RouterView 컴포넌트만 남기고 불필요한 코드를 제거해요.

### 3단계 - main.js 수정 (router 등록) ← 가장 중요!

router를 가져와서 앱에 등록해줘야 해요.
이게 없으면 화면이 아무것도 안 나와요!

import router from './router'
createApp(App).use(router).mount('#app')

### 4단계 - 빈 View 파일 생성 (에러 방지)

router에 등록한 View 파일이 실제로 존재해야 해요.
파일이 없으면 Vite가 아래 에러를 발생시켜요.

Failed to resolve import "../views/DashboardView.vue"
Does the file exist?

따라서 router에 등록한 View 파일을 모두 미리 만들어두세요.
내용은 비어있어도 괜찮아요!

### 5단계 - 개발 서버 실행 및 확인

npm run dev

브라우저에서 http://localhost:5173 접속해서 화면이 정상적으로 나오는지 확인해요.

### 6단계 - 필요한 라이브러리 설치

화면 구조가 확인된 이후에 라이브러리를 설치해요.

npm install axios

### 7단계 - 실제 기능 코드 작성

구조가 잡힌 이후에 각 View 파일에 실제 기능 코드를 작성해요.

---

## 올바른 순서 요약

1. router/index.js 설정
2. App.vue 수정
3. main.js 수정 (router 등록)
4. 빈 View 파일 생성 (에러 방지)
5. npm run dev 실행 및 화면 확인
6. 필요한 라이브러리 설치 (axios 등)
7. 실제 기능 코드 작성

---

## 핵심 정리

Vue.js 프로젝트는 구조를 먼저 잡고 기능을 채워나가야 해요.
router 설정 → App.vue → main.js → View 파일 생성 → 서버 확인
이 순서를 지키면 불필요한 에러 없이 개발을 시작할 수 있어요!
