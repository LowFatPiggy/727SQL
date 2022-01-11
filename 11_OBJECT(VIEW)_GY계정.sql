/*
    < VIEW 뷰 >
    
    SELECT문(쿼리문)을 저장해둘 수 있는 객체
    (자주 쓰는 긴 SELECT문을 저장해두면 그 긴 SELECT문을 매번 다시 기술할 필요 X)
    임시테이블 같은 존재 (실제 데이터가 담긴 것이 X => 논리적인 테이블)
*/

-- '한국'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING(NATIONAL_CODE)
 WHERE NATIONAL_NAME = '한국';
 
-- '러시아'에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING(NATIONAL_CODE)
 WHERE NATIONAL_NAME = '러시아';

-- '일본'에서 근무하는 사원
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING(NATIONAL_CODE)
 WHERE NATIONAL_NAME = '일본';

------------------------------------------------------------------

/*
    1. VIEW 생성 방법
    
    [표현식]
    CREATE [OR REPLACE] VIEW 뷰명
    AS 서브쿼리;
    
    [OR REPLACE] : 뷰 생성시 기존에 중복된 이름의 뷰가 없다면 새로 뷰를 생성하고,
                            기존에 중복된 이름의 뷰가 있다면 해당 뷰를 변경(갱신)하는 옵션
*/

CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, BONUS
     FROM EMPLOYEE
     JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
     JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
     JOIN NATIONAL USING(NATIONAL_CODE);

-- GRANT CREATE VIEW TO kh;   --> 관리자계정에서 실행

SELECT *
FROM VW_EMPLOYEE;
-- 아래와 같은 맥락
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
        FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
        JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
        JOIN NATIONAL USING(NATIONAL_CODE));
        
-- 뷰는 논리적인 가상 테이블 (실질적으로 데이터를 저장하고 있지 않음)

-- '한국', '러시아', '일본'에 근무하는 사원
SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '한국';

SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '러시아';
 
SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '일본';
 
-- [참고]
SELECT * FROM USER_VIEWS;

------------------------------------------------------------------
/*
    * 뷰 컬럼에 별칭 부여
      서브쿼리의 SELECT절에 함수식이나 산술연산식이 기술되어있을 경우 반드시 별칭 지정
*/
-- 전 사원의 사번, 이름, 직급명, 성별(남/여), 근무년수를 조회하는 SELECT문을 
-- 뷰(VW_EMP_JOB)로 정의
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, 
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') "성별", -- 산술연산식
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "근무년수" -- 상동
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);

-- 아래와 같은 방식으로도 별칭 부여가능
-- 뷰명 뒤에 괄호 안에 별칭 작성 (단, 이때는 모든 컬럼에 대한 별칭을 작성)
CREATE OR REPLACE VIEW VW_EMP_JOB(사번, 이름, 직급명, 성별, 근무년수)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, 
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);

SELECT *
  FROM VW_EMP_JOB;
  
  
SELECT 이름, 직급명
  FROM VW_EMP_JOB
 WHERE 성별 = '여';

SELECT *
  FROM VW_EMP_JOB
 WHERE 근무년수 >= 20;

-- 뷰 삭제하고자 한다면
DROP VIEW VW_EMP_JOB;

------------------------------------------------------------------

-- 생성된 뷰를 이용해서 DML(INSERT, UPDATE, DELETE) 사용가능
-- 뷰를 통해서 조작하게 되면 실제 데이터가 담겨있는 베이스테이블에 반영됨

CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE, JOB_NAME
     FROM JOB;

SELECT * FROM VW_JOB; -- 논리적인 테이블 (실제데이터가 담겨있진 않음)
SELECT * FROM JOB;    -- 베이스 테이블 (실제 데이터가 담겨있음)

-- 뷰를 통해서 INSERT
INSERT INTO VW_JOB VALUES('J8', '인턴'); -- 베이스테이블에 실질적으로 INSERT

-- 뷰를 통해서 UPDATE
UPDATE VW_JOB
   SET JOB_NAME = '알바'
 WHERE JOB_CODE = 'J8';

-- 뷰를 통해서 DELETE
DELETE 
  FROM VW_JOB
 WHERE JOB_CODE = 'J8';

------------------------------------------------------------------

/*
    * 단, DML 명령어로 조작이 불가능한 경우
    
    1) 뷰에 정의되어있지 않은 컬럼을 조작하려고 하는 경우
    2) 뷰에 정의되어있지 않은 컬럼 중에 베이스테이블 상에 NOT NULL제약조건이 지정되어있는 경우
    3) 산술연산직 또는 함수식으로 정의되어있는 경우
    4) 그룹함수나 GROUP BY절이 포함된 경우 
    5) DISTINCT 구문이 포함된 경우
    6) JOIN을 이용해서 여러 테이블을 연결시켜놓은 경우 
    
*/

-- 1) 뷰에 정의되어있지 않은 컬럼을 조작하려고 하는 경우
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE
     FROM JOB;

SELECT * FROM VW_JOB;
SELECT * FROM JOB;

-- INSERT (뷰에 JOB_NAME이 정의되지 않았기 때문에 오류)
INSERT INTO VW_JOB(JOB_CODE, JOB_NAME) VALUES('J8', '인턴');

-- UPDATE (오류 이유 상동)
UPDATE VW_JOB
   SET JOB_NAME = '인턴'
 WHERE JOB_CODE = 'J7';

-- DELETE (오류 이유 상동)
DELETE
  FROM VW_JOB
 WHERE JOB_NAME = '사원';

-- 2) 뷰에 정의되어있지 않은 컬럼 중에서 베이스테이블에 NOT NULL 제약조건이 지정된 경우 
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_NAME
     FROM JOB;
     
SELECT * FROM VW_JOB;
SELECT * FROM JOB;

-- INSERT 
-- 실제 베이스테이블에 INSERT해서 (NULL, '인턴') 추가하려 함
INSERT INTO VW_JOB VALUES('인턴'); --  JOB_CODE에 NOT NULL 제약조건 때문에 오류

-- UPDATE (뷰에 정의되어있는 것을 업뎃한 것이기 때문에 성공) 
UPDATE VW_JOB
   SET JOB_NAME = '알바'
 WHERE JOB_NAME = '사원';

ROLLBACK;

-- DELETE (이 데이터를 쓰고 있는 자식데이터 존재하기 때문에 삭제제한 / 단, 없다면 삭제 O)
DELETE 
  FROM VW_JOB
 WHERE JOB_NAME = '사원';

-- 3) 함수식 또는 산술연산식으로 정의된 경우 
CREATE OR REPLACE VIEW VW_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
     FROM EMPLOYEE;

SELECT * FROM VW_EMP_SAL;
SELECT * FROM EMPLOYEE;

-- INSERT (SALARY*12 산술연산식이 포함되어 에러)
INSERT INTO VW_EMP_SAL VALUES(400, '채성아', 3000000, 36000000);

-- UPDATE
-- 200번 사원의 연봉을 8000만원으로
UPDATE VW_EMP_SAL
   SET 연봉 = 80000000
 WHERE EMP_ID = 200;  -- 에러(연봉 SALARY*12 산술연산식 포함)

-- 200번 사원의 급여를 700만원으로
UPDATE VW_EMP_SAL
   SET SALARY = 7000000
 WHERE EMP_ID = 200;  -- 성공

ROLLBACK;

-- DELETE (성공)
-- 산술연산식이 포함되어 있는 부분을 건드린다고 무조건 에러 X
-- 베이스테이블에 반영되는데 문제 없다면 작업 수행
DELETE 
  FROM VW_EMP_SAL
 WHERE 연봉 = 72000000;

ROLLBACK;

-- 4) 그룹함수 또는 GROUP BY절을 포함하는 경우 
CREATE OR REPLACE VIEW VW_GROUPDEPT
AS SELECT DEPT_CODE, SUM(SALARY) "합계", FLOOR(AVG(SALARY)) "평균"
     FROM EMPLOYEE
 GROUP BY DEPT_CODE;

SELECT * FROM VW_GROUPDEPT;

-- INSERT (GROUP BY절 포함, 함수식까지 포함되어 에러)
INSERT INTO VW_GROUPDEPT VALUES('D3', 8000000, 4000000);

-- UPDATE (데이터들의 합계인데 데이터를 무시하게 되는 것이기 때문에 에러)
UPDATE VW_GROUPDEPT
   SET 합계 = 8000000
 WHERE DEPT_CODE = 'D1';
 
-- DELETE (그룹을 삭제할지 데이터를 삭제할지 난감한 상황 = 에러)
DELETE 
  FROM VW_GROUPDEPT
 WHERE 합계 = 5210000;

-- 5) DISTINCT가 포함된 경우
CREATE OR REPLACE VIEW VW_DT_JOB
AS SELECT DISTINCT JOB_CODE -- DISTINCT ; 중복된 것들을 한번만 
     FROM EMPLOYEE;

SELECT * FROM VW_DT_JOB; 

-- INSERT (에러)
INSERT INTO VW_DT_JOB VALUES('J8');

-- UPDATE (에러)
UPDATE VW_DT_JOB
   SET JOB_CODE = 'J8'
 WHERE JOB_CODE = 'J7';

-- DELETE (에러)
DELETE
  FROM VW_DT_JOB
 WHERE JOB_CODE = 'J4';
 
-- 6) JOIN을 이용해서 여러 테이블을 연결한 경우
CREATE OR REPLACE VIEW VW_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
     FROM EMPLOYEE
     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM VW_JOINEMP;

-- INSERT (EMPLOYEE, DEPARTMENT 두 테이블에 데이터 추가되어야 하는데 그렇게까진 못함)
INSERT INTO VW_JOINEMP VALUES(300, '나미리', '총무부');

-- UPDATE
UPDATE VW_JOINEMP
   SET EMP_NAME = '차은주'
 WHERE EMP_ID = '200'; -- 성공(데이터 업뎃)
 
UPDATE VW_JOINEMP
   SET DEPT_TITLE = '회계부'
 WHERE EMP_ID = 200;  -- 에러(JOIN을 통해 도출된 결과를 업뎃은 X)
 
-- DELETE
DELETE 
  FROM VW_JOINEMP
 WHERE EMP_ID = 200; -- 성공

SELECT * FROM EMPLOYEE;

ROLLBACK; 

------------------------------------------------------------------

/*
    * VIEW 옵션
    
    [상세표현식]
    CREATE [OR REPLACE] [FORCE|"NOFORCE"] VIEW 뷰명
    AS 서브쿼리
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    1) OR REPLACE : 기존에 동일한 뷰가 있을 경우 갱신, 존재하지 않으면 새로 생성
    2) FORCE | NOFORCE
       > FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰 생성
       > NOFORCE : 서브쿼리에 기술된 테이블이 존재하는 테이블이여야만 뷰 생성 (생략시 기본값)
    3) WITH CHECK OPTION : DML시 서브쿼리에 기술된 조건에 부합한 값으로만 DML 가능
    4) WITH READ ONLY : 뷰에 대해 조회만 가능 (DML문 수행불가)
       
*/

-- 2) FORCE | NOFORCE
--    NOFORCE : 서브쿼리에 기술된 테이블이 존재하는 테이블이여야만 뷰 생성 
CREATE OR REPLACE /*NOFORCE*/ VIEW VW_EMP -- 생략시 기본값
AS SELECT TCODE, TNAME, TCONTENT
     FROM TT; -- 이런 테이블 없기 때문에 오류

--    FORCE : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 우선은 생성
CREATE OR REPLACE FORCE VIEW VW_EMP
AS SELECT TCODE, TNAME, TCONTENT
     FROM TT; -- 컴파일 오류와 함께 뷰가 생성

SELECT * FROM VW_EMP; -- 뷰가 만들어지긴 했는데 테이블이 존재하지 않기 때문에 조회 불가

-- TT테이블을 생성해야만 그때부터 VIEW 활용 가능
CREATE TABLE TT(
    TCODE NUMBER,
    TNAME VARCHAR2(20),
    TCONTENT VARCHAR2(30)
);

-- 3) WITH CHECK OPTION : 서브쿼리에 기술된 조건에 부합하지 않는 값으로 수정 시 오류

-- WITH CHECK OPTION 적용 안 한 경우
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
     FROM EMPLOYEE
    WHERE SALARY >= 3000000;

SELECT * FROM VW_EMP; -- 8명 조회

-- 200번 사원의 급여를 200만원으로 변경 
-- (서브쿼리의 조건에 부합되지 않는 값으로 변경시도) => 업뎃 성공
UPDATE VW_EMP
   SET SALARY = 2000000
 WHERE EMP_ID = 200;

SELECT * FROM EMPLOYEE;

ROLLBACK;

-- WITH CHECK OPTION 적용 한 경우
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
     FROM EMPLOYEE
    WHERE SALARY >= 3000000
WITH CHECK OPTION;
    
SELECT * FROM VW_EMP; -- 8명 조회 

UPDATE VW_EMP
   SET SALARY = 2000000
 WHERE EMP_ID = 200; --> 서브쿼리에 기술한 조건에 부합되지 않기 때문에 변경 불가
 
UPDATE VW_EMP
   SET SALARY = 4000000
 WHERE EMP_ID = 200; --> 서브쿼리에 기술한 조건에 부합되기 때문에 변경 가능
 
SELECT * FROM EMPLOYEE; 

ROLLBACK; 

-- 4) WITH READ ONLY : 뷰에 대해 조회만 가능 (DML 수행불가)
CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, BONUS
     FROM EMPLOYEE
    WHERE BONUS IS NOT NULL
WITH READ ONLY;
    
SELECT * FROM VW_EMP;

DELETE 
  FROM VW_EMP
 WHERE EMP_ID = 200; -- 조회만 가능한 뷰라서 DML 수행 오류
    
