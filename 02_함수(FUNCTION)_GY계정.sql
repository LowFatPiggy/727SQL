/*
    < 함수 FUNCTION >
    전달된 컬럼값을 읽어들여서 함수를 실행한 결과 반환
    
    - 단일행 함수 : N개의 값을 읽어들여서 N개의 결과값을 리턴 (매 행마다 함수 실행 결과 반환)
    - 그룹 함수 : N개의 값을 읽어들여서 1개의 결과값을 리턴 (그룹을 지어 그룹별로 함수 실행 결과 반환)
    
    >> SELECT 절에 단일행 함수랑 그룹함수를 함께 사용 X
       왜? 결과 행의 갯수가 다르기 때문
       
    >> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, GROUP절, HAVING절
*/



--========================== < 단일행 함수 > ==========================
/*
    < 문자 처리 함수 >
    
    * LENGTH / LENGTHB      => 결과값 NUMBER타입
    
    LENGTH(컬럼|'문자열값') : 해당 문자열값의 글자수 반환
    LENGTHB(컬럼|'문자열값') : 해당 문자열값의 바이트수 반환
    
    '김' '가' 'ㄱ'       한 글자당 3BYTE
    영문자, 숫자, 특수문자 한 글자당 1BYTE
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL; -- 가상테이블

SELECT LENGTH('ORACLE'), LENGTHB('ORACLE')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), 
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM employee;



/*
    * INSTR
    문자열로부터 특정 문자의 시작위치를 찾아서 반환
    
    INSTR(컬럼|'문자열값', '찾고자하는문자', [찾을위치의시작값, [순번]]) => 결과값 NUMBER타입
    
    찾을 위치의 시작값
    1 : 앞에서부터 
    -1 : 뒤에서부터
*/

SELECT INSTR('AABAACAABBAA', 'B') -- 찾을위치의시작 기본값 1, 순번 기본값 1
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1)
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', -1) -- 순번 기본값 1
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1, 2)
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', -1, 3)
FROM DUAL;


SELECT EMAIL, INSTR(EMAIL, '_', 1, 1) "_위치", INSTR(EMAIL, '@') "@위치"
FROM employee;


----------------------------------------------------------------------

/*
    * SUBSTR
    문자열에서 특정 문자열을 추출해서 반환 (자바에서 substring()메소드와 유사)
    
    SUBSTR(STRING, POSITION, LENGTH)    => 결과값 CHARACTER타입
    - STRING : 문자타입컬럼 OR '문자열값'
    - POSITION : 문자열을 추출할 시작위치값
    - LENGTH : 추출할 문자 갯수 (생략 시 끝까지 의미)
*/

SELECT SUBSTR('KAHLUAMILK', 4) FROM DUAL;
SELECT SUBSTR('KAHLUAMILK', 5, 2) FROM DUAL;
SELECT SUBSTR('KAHLUAMILK', 1, 6) FROM DUAL;
SELECT SUBSTR('KAHLUAMILK', -8, 3) FROM DUAL;

SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) "성별"
FROM employee;

-- 여성사원들만 조회
SELECT EMP_NAME
FROM employee
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

SELECT EMP_NAME
FROM employee
WHERE SUBSTR(EMP_NO, 8, 1) IN (2, 4) -- 문자열을 의미하는 ''를 빼도 상관X = 자동형변환
ORDER BY 1;


-- 함수 중첩 사용
-- 이메일의 도메인을 뺀 아이디만 추출
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) "아이디"
FROM employee;



----------------------------------------------------------------------

/*
    * LPAD / RPAD
    문자열을 조회할 때 통일감있게 조회하고자 할 때 사용
    
    LPAD / RPAD(STRING, 최종적으로반환할문자의길이, [덧붙이고자하는문자])   
    => 결과값은 CHARACTER타입
    
    문자열에 덧붙이고자하는 문자를 왼,오른쪽에 덧붙여서 최종 N길이만큼 문자열 반환
*/

SELECT EMP_NAME, LPAD(EMAIL, 20) -- 덧붙이고자 하는 문자 생략 시 공백이 기본값
FROM employee;
-- 20만큼의 자리가 생성되고 데이터 나머지 부분 왼쪽자리가 공백으로 채워짐

SELECT EMP_NAME, LPAD(EMAIL, 20, '#') 
FROM employee;

-- 주민번호 성별 뒷자리 *로 가리기
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;

SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******'
FROM employee;

----------------------------------------------------------------------


/*
    * LTRIM / RTRIM
    문자열에서 특정 문자를 제거한 나머지를 반환
    
    LTRIM/RTRIM(STRING, [제거하고자하는문자들])   => 결과값 CHARACTER타입
*/

SELECT LTRIM('   BIS COTTI   ') FROM DUAL; -- 오른쪽 공백은 제거X
SELECT LTRIM('123123BISCOTTI123', '123') FROM DUAL;
-- 해당 문자열이 아닌 문자열을 만나게 되면 작업을 끝내고 반환
SELECT RTRIM('4561BISCOTTI4848', '0123456789') FROM DUAL;

/*
    * TRIM
    문자열의 앞/뒤/양쪽에 있는 지정한 문자들을 제거한 나머지 문자열 반환
    
    TRIM([LEADING|TRAILING|BOTH] 제거하고자하는문자들 FROM] STRING)
*/

-- 기본값 : 양쪽에 있는 문자들 제거
SELECT TRIM('   BIS COTTI  ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL; -- LTRIM
SELECT TRIM(TRAILING 'Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL; -- RTRIM
SELECT TRIM(BOTH 'Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL; -- BOTH 생략가능
SELECT TRIM('Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL;

/*
    * LOWER / UPPER /INITCAP
    
    LOWER/UPPER/INITCAP(STRING)     => 결과값 CHARACTER타입
    
    LOWER : 소문자로 변경한 문자열 반환 (자바에서의 toLowerCase()메소드 유사)
    UPPER : 대문자로 변경한 문자열 반환 (자바에서의 toUpperCase()메소드 유사)
    INITCAP : 단어 앞글자마다 대문자로 변경한 문자열 반환
*/

SELECT LOWER('Butterbar Please') FROM DUAL;
SELECT UPPER('Butterbar Please') FROM DUAL;
SELECT INITCAP('butterbar please') FROM DUAL;


----------------------------------------------------------------------

/*
    * CONCAT
    문자열 두 개 전달받아 하나로 합친 후 결과 반환
    
    CONCAT(STRING, STRING)      => 결과값 CHARACTER타입
*/

SELECT CONCAT('Earl Grey ', 'Choco Cake') FROM DUAL; -- 세개 이상은 X
SELECT 'Earl Grey ' || 'Choco Cake' FROM DUAL;


----------------------------------------------------------------------

/*
    * REPLACE
    특정 문자(열)을 지정한 문자(열)로 변경 후 반환
    
    REPLACE(STRING, STR1, STR2)     => 결과값 CHARACTER타입
*/

SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'kh.or.kr', 'gmail.com')
FROM EMPLOYEE;


--====================================================================

/*
    < 숫자 처리 함수 >
    
    * ABS
    숫자의 절대값을 구해주는 함수
    
    ABS(NUMBER)     => 결과값 NUMBER타입
*/

SELECT ABS(-10) FROM DUAL;
SELECT ABS(-5.3) FROM DUAL;


----------------------------------------------------------------------

/*
    * MOD
    두 수를 나눈 나머지값을 반환
    
    MOD(NUMBER, NUMBER)     => 결과값 NUMBER
*/

SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.5, 3) FROM DUAL; -- 실수값도 가능


----------------------------------------------------------------------

/*
    * ROUND
    반올림한 결과를 반환
    
    ROUND(NUMBER, [위치])     => 결과값 NUMBER타입
         123.456
       -2-10.123 = 위치
*/

SELECT ROUND(123.456) FROM DUAL; -- 위치 생략시 기본값 0
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;


----------------------------------------------------------------------

/*
    * CEIL
    올림처리
    
    CEIL(NUMBER)
    위치 지정 불가, 결과값 정수로만 반환
*/
SELECT CEIL(365.247) FROM DUAL;


----------------------------------------------------------------------

/*
    * FLOOR
    소수점 아래 모두 버림처리
    
    FLOOR(NUMBER)
    위치 지정 불가, 결과값 정수로만 반환
*/
SELECT FLOOR(365.947) FROM DUAL;


----------------------------------------------------------------------

/*
    * TRUNC
    위치 지정 가능한 버림처리
    
    TRUNC(NUMBER, [위치])
*/
SELECT TRUNC(365.247) FROM DUAL; -- 기본값 소수점버림
SELECT TRUNC(365.247, 1) FROM DUAL;
SELECT TRUNC(365.247, -1) FROM DUAL;


--====================================================================

/*
    < 날짜 처리 함수 >
*/

-- * SYSDATE : 시스템 날짜 및 시간 반환 (현재 날짜 및 시간)
SELECT SYSDATE FROM DUAL;


-- * MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월 수
-- >> 내부적으로 (DATE1 - DATE2)/30OR31 시간도 포함 => 결과값은 NUMBER타입
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE-HIRE_DATE)||'일' "근무일수", 
       FLOOR(MONTHS_BETWEEN(SYSDATE,HIRE_DATE))||'개월' "근무개월수"
FROM EMPLOYEE;


-- * ADD_MONTHS(DATE, NUMBER) : 특정 날짜에 해당 숫자만큼의 개월수를 더한 날짜 리턴
--   => 결과값 DATE타입
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;


-- * NEXT_DAY(DATE, 요일(문자|숫자)) : 특정날짜 이후에 가까운 해당 요일의 날짜 반환
--   => 결과값 DATE타입
SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), '금') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), '6') FROM DUAL;
-- 1: 일요일 2: 월요일, .. 6: 금요일, 7: 토요일

SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), 'FRIDAY') FROM DUAL; -- 에러(KOREAN)
-- 언어변경(KOP->ENG)
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), 'FRIDAY') FROM DUAL; -- 성공
-- 언어변경(ENG->KOR)
ALTER SESSION SET NLS_LANGUAGE = KOREAN;


-- * LAST_DAY(DATE) : 해당 월의 마지막 날짜 반환
--   => 결과값 DATE타입
SELECT LAST_DAY(SYSDATE) FROM DUAL;


----------------------------------------------------------------------

/*
    * EXTRACT : 날짜 추출       => 결과값 NUMBER타입
    
    EXTRACT(YEAR FROM DATE) : 년도 추출
    EXTRACT(MONTH FROM DATE) : 월 추출
    EXTRACT(DAY FROM DATE) : 일 추출
*/
SELECT EMP_NAME,
       EXTRACT(YEAR FROM HIRE_DATE) "입사년도",
       EXTRACT(MONTH FROM HIRE_DATE) "입사월",
       EXTRACT(DAY FROM HIRE_DATE) "일사일"
FROM employee
ORDER BY 입사년도 ASC;


--====================================================================

/*
    < 형변환 함수 >
    
    * TO_CHAR : 숫자 타입 OR 날짜 타입의 값을 문자타입으로 변환
    
    TO_CHAR(숫자|날짜, [포맷])        => 결과값 CHARACTER타입
*/

-- *숫자타입 => 문자타입
SELECT TO_CHAR(1234) FROM DUAL; -- '1234'

SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 5칸 공간확보, 오른쪽정렬, 빈칸공백
-- 9(빈칸공백) OR 0(빈칸0)
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- 빈칸 0
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- 현재 설정된 나라(LOCAL) 화폐단위
SELECT TO_CHAR(1234, '$99999') FROM DUAL;

SELECT TO_CHAR(123456, 'L999,999') FROM DUAL;

-- *날짜타입 => 문자타입
SELECT SYSDATE FROM DUAL; -- DATE타입
SELECT TO_CHAR(SYSDATE) FROM DUAL; -- CHAR타입
SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL; -- PM/AM 24시간형식
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL;

-- 년도 포맷
SELECT TO_CHAR(SYSDATE, 'YYYY'),
       TO_CHAR(SYSDATE, 'YY'),
       TO_CHAR(SYSDATE, 'RRRR'),
       TO_CHAR(SYSDATE, 'RR'),
       TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

-- 월 포맷
SELECT TO_CHAR(SYSDATE, 'MM'),
       TO_CHAR(SYSDATE, 'MON'),
       TO_CHAR(SYSDATE, 'MONTH'),
       TO_CHAR(SYSDATE, 'RM') -- 로마기호
FROM DUAL;

-- 일 포맷
SELECT TO_CHAR(SYSDATE, 'DDD'), -- 년 기준 며칠째
       TO_CHAR(SYSDATE, 'DD'), -- 월 기준 며칠째
       TO_CHAR(SYSDATE, 'D') -- 주 기준 며칠째
FROM DUAL;

-- 요일 포맷
SELECT TO_CHAR(SYSDATE, 'DAY'),
       TO_CHAR(SYSDATE, 'DY')
FROM DUAL;


----------------------------------------------------------------------

/*
    * TO DATE : 숫자타입 OR 문자타입 데이터를 날짜타입으로 반환
    
    TO DATE(숫자|문자, [포맷])        => 결과값 DATE타입
*/

SELECT TO_DATE(20210916) FROM DUAL; -- DATE타입
SELECT TO_DATE(210916) FROM DUAL;

SELECT TO_DATE(070101) FROM DUAL; -- 에러
SELECT TO_DATE('070101') FROM DUAL;

SELECT TO_DATE('050505 143624', 'YYMMDD HH24MISS') FROM DUAL;

SELECT TO_DATE('210916', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('951124', 'YYMMDD') FROM DUAL; -- 2095년 // YY : 현재 세기로 반영

SELECT TO_DATE('210916', 'RRMMDD') FROM DUAL; -- 2021년
SELECT TO_DATE('951124', 'RRMMDD') FROM DUAL; -- 1995년 
-- // RR : 년도가 50미만일 경우 현재세기 반영, 50이상일 경우 이전세기 반영


----------------------------------------------------------------------

/*
    * TO_NUMBER : 문자타입의 데이터를 숫자타입으로 변환
    
    TO_NUMBER(문자, [포맷])     => 결과값 NUMBER타입
*/
SELECT TO_NUMBER('0123456789') FROM DUAL;

SELECT '1000000' + '550000' FROM DUAL; -- 오라클에선 자동형변환 O

SELECT '1,000,000' + '550,000' FROM DUAL; -- 에러

SELECT TO_NUMBER('1,000,000', '9,999,999') + TO_NUMBER('550,000', '999,999') FROM DUAL;


--====================================================================

/*
    < NULL 처리 함수 >
*/

-- * NVL(컬럼, 해당컬럼값이 NULL일 경우 반환할 값)
SELECT EMP_NAME, NVL(BONUS,0) -- 보너스가 NULL값인 경우 0으로 출력해
FROM EMPLOYEE;

-- NULL값이 포함된 산술연산 결과값도 NULL값
SELECT EMP_NAME, (SALARY + SALARY * BONUS) *12
FROM EMPLOYEE;
-- 해결
SELECT EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) *12
FROM EMPLOYEE;

SELECT EMP_NAME, NVL(DEPT_CODE, '부서 없음')
FROM employee;


-- * NVL2(컬럼, 반환값1, 반환값2)
--   컬럼값이 존재할 경우 반환값1 반환, 존재X 반환값2 반환
SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.7, 0.1)
FROM employee;

SELECT EMP_NAME, NVL2(DEPT_CODE, '부서 있음', '부서 없음')
FROM employee;

-- * NULLIF(비교대상1, 비교대상2)
--   두 개의 값이 일치하면 NULL반환, 일치하지 X 비교대상1값 반환
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL;


--====================================================================

/*
    < 선택 함수 >

    * DECODE
    비교하고자 하는 컬럼(값)이 조건식과 같으면 결과값 반환
    (비교하고자하는대상(컬럼|산술연산|함수식), 비교값1, 결과값1, 비교값2, 결과값2, ..., 결과값N)
    
    SWITCH(비교대상) {
    CASE 비교값 1:
    CASE 비교값 2:
    ...
    DEFAULT :
    }
*/
-- 사번, 사원명, 주민번호, 성별
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')"성별"
FROM employee;

-- 부서별로 인상해서 조회 (J7부서 10%, J6 15%, J5 20%, 그 외 5%)
SELECT EMP_NAME, JOB_CODE, SALARY,
       DECODE(JOB_CODE, 'J7', SALARY * 1.1, 
                        'J6', SALARY * 1.15,
                        'J5', SALARY * 1.2, 
                              SALARY * 1.05)
FROM employee;


----------------------------------------------------------------------

/*
    * CASE WHEN THEN
    
    CASE WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값N
    END
    
    자바에서의 IF-ELSE IF문
*/

SELECT EMP_NAME, SALARY,
       CASE WHEN SALARY >= 5000000 THEN '고급'
            WHEN SALARY >= 3500000 THEN '중급'
            ELSE '초급'
       END "등급"
FROM employee;



--========================== < 그룹 함수 > =============================

-- 1. SUM(숫자타입컬럼) : 해당 컬럼값들의 총 합계 반환
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- 부서코드가 D5인 사원들의 총 연봉 합
SELECT SUM(SALARY*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';


-- 2. AGC(숫자타입) : 해당 컬럼값들의 평균값 반환
SELECT ROUND(AVG(SALARY)) -- 반올림 처리
FROM EMPLOYEE;


-- 3. MIN(ANY타입) : 해당 컬럼값들의 가장 작은 값 반환
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;


-- 4. MAX(ANY타입) : 해당 컬럼값들의 가장 큰 값 반환
SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;


-- 5. COUNT(*|컬럼|DISTINCT 컬럼 : 행 갯수 반환
--    COUNT(*) : 조회된 결과에 모든 행 갯수 반환
--    CONNT(컬럼) : 제시한 해당 컬럼값이 NULL이 아닌 행 갯수 반환
--    COUNT(DISTINCT 컬럼) : 해당 컬럼값 중복을 제거한 행 갯수 반환

-- 전체 사원 수
SELECT COUNT(*)
FROM EMPLOYEE;

-- 부서 배치를 받은 사원 수
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- 사원들이 해당한 부서 갯수 조회
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

