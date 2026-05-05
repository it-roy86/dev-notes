# AWS Lightsail Ubuntu 서버 초기 세팅

> 작성일: 2026-05-05
> 목적: Vue.js + Spring Boot Docker 배포 환경 구성

---

## 서버 스펙 권장사항

| 항목 | 권장 사양 |
|------|----------|
| OS | Ubuntu 22.04 LTS |
| RAM | 최소 1GB (2GB 권장) |
| Storage | 최소 20GB |
| 이유 | Spring Boot 빌드 시 메모리 많이 사용 |

---

## 초기 세팅 내용

1. 패키지 업데이트 (apt-get update/upgrade)
2. Docker 설치 (docker-ce, docker-compose-plugin)
3. Swap 메모리 2GB 설정 (메모리 부족 방지)
4. 방화벽 설정 (22, 80, 443, 8080 포트 허용)
5. 유용한 도구 설치 (htop, git, vim)

---

## 사용 방법

### 1. 스크립트 파일 생성

vi server-setup.sh
# 스크립트 내용 붙여넣기 후 :wq 저장

### 2. 실행 권한 부여 및 실행

chmod +x server-setup.sh
./server-setup.sh

### 3. 실행 완료 후 재접속

exit
# SSH로 다시 접속

---

## 열린 포트 설명

| 포트 | 용도 |
|------|------|
| 22 | SSH 접속 |
| 80 | HTTP (Vue.js 프론트엔드) |
| 443 | HTTPS (SSL 인증서 적용 시) |
| 8080 | Spring Boot API |

---

## Swap 메모리란?

RAM이 부족할 때 디스크 일부를 메모리처럼 사용하는 기술이에요.
Lightsail 저사양 서버에서 Spring Boot 빌드 시 메모리 부족을 방지해줘요.
속도는 RAM보다 느리지만 서버가 다운되는 것을 막아줘요.

---

## 주의사항

1. SSH(22번 포트)는 반드시 방화벽 설정 전에 허용해야 해요.
   (안 하면 서버 접속이 끊겨요!)
2. Docker 그룹 적용을 위해 스크립트 실행 후 재접속 필요해요.
3. Swap은 SSD 서버에서는 수명에 영향을 줄 수 있어요.

---

## 설치 확인 명령어

Docker 버전 확인:
docker --version
docker compose version

Swap 확인:
free -h
swapon --show

방화벽 확인:
sudo ufw status verbose
