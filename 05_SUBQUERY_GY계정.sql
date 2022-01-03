/*
    * 서브쿼리 (SUBQUERY)
    - 하나의 SQL문 안에 또 다른 SELECT문 
    - 메인 SQL문의 보조 역할을 하는 쿼리문 
*/

-- 간단 서브쿼리 예시 1. 
-- 신짱구 사원과 같은 부서에 속한 사원들 조회

-- 1) 먼저 신짱구 사원의 부서코드 조회 
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '신짱구'; --> D9

-- 2) 부서코드가 D9인 사원들 조회 
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--> 위의 2단계를 하나의 쿼리문으로
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '신짱구');
                   
-- 간단 서브쿼리 예시2
-- 전 직원의 평균 급여보다 많은 급여를 받는 사원들의 사번, 이름, 직급코드, 급여 조회 

-- 1) 전 직원의 평균 급여 조회
SELECT AVG(SALARY)
FROM EMPLOYEE; --> 약 3050000원

-- 2) 급여가 3050000원 이상인 사원들의 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3050000;

-- 위의 2단계를 하나의 쿼리문으로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                 FROM EMPLOYEE);

----------------------------------------------------------------------

/*
    * 서브쿼리의 구분
      서브쿼리를 수행한 결과값이 n행 n열인지에 따라 분류
      
      - 단일행 서브쿼리 : 서브쿼리의 조회 결과값의 갯수가 1개일 때 (1행 1열)
      - 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러행일 때 (여러행 1열)
      - 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 한 행이지만 컬럼이 여러개일 때 (1행 여러열)
      - 다중행 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러행 여러컬럼일 때 (여러행 여러열)
      
      >> 서브쿼리의 종류에 따라서 연산자 사용이 달라짐 
*/


/*
    1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)
    서브쿼리의 조회 결과값의 갯수가 1개일 때 (1행 1열)
    일반 비교연산자 사용가능
    = != ^= > < >=, ... 
*/

-- 1) 전 직원의 평균급여보다 적게 받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY SALARY;

-- 2) 최저 급여를 받는 사원의 사번, 이름, 급여, 입사일 조회 
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);

-- 3) 신짱구 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '신짱구');

-- >> 오라클 전용 구문             
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '신짱구')
  AND DEPT_CODE = DEPT_ID;
  
-- >> ANSI구문
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '신짱구');

-- 4) 부서별 급여 합이 가장 큰 부서의 부서코드, 급여 합 조회
-- 4_1) 먼저 제일 큰 부서별 급여 합 조회
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 17700000원

-- 4_2) 부서별 급여 합이 17700000원인 부서 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- 위의 두 단계를 하나의 쿼리문으로
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);

-- 한유리사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명
-- 단, 한유리는 제외 
-- >> 오라클 전용
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
  AND DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '한유리')
  AND EMP_NAME != '한유리';

-- >> ANSI구문
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '한유리')
  AND EMP_NAME != '한유리';

----------------------------------------------------------------------

/*
    2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
    서브쿼리를 수행한 결과값이 여러 행일 때 (컬럼은 하나)
    
    - IN 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면 
    
    - > ANY 서브쿼리 : 여러개의 결과값 중에서 '한 개라도' 클 경우 (여러개의 결과값 중에서 가장 작은값 보다 클 경우)
    - < ANY 서브쿼리 : 여러개의 결과값 중에서 '한 개라도' 작을 경우 (여러개의 결과값 중에서 가장 큰 값 보다 작을 경우)
    
        비교대상 > ANY (값1, 값2, 값3)
        비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
    
    - > ALL 서브쿼리 : 여러개의 '모든' 결과값들 보다 클 경우 
    - < ALL 서브쿼리 : 여러개의 '모든' 결과값들 보다 작을 경우 
    
        비교대상 > ALL (값1, 값2, 값3)
        비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
    
*/

-- 1) 김철수 또는 이훈이 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 
-- 1_1) 김철수 또는 이훈이 사원이 어떤 직급인지 조회
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('김철수', '이훈이');  -- J3, J7

-- 1_2) J3, J7 직급인 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- 위의 두 단계를 하나의 쿼리로
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('김철수', '이훈이'));

-- 사원 => 대리 => 과장 => 차장 => 부장 ...
-- 2) 대리 직급인데 과장 직급 최소 급여보다 많이 받는 직원 조회 (사번, 이름, 직급, 급여)
-- 2_1) 먼저 과장 직급인 사원들의 급여 조회 
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'; -- 2200000, 2500000, 3760000

-- 2_2) 직급이 대리이면서 급여값이 위의 목록들 값 중에 하나라도 큰 사원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' 
  AND SALARY > ANY (2200000, 2500000, 3760000);

-- 위의 두 단계를 하나의 쿼리문으로
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' 
  AND SALARY > ANY (SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '과장');

--> 단일행 서브쿼리로도 가능! 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리' 
  AND SALARY > (SELECT MIN(SALARY)
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '과장');
                
-- 3) 과장 직급인데 차장직급인 사원들의 모든 급여보다도 더 많이 받는 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
  AND SALARY > ALL (SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '차장');

----------------------------------------------------------------------

/*
    3. 다중열 서브쿼리 
    결과값은 한행이지만 나열된 컬럼수가 여러개일 경우 
*/
-- 1) 하이유 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들 조회
-- >> 단일행 서브쿼리로도 가능
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '한수지') -- D5
  AND JOB_CODE = (SELECT JOB_CODE
                  FROM EMPLOYEE
                  WHERE EMP_NAME = '한수지'); -- J5 

-- >> 다중열 서브쿼리로
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME = '한수지');

-- 신짱아 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수사번 조회 
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '신짱아');

----------------------------------------------------------------------

/*
    4. 다중행 다중열 서브쿼리
    서브쿼리 조회 결과값이 여러행 여러열일 경우 
*/
-- 1) 각 직급별 최소급여를 받는 사원 조회
-->> 각 직급별 최소급여 조회
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' AND SALARY = 3700000
   OR JOB_CODE = 'J7' AND SALARY = 1380000
   OR JOB_CODE = 'J3' AND SALARY = 3400000
   ....;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J2', 3700000)
   OR (JOB_CODE, SALARY) = ('J7', 1380000)
   OR (JOB_CODE, SALARY) = ('J3', 3400000)
   ... ;

-- 서브쿼리로 적용 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE);

-- 2) 각 부서별 최고급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                              FROM EMPLOYEE
                              GROUP BY DEPT_CODE);

----------------------------------------------------------------------

/*
    5. 인라인 뷰 (INLINE-VIEW)
    FROM 절에 서브쿼리를 작성한 거 
    
    서브쿼리를 수행한 결과를 테이블처럼 사용
*/

-- 사원들의 사번, 이름, 보너스포함연봉, 부서코드 조회    => 보너스포함연봉 NULL X
-- 단, 보너스포함연봉이 3000만원이상인 사원들만 조회 
SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 "연봉", DEPT_CODE
FROM EMPLOYEE
WHERE (SALARY + SALARY * NVL(BONUS, 0)) * 12 >= 30000000; --WHERE절에 별칭 사용 X


SELECT *
FROM (SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 "연봉", DEPT_CODE
      FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

SELECT EMP_NAME, DEPT_CODE, 연봉
FROM (SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 "연봉", DEPT_CODE
      FROM EMPLOYEE)
WHERE 연봉 >= 30000000;

-- >> 인라인 뷰를 주로 사용하는 예 => TOP-N분석

-- 전 직원 중 급여가 가장 높은 상위 5명만 조회 
-- * ROWNUM : 오라클에서 제공해주는 컬럼 , 조회된 순서대로 1부터 순번을 부여해주는 컬럼 
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
-- 실행순서 FROM --> SELECT ROWNUM (이때 순번 부여 == 정렬도 하기 전에 이미 순번 부여)

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;
-- 정상적인 조회X

-- => ORDER BY절이 다 수행된 결과에 ROWNUM부여 후 5명 조회 
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
      FROM EMPLOYEE
      ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;

-- 가장 최근에 입사한 사원 5명 조회  (사원명, 급여, 입사일)
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT *
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

-- 각 부서별 평균급여가 높은 3개의 부서 조회 
SELECT DEPT_CODE, FLOOR(평균급여)
FROM (SELECT DEPT_CODE, AVG(SALARY) "평균급여"
      FROM EMPLOYEE
      GROUP BY DEPT_CODE
      ORDER BY 2 DESC)
WHERE ROWNUM <= 3;

----------------------------------------------------------------------

/*
    * 순위 계산 함수 (WINDOW FUNCTION)
    RANK() OVER(정렬기준)   |   DENSE_RANK() OVER(정렬기준)
    
    - RANK() OVER(정렬기준) : 공동 순위 이후의 등수를 공동 순위만큼 건너뛰고 순위 부여
                             EX) 공동 1위가 2명이면 그 다음 순위는 3위
    - DENSE_RANK() OVER(정렬기준) : 공동 순위 있어도 뛰어넘지않고 순위 부여
                                   EX) 공동 1위가 2명이더라도 그 다음 순위는 2위 
    
    >> SELECT절에서만 사용 가능
*/

-- 급여가 높은 순대로 순위 부여
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;
--> 공동 19위 2명 그 뒤의 순위는 21위 

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE;
--> 공동 19위 2명 그 뒤의 순위가 20위 

--> 상위 5명만 조회 
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
FROM EMPLOYEE
--WHERE 순위 <= 5;
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5; -- 오류남! (WHERE절에 사용 못함)

-->> 인라인뷰를 쓸수 밖에 없음!!
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
        FROM EMPLOYEE)
WHERE 순위 <= 5;