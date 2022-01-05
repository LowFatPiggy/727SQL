/*
    DQL (QUERY 데이터 질의 언어) : SELECT 
    
    DML (MANIPULATION 데이터 조작 언어) : [SELECT], INSERT, UPDATE, DELETE
    DDL (DEFINITION 데이터 정의 언어) : CREATE, ALTER, DROP
    DCL (CONTROL 데이터 제어 언어) : GRANT, REVOKE, [COMMIT, ROLLBACK]
    
    TCL (TRANSACTION 트랜잭션 제어 언어) : COMMIT, ROLLBACK
    
    < DML : DATA MANIPULATION LANGUAGE >
    데이터 조작 언어
    
    테이블에 값을 삽입(INSERT)하거나, 수정(UPDATE)하거나, 삭제(DELETE)하는 구문
    
*/

/*
    1. INSERT
       테이블에 새로운 행을 추가하는 구문
       
       [표현식]
       1) INSERT INTO 테이블명 VALUES(값, 값, 값, 값, ...);
          테이블에 모든 컬럼에 대한 값을 직접 제시해서 한 행 INSERT하고자 할 때 사용 
          컬럼 순번을 지켜서 VALUES에 값을 나열
*/

INSERT INTO EMPLOYEE 
VALUES(900, '한수지', '980914-2451321', 'suji_han@gy.or.kr', '01011112222',
       'D1', 'J7', 4000000, 0.2, 200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

/*
    2) INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명) VALUES(값, 값, 값);
       테이블에서 선택한 컬럼에 대한 값만 INSERT할 때 사용 
       한 행 단위로 추가되기 때문에 
       선택안된 컬럼은 기본적으로 NULL 
       => NOT NULL제약조건이 걸려있는 컬럼은 반드시 선택해서 직접 값 제시
       단, 기본값(DEFAULT)이 지정되어있으면 NULL이 아닌 기본값
       
*/
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES(901, '나미리', '870918-2456124', 'J7', SYSDATE);

SELECT * FROM EMPLOYEE;

INSERT 
  INTO EMPLOYEE
       (
         EMP_ID
       , EMP_NAME
       , EMP_NO
       , JOB_CODE
       , HIRE_DATE
       )
VALUES
      (
         901
       , '나미리'
       , '870918-2456124'
       , 'J7'
       , SYSDATE
       );

----------------------------------------------------------------------

/*
    3) INSERT INTO 테이블명 (서브쿼리);
       VALUES 로 값을 직접 명시하는거 대신에
       서브쿼리로 조회된 결과값을 통채로 INSERT 가능 (여러행 INSERT 가능)
*/
-- 새로운 테이블 세팅
CREATE TABLE EMP_01 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

-- 전체 사원들의 사번, 이름, 부서명 조회
INSERT INTO EMP_01
    (SELECT EMP_ID, EMP_NAME, DEPT_TITLE
     FROM EMPLOYEE
     LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));
     -- LEFT 사용 전 : 부서가 NULL값인 사원들 제외
     -- LEFT 사용 후 : 부서 NULL값 사원들 포함

----------------------------------------------------------------------

/*
    2. INSERT ALL
       두개 이상의 테이블에 각각 INSERT할때 
       이때 사용되는 서브쿼리가 동일 할 경우 
*/
--> 우선 테스트할 테이블 만들기
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
   FROM EMPLOYEE
   WHERE 1=0; 

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
   FROM EMPLOYEE
   WHERE 1=0;

SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;

-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

/*
    [표현식]
    INSERT ALL
    INTO 테이블명1 VALUES(컬럼명, 컬럼명, ..)
    INTO 테이블명2 VALUES(컬럼명, 컬럼명, ...)
        서브쿼리;
*/
INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';

SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;


-- * 조건을 사용해서도 각 테이블에 값 INSERT 가능

-- 2000년도 이전 입사한 입사자들 정보 테이블
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1=0;
   
-- 2000년도 이후 입사한 입사자들 정보 테이블
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1=0;
   
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

/*
    [표현식]
    INSERT ALL
    WHEN 조건1 THEN
        INTO 테이블명1 VALUES(컬럼명, 컬럼명, ..)
    WHEN 조건2 THEN
        INTO 테이블명2 VALUES(컬럼명, 컬럼명, ..)
    서브쿼리;
*/

INSERT ALL
WHEN HIRE_DATE < '2000/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2000/01/01' THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE;


----------------------------------------------------------------------

/*
    UPDATE
    테이블에 기존 데이터를 수정하는 구문
    
    [표현식]
    UPDATE 테이블명
    SET 컬럼명 = 바꿀값,
        컬럼명 = 바꿀값,
        ...     --> 여러개의 컬럼값 동시변경 가능 (,로 나열 AND X)
        [WHERE 조건];  --> 생략하면 전체 모든 행의 데이터 변경 
*/

-- 복사본 테이블 생성 후 작업
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

-- D9부서의 부서명을 '전략기획팀'으로 수정
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'; -- 문제발생!) 9개 행 업데이트 => 조건 제시

ROLLBACK;

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

-- 노옹철 사원의 급여를 100만원으로 수정
-- 선동일 사원의 급여를 700만원, 보너스는 0.2로 변경
-- (복사본으로 진행)
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
   FROM EMPLOYEE;
   
UPDATE EMP_SALARY
SET SALARY = 1000000
WHERE EMP_NAME = '이훈이';

SELECT * FROM EMP_SALARY;

UPDATE EMP_SALARY
SET SALARY = 7000000,
    BONUS = 0.2
WHERE EMP_NAME = '김철수';

/*
    UPDATE시 서브쿼리를 사용 가능
    
    UPDATE 테이블명
    SET 컬럼명 = (서브쿼리)
    WHERE 조건;
*/

-- 이훈이 사원의 급여와 보너스값을 김철수사원의 급여와 보너스값으로 변경
UPDATE EMP_SALARY 
SET SALARY = (SELECT SALARY
              FROM EMP_SALARY
              WHERE EMP_NAME = '김철수'),
    BONUS = (SELECT BONUS
             FROM EMP_SALARY
             WHERE EMP_NAME = '김철수')
WHERE EMP_NAME = '이훈이';

-- 다중열 서브쿼리로도 가능
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                       FROM EMP_SALARY
                       WHERE EMP_NAME = '김철수')
WHERE EMP_NAME = '이훈이';

-- ASIA 지역에서 근무하는 사원들의 보너스값을 0.3으로 변경

-- ASIA지역 사원들 조회 (ASIA1, ASIA2, ASIA3)
SELECT *
FROM EMP_SALARY
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';

-- ASIA지역 사원들 보너스 0.3 변경
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                 FROM EMP_SALARY
                 JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                 JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                 WHERE LOCAL_NAME LIKE 'ASIA%');
                 
                 
----------------------------------------------------------------------

-- UPDATE시 해당 컬럼에 대한 제약조건에 위배되면 X

-- 사번이 200번인 사원의 이름을 NULL로 변경
UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200; --> NOT NULL 제약조건 위배(EMP_NAME에 NOT NULL 조건)

-- 한유리 사원의 직급코드를 J9로 변경
UPDATE EMPLOYEE
SET JOB_CODE = 'J9'
WHERE EMP_NAME = '한유리';  -- FOREIGN KEY 제약조건 위배 ('J9'는 존재하지 않기 때문)


----------------------------------------------------------------------
COMMIT;

/*
    4. DELETE
       테이블에 기록된 데이터를 삭제하는 구문 (한 행 단위로 삭제)
       
       [표현식]
       DELETE FROM 테이블명
       [WHERE 조건]; --> !!!! WHERE절 제시 안하면 전체 행 다 삭제 !!!!
*/

DELETE FROM EMPLOYEE; -- 전체 삭제

SELECT * FROM EMPLOYEE;
ROLLBACK; --> 마지막 커밋시점으로 복귀

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '한수지';

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '나미리';

COMMIT;

-- 데이터값을 자식데이터가 사용하고 있다면 삭제 X
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1'; -- D1의 값을 사용하는 자식데이터가 있기 때문에 삭제X

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3'; 

ROLLBACK;



-- * TRUNCATE : 테이블의 전체 행을 삭제할 때 사용되는 구문
--              DELETE보다 더 빠른 수행속도
--              별도의 조건제시 불가, ROLLBACK 불가
-- [표현식] TRUNCATE TABLE 테이블명;

SELECT * FROM EMP_SALARY;

TRUNCATE TABLE EMP_SALARY;
ROLLBACK; -- 롤백 불가
