# JpaRepository 정리

> 작성일: 2026-04-17
> 참고 프로젝트: meal-management

---

## JpaRepository란?

Spring Data JPA에서 제공하는 인터페이스예요.
이것만 상속받으면 기본적인 CRUD 기능이 자동으로 생겨요!

---

## 기본 제공 메서드 (자동 생성)

| 메서드 | 기능 |
|--------|------|
| findAll() | 전체 조회 |
| findById(id) | ID로 단건 조회 |
| save(entity) | 저장 / 수정 |
| deleteById(id) | ID로 삭제 |
| count() | 전체 개수 조회 |
| existsById(id) | 존재 여부 확인 |

---

## 메서드 이름 규칙

| 키워드 | 설명 | 예시 |
|--------|------|------|
| findBy | 조회 | findByUsername |
| existsBy | 존재 여부 | existsByUsername |
| countBy | 개수 조회 | countByIsActiveTrue |
| deleteBy | 삭제 | deleteByIsActiveFalse |
| And | 조건 추가 | findByCompanyIdAndIsActiveTrue |
| Or | 또는 조건 | findByUsernameOrEmail |
| Between | 범위 조회 | findByRecordDateBetween |
| True/False | boolean 조건 | findByIsActiveTrue |
| OrderBy | 정렬 | findByIsActiveTrueOrderByCreatedAtDesc |

---

## Oracle DAO vs JpaRepository 비교

| | Oracle + iBatis (기존) | JpaRepository (신규) |
|--|--|--|
| 쿼리 작성 | XML에 직접 SQL 작성 | 메서드 이름으로 자동 생성 |
| 기본 CRUD | 직접 구현 | 자동 제공 |
| 코드 양 | 많음 | 적음 |
| 복잡한 쿼리 | SQL로 자유롭게 | @Query로 직접 작성 가능 |

---

## 핵심 정리

JpaRepository를 상속받으면
기본 CRUD는 자동으로 생기고
메서드 이름 규칙만 지키면
웬만한 쿼리는 자동으로 만들어진다!
