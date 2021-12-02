/*
    < SELECT >
    데이터 조회할 때 필요한 구문
    
    >> RESULT SET : SELECT문을 통해 조회된 결과물 (즉, 조회된 행들의 집합)
    
    [표현법]
    SELECT 조회하고자하는컬럼, 컬럼, .. 
    FROM 테이블명; 
    // (컬럼은 반드시 해당 테이블에 존재해야 함)
*/

-- EMPLOYEE 테이블에 모든 컬럼(*) 조회
SELECT
    * FROM employee;
    
-- EMPLOYEE 테이블에 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY 
FROM employee;

-- JOB 테이블에 모든 컬럼(*) 조회
SELECT
    * FROM JOB;
    

-- 1. JOB 테이블에 직급명 컬럼만 조회
SELECT JOB_NAME 
FROM JOB;

-- 2. DEPARTMENT 테이블의 모든 컬럼 조회
SELECT 
    * FROM DEPARTMENT;

-- 3. DEPARTMENT 테이블에 부서코드, 부서명만 조회
SELECT DEPT_ID, DEPT_TITLE
FROM department;


-------------------------------------------------------------

/*
    < 컬럼값을 통한 산술연산 >
    SELECT 절 컬럼명 작성부분에 산술연산 기술 가능 (이때 산술연산된 결과 조회)
*/

-- EMPLOYEE 테이블에서 사원명, 사원의 '연봉'(급여*12) 조회
SELECT EMP_NAME, SALARY * 12
FROM employee;

-- EMPLOYEE에 사원명, 급여, 보너스, 연봉, 보너스포함된연봉(급여+보너스*급여)*12) 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12, (SALARY + BONUS * SALARY) * 12
FROM employee;
-- // 산술연산 시, NULL값이 포함된 경우에 결과도 NULL값

-- EMPLOYEE에 사원명, 입사일, 근무일수(오늘날짜 - 입사일) 조회
-- DATE형식끼리도 연산 가능. *오늘 날짜 : SYSDATE
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM employee;
-- DATE - DATE : 결과값은 일 단위가 맞지만 시/분/초 시간정보까지도 포함

-- 현재 시스템 날짜 및 시간 조회
SELECT SYSDATE
FROM DUAL; -- 오라클에서 제공하는 가상테이블(더미테이블)
-- 딱히 테이블명으로 제시할 것이 없을 경우 더미테이블 사용
-- 년/월/일 출력되지만 시/분/초까지 내재


-------------------------------------------------------------

/*
    < 컬럼명에 별칭 지정하기 >
    컬럼명에 별칭을 부여해 결과를 깔끔하게 보는데 도움

    [표현법]
    컬럼명 별칭 / 컬럼명 AS 별칭 / 컬럼명 "별칭" / 컬럼명 AS "별칭"
    // 별칭에 띄어쓰기 OR 특수문자가 포함될 경우 반드시 더블쿼테이션("")로 기술
*/

SELECT EMP_NAME 사원명, SALARY AS 급여, SALARY*12 "연봉(원)", (SALARY+BONUS*SALARY)*12 AS "총 소득"
FROM employee;


-------------------------------------------------------------

/*
    < 리터럴 >
    임의로 지정한 문자열
    
    SELECT절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터처럼 조회 가능
    조회된 RESULT SET의 모든 행에 반복적으로 출력
*/

-- EMPLOYEE에 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위
FROM employee;



/*
    < 연결 연산자 : || >
    여러 컬럼값들을 하나의 컬럼인 것처럼 연결하거나, 컬럼값과 리터럴을 연결
    System.out.println("num" + num); 비슷한 맥락
*/

-- 사번, 이름, 급여를 하나의 칼럼으로 조회
SELECT EMP_ID || EMP_NAME || SALARY
FROM employee;

-- 컬럼값과 리터럴 연결
-- XXX님의 월급은 XXX원 입니다.
SELECT EMP_NAME || '님의 월급은 ' || SALARY || '원 입니다.' "급여 정보"
FROM employee;


-------------------------------------------------------------

/*
    < DISTINCT >
    컬럼에 중복된 값들을 한 번씩만 표시하고자 할 때
*/

-- EMPLOYEE 직급코드 조회
SELECT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE 직급코드(중복제거) 조회
SELECT DISTINCT JOB_CODE
FROM employee;

-- EMPLOYEE 부서코드 (중복제거) 조회
SELECT DISTINCT DEPT_CODE
FROM employee;

-- 유의사항 : DISTINCT는 SELECT절에 딱 한번 기술 가능
/*
SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE
FROM EMPLOYEE;
*/


SELECT DISTINCT JOB_CODE, DEPT_CODE
FROM employee;
-- JOB_CODE, DEPT_CODE를 묶어서 중복 판별


/*
    <WHERE>절
    조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만을 조회하고할 때 사용
    조건식에서는 다양한 연사자 사용가능
    
    [표현법]
    SELECT 조회하고자하는컬럼, 컬럼, 산술연산,...
    FROM 테이블명
    WHERE 조건식;
    
    >> 비교 연산자 <<
    >, <, >=, <=       --> 대소비교(자바와 동등)
    =                  --> 동등비교(자바에선 ==)
    !=, ^=, <>         --> 다른지 비교 
*/

-- EMPLOYEE에서 부서코드가 'D9'인 해당 사원 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE에서 부서코드가 'D1'인 사원들의 사원명, 급여, 부서코드만 조회
SELECT EMP_NAME, SALARY /*, DEPT_CODE*/
FROM employee
WHERE DEPT_CODE = 'D1';

-- 부서코드가 'D1'이 아닌 사원들의 사번, 사원명, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM employee
WHERE DEPT_CODE != 'D1';

-- 급여가 400만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- EMPLOYEE에서 재직중 (ENT_YN 컬럼값이 'N'인) 사원들의 사번, 이름, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM employee
WHERE ENT_YN = 'N';

SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY*12 "연봉"
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT EMP_NAME, SALARY, SALARY*12 "연봉", DEPT_CODE
FROM EMPLOYEE
WHERE SALARY*12 >= 50000000;
-- WHERE 연봉 >= 50000000; // WHERE절에서는 SELECT절에 작성된 별칭 사용불가
-- 실행 순서 : FROM절 -> WHERE절 -> SELECT절

SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
FROM employee
WHERE JOB_CODE != 'J3';

/*
    < 논리 연산자 >
    여러 개의 조건을 엮어서 제시하고자 할 때
    
    AND ~이면서, 그리고
    OR ~이거나, 또는
*/

-- 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE <= 'D9' AND SALARY >= 5000000;

-- 부서코드가 'D6'이거나 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >= 30000000;

-- 급여 350만원 이상 600만원 이하
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

/*
    < BETENNE AND >
    조건식에서 사용되는 구문
    몇 이상 몇 이하인 범위에 대한 조건을 제시할 때 사용
    
    [표현법]
    비교대상컬럼 BETWEEN 하한값 AND 상한값
    // 하한값 이상이고 상한값 이하
*/

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 급여 350만원 이상 600만원 이하 그 외의 사원
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE SALARY < 3500000 OR SALARY > 6000000;
WHERE NOT SALARY /*NOT(이 자리에도 가능)*/ BETWEEN 3500000 AND 6000000;
-- !(자바;논리부정연산자) NOT(오라클;논리부정연산자)

-- 입사일이 '90/01/01' ~ '01/01/01'
SELECT *
FROM employee
-- WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/01/01'; -- DATE형식 대소비교 가능
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';


-------------------------------------------------------------

/*
    < LIKE >
    비교하고자하는 컬럼값이 제시한 특정 패턴에 만족될 경우 조회
    
    [표현법]
    비교대상컬럼 LIKE '특정패턴'
    
    - 특정패턴 제시시 '%', '_'를 와일드카드로 사용가능
    >> '%' : 0글자 이상
    EX) 비교대상컬럼 LIKE '문자%'   => 비교대상의 컬럼값이 '문자로 시작'되는 것 조회
        비교대상칼럼 LIKE '%문자'   => 비교대상의 컬럼값이 '문자로 끝'나는 것 조회
        비교대상컬럼 LIKE '%문자%'  => 비교대상의 컬럼값에 '문자가 포함'된 것 조회 (키워드 검색)
        
    >> '_' : 1글자 이상
    EX) 비교대상컬럼 LIKE '_문자'   => 비교대상의 컬럼값에 '문자앞 한글자가 오는'것 조회
        비교대상칼럼 LIKE '__문자'   => 비교대상의 컬럼값에 '문자앞 두글자가 오는'것 조회
        비교대상컬럼 LIKE '_문자_'  => 비교대상의 컬럼값에 '문자앞과 뒤에 한글자씩 오는'것 조회
*/

-- 성이 '전'씨인 사원 조회
SELECT *
FROM employee
WHERE EMP_NAME LIKE '전%';

-- 이름 중에 '하'가 포함된 사원 조회
SELECT *
FROM employee
WHERE EMP_NAME LIKE '%하%';

-- 이름의 '가운데 글자가 하'인 사원 조회
SELECT *
FROM employee
WHERE EMP_NAME LIKE '_하_';

-- 전화번호 '세번째 자리가 1'인 사원 조회
SELECT *
FROM employee
WHERE PHONE LIKE '__1%';

-- 이메일 중 '_기준 앞글자가 3글자'인 사원 조회
SELECT *
FROM employee
WHERE EMAIL LIKE '____%';
-- 와일드카드와 데이터값을 구분되지 않아 원하는 결과 도출X
-- 데이터값으로 취급하고자 하는 값 앞에 ESCAPE OPTION으로 와일드카드로 등록
SELECT *
FROM employee
WHERE EMAIL LIKE '___$_%' ESCAPE '$';
-- 그 외의 사원들 조회 WHERE EMAIL NOT LIKE '___$_%' ESCAPE '$';


-------------------------------------------------------------

/*
    < IS NULL / IS NOT NULL >
    컬럼값에 NULL이 있을 경우 NULL값 비교에 사용되는 연산자
*/
-- 보너스가 없는 사원 조회
SELECT *
FROM employee
WHERE BONUS IS NULL;


-------------------------------------------------------------

/*
    < IN >
    비교대상컬럼값이 제시한 목록 중에 일치하는 값이 있는지 
    
    [표현법]
    비교대상컬럼 IN ('값1', '값2', '값3', ..)
*/

-- 부서코드가 D6이거나 D8이거나 D5인 부서원 조회
SELECT *
FROM employee
WHERE dept_code IN ('D6', 'D8', 'D5'); 
-- // 그 외의 사원 NOT IN


--===========================================================

/*
    < 연산자 우선순위 >
    0. ()
    1. 산술연산자
    2. 연결연산자
    3. 비교연산자
    4. IS NULL / LIKE '특정패턴' / IN
    5. BETWEEN AND
    6. NOT(논리연산자)
    7. AND(논리연산자)
    8. OR(논리연산자)
*/

-- ** OR보다 AND가 먼저 연산
-- 직급코드 'J2'와 'J7' 사원 중 급여가 200만원 이상 사원 조회
SELECT * 
FROM employee
WHERE (JOB_CODE = 'J2' OR JOB_CODE = 'J7') AND SALARY >= 2000000;


-------------------------------------------------------------

-- 내부적 실행 순서
SELECT EMP_ID, EMP_NAME, SALARY -- 3
FROM EMPLOYEE -- 1
WHERE DEPT_CODE IS NULL; -- 2


--===========================================================

/*
    < ORDER BY 절 >
    SELECT문 가장 마지막 줄에 작성 (실행도 마지막에)
    
    [표현법]
    SELECT 조회할컬럼, 컬럼, 산술연산식 AS "별칭", ...
    FROM 조회하고자하는테이블명
    WHERE 조건식
    ORDER BY 정렬기준의컬럼명|별칭|컬럼순번 [ASC/DESC] [NULLS FIRST|NULLS LAST]
    
    - ASC : 오름차순 정렬 (생략 시 기본 값)
    - DESC : 내림차순 정렬
    
    - NULLS FIRST : 정렬하고자 하는 컬럼값에 NULL이 있을 경우 해당 데이터를 맨 앞 배치
    - NULLS LAST : 정렬하고자 하는 컬럼값에 NULL이 있을 경우 해당 데이터를 맨 뒤 배치 
                  (생략 시 ASC일때의 기본값)
*/


SELECT *
FROM employee
-- ORDER BY BONUS; -- // 오름차순정렬 , NULLS LAST
-- ORDER BY BONUS ASC; -- // 오름차순 정렬일 때 NULLS LAST가 기본값
-- ORDER BY BONUS ASC NULLS FIRST; -- // NULLS FIRST, 오름차순 정렬
-- ORDER BY BONUS DESC; -- // 내림차순 정렬일 때 NULLS FIRST가 기본값
ORDER BY BONUS DESC, SALART ASC; -- 보너스가 일치할 때 급여 오름차순으로 순서 변경 O
-- 정렬 기준을 여러개 제시 가능 ( 첫번째 기준의 컬럼값이 동일할 경우 두번째 기준의 컬럼으로 정렬)



-- 전 사원의 사원명, 연봉조회 (이 때 연봉별 내림차순 정렬 조회)
SELECT EMP_NAME, SALARY *12 "연봉"
FROM employee
--ORDER BY SALARY*12 DESC;
--ORDER BY 연봉 DESC;  -- 별칭 사용 가능
ORDER BY 2 DESC;    -- 컬럼 순번 사용 가능


