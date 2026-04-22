# Vue.js 프로젝트 생성 방법

> 작성일: 2026-04-18
> 참고 프로젝트: meal-management-front

---

## 사전 준비

Node.js, npm 설치 완료 필요

버전 확인 방법 (터미널에서)
- node -v
- npm -v

---

## 프로젝트 생성 순서

### 1단계 - IntelliJ 터미널 열기

단축키: Alt + F12

원하는 경로로 이동
cd C:\dev

### 2단계 - Vue.js 프로젝트 생성

npm create vue@latest 프로젝트명

예시
npm create vue@latest meal-management-front

### 3단계 - 옵션 선택

| 질문 | 선택 | 이유 |
|------|------|------|
| Use TypeScript? | No | 입문자에게 JavaScript가 적합 |
| Select features | none | 기본 설정으로 시작 |
| Select experimental features | none | 기본 설정으로 시작 |
| Skip all example code? | No | 예제 코드 포함하여 시작 |

### 4단계 - 패키지 설치

cd meal-management-front
npm install

### 5단계 - 개발 서버 실행

npm run dev

실행 성공 시 아래 메시지가 나와요.
VITE vX.X.X  ready in xxx ms
Local: http://localhost:5173/

### 6단계 - 브라우저 접속 확인

http://localhost:5173 접속
Vue.js 기본 화면이 보이면 성공!

---

## 생성된 프로젝트 구조

meal-management-front/
├── public/          ← 정적 파일
├── src/
│   ├── assets/     ← 이미지, CSS 등
│   ├── components/ ← 재사용 컴포넌트
│   ├── views/      ← 페이지 화면
│   ├── App.vue     ← 루트 컴포넌트
│   └── main.js     ← 진입점
├── index.html
├── package.json    ← 패키지 설정
└── vite.config.js  ← Vite 설정

---

## npm 주요 명령어

| 명령어 | 설명 |
|--------|------|
| npm install | 패키지 설치 |
| npm run dev | 개발 서버 실행 |
| npm run build | 배포용 빌드 |
| npm run preview | 빌드 결과 미리보기 |

---

## 핵심 정리

Vue.js 프로젝트는 npm create vue@latest 명령어 하나로
기본 구조를 자동으로 만들어줘요.
개발 서버는 npm run dev 로 실행하고
http://localhost:5173 으로 접속해서 확인해요!
