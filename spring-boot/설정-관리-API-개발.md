# 설정 관리 기능 개발 정리

> 작성일: 2026-04-25
> > 참고 프로젝트: meal-management, meal-management-front
> >
> > ---
> >
> > ## 개발 순서 (기능별 개발 방식)
> >
> > 기능별 개발 방식으로 화면 먼저 만들고 API를 나중에 개발했어요.
> >
> > 1. SettingView.vue UI 작성 (화면 먼저)
> > 2. 2. CompanyService, CompanyController 작성
> >    3. 3. CompanyRepository 메서드 추가
> >       4. 4. CompanyTeamService, CompanyTeamController 작성
> >          5. 5. CompanyTeamRepository 메서드 추가
> >             6. 6. SettingView.vue API 연동
> >               
> >                7. ---
> >               
> >                8. ## Spring Boot - 회사 API
> >               
> >                9. ### API 목록
> >
> > | 메서드 | URL | 기능 |
> > |--------|-----|------|
> > | GET | /api/companies | 회사 목록 조회 |
> > | GET | /api/companies/{id} | 회사 단건 조회 |
> > | POST | /api/companies | 회사 등록 |
> > | PUT | /api/companies/{id} | 회사 수정 |
> > | DELETE | /api/companies/{id} | 회사 삭제 (소프트 딜리트) |
> >
> > ### CompanyService 주요 메서드
> >
> > - getActiveCompanies(): is_active = true인 회사 목록 반환
> > - - getCompany(id): 단건 조회, 없으면 RuntimeException 발생
> >   - - createCompany(company): is_active = true 설정 후 저장
> >     - - updateCompany(id, updatedCompany): 회사명, 사업자번호, 이메일 수정
> >       - - deleteCompany(id): is_active = false로 소프트 딜리트
> >        
> >         - ### CompanyRepository 추가 메서드
> >        
> >         - findByIsActiveTrue(): 활성 회사 목록 조회
> >         - existsByCompanyName(name): 회사명 중복 여부 확인
> >        
> >         - ---
> >
> > ## Spring Boot - 팀 API
> >
> > ### API 목록
> >
> > | 메서드 | URL | 기능 |
> > |--------|-----|------|
> > | GET | /api/companies/{companyId}/teams | 팀 목록 조회 |
> > | POST | /api/companies/{companyId}/teams | 팀 등록 |
> > | PUT | /api/companies/{companyId}/teams/{id} | 팀 수정 |
> > | DELETE | /api/companies/{companyId}/teams/{id} | 팀 삭제 |
> >
> > 팀은 반드시 특정 회사에 속하기 때문에
> > URL 구조에 companyId가 포함되어 있어요.
> >
> > ### CompanyTeamRepository 추가 메서드
> >
> > findByCompanyIdAndIsActiveTrue(companyId): 특정 회사의 활성 팀 목록 조회
> >
> > ---
> >
> > ## 시행착오 - @JsonIgnore 순환 참조 문제
> >
> > ### 문제
> >
> > 팀 목록 조회 API(GET /api/companies/{id}/teams) 호출 시 500 에러 발생
> >
> > 원인: CompanyTeam이 Company를 참조하고
> > JSON 변환 시 CompanyTeam → Company → CompanyTeam... 무한 순환 참조 발생
> >
> > ### 해결
> >
> > CompanyTeam.java의 company 필드에 @JsonIgnore 추가
> >
> > @JsonIgnore
> > @ManyToOne(fetch = FetchType.LAZY)
> > @JoinColumn(name = "company_id")
> > private Company company;
> >
> > @JsonIgnore를 붙이면 JSON 변환 시 해당 필드를 무시해요.
> > 순환 참조를 방지하는 가장 간단한 방법이에요.
> >
> > ---
> >
> > ## Vue.js - 설정 화면 API 연동
> >
> > ### mounted() 활용
> >
> > 컴포넌트가 화면에 마운트될 때 자동으로 데이터를 불러와요.
> >
> > mounted() {
> >   this.loadCompanies()
> > }
> >
> > ### 회사 등록/수정 분기 처리
> >
> > editingCompany가 있으면 수정(PUT), 없으면 등록(POST)으로 처리해요.
> >
> > if (this.editingCompany) {
> >   await api.put('/api/companies/' + this.editingCompany.id, this.companyForm)
> > } else {
> >   await api.post('/api/companies', this.companyForm)
> > }
> >
> > ### null 체크
> >
> > 단가가 null일 때 화면에 아무것도 안 나오는 문제 발생
> > toLocaleString()은 null에서 호출하면 에러가 나요.
> >
> > 해결: null 체크 추가
> > {{ team.lunchPrice != null ? team.lunchPrice.toLocaleString() : '-' }}원
> >
> > ---
> >
> > ## 핵심 정리
> >
> > - 팀은 회사에 종속되므로 URL에 companyId 포함
> > - - @JsonIgnore로 순환 참조 방지
> >   - - mounted()로 화면 진입 시 데이터 자동 로드
> >     - - null 체크는 toLocaleString() 호출 전에 반드시 필요
