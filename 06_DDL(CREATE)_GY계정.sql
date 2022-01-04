/*
    * DDL (DATE DEFINITION LANGUAGE) : 데이터 정의 언어
    오라클에서 제공하는 객체(OBJECT)를 만들고(CREATE),
    구조를 변경(ALTER)하고, 구조 자체를 삭제(DROP)하는 언어
    즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
    
    오라클에서의 객체(구조) : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE)
                           인덱스(INDEX), 패키지(PACKAGE), 트리거(TRIGGER)
                           프로시져(PROCEDURE), 함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
                           
    < CREATE >
    객체를 생성하는 구문
*/

/*
    1. 테이블 생성
    - 테이블 : 행(ROW)과 열(COLUMN)로 구성되는 가장 기본적인 데이터베이스 객체
              모든 데이터들은 테이블을 통해서 저장
              (DBMS용어 중 하나로, 데이터를 일종의 표 형태로 표현한 것)
              
    [표현식]
    CREATE TABLE 테이블명(
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        ...
    );
    
    * 자료형
    - 문자 (CHAR(바이트크기) | VARCHAR2(바이트크기)) (반드시 크기 지정)
      > CHAR : 최대 2000BYTE까지 지정 가능 / 고정 길이
               (지정한 크기보다 더 적은 값이 들어오면 공백으로 채워 지정한 크기만큼 세팅)
      > VARCHAR2 : 최대 4000BYTE까지 지정 가능 / 가변 길이
                   (담긴 값에 따라서 공간의 크기 세팅)
      
    - 숫자 (NUMBER)
    - 날짜 (DATE)
*/

-- 회원에 대한 데이터를 담기위한 테이블 MEMBER 생성
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);

SELECT * FROM MEMBER;

-- 데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블들 
-- [참고] USER_TABLES : 이 사용자가 가지고 있는 테이블들의 전반적인 구조를 확인 할 수 있는 시스템테이블
SELECT * FROM USER_TABLES;
-- [참고] USER_TAB_COLUMNS : 이 사용자가 가지고 있는 테이블들 상의 모든 컬럼의 전반적인 구조를 확인 할 수 있는 시스템테이블
SELECT * FROM USER_TAB_COLUMNS;


----------------------------------------------------------------------

/*
    2. 컬럼에 주석 달기 (컬럼에 대한 설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    >> 잘못 작성해서 실행했을 경우 수정 후 다시 실행 가능
*/
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';

COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원명';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남/여)';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

-- 테이블 삭제하고자 할 때 : DROP TABLE 테이블명;

-- 테이블에 데이터 추가시키는 구문 (DML : INSERT)
-- INSERT INTO 테이블명 VALUES(값, 값, 값, ...);
INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '신짱구', '남', '010-1111-2222', 'zzanggoo@zgnmmr.com', '20/12/30');
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '김철수', '남', NULL, NULL, SYSDATE);


INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- 문제발생!) NULL값을 INSERT함(데이터 없이 생성) => NOT NULL 제약조건 필요

----------------------------------------------------------------------

/*
    < 제약조건 CONSTRAINTS >
    - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해서 특정 컬럼에 설정하는 제약
    - 데이터 무결성 보장을 목적
    
    종류 : NOT NULL, UNIQUE, CHECK(조건), PRIMARY KEY, FOREIGN KEY
*/

/*
    * NOT NULL 제약조건
      해당 컬럼에 반드시 NULL이 아닌 값이 존재해야만 하는 경우
      삽입/수정 시 NULL값을 허용하지 않도록 제한
      
      제약조건을 부여하는 방식은 컬럼레벨방식/테이블레벨방식 두 가지
      * NOT NULL제약조건은 컬럼레벨방식으로만 가능
*/

--컬럼레벨방식 : 컬럼명 자료형 제약조건
CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_NOTNULL VALUES(1, 'user01', 'pass01', '신짱구', '남', NULL, NULL);
INSERT INTO MEM_NOTNULL VALUES(2, 'user02', NULL, '김철수', '남', NULL, 'cheolsoo@zgnmmr.com');
-- NOTNULL제약조건에 위배되어 오류 발생

INSERT INTO MEM_NOTNULL VALUES(2, 'user01', 'pass02', '김철수', '남', NULL, 'cheolsoo@zgnmmr.com');
-- 문제발생!) 아이디가 중복되었음에도 추가 => UNIQUE 제약조건필요


----------------------------------------------------------------------

/*
    * UNIQUE 제약조건
      해당 컬럼에 중복된 값이 입력되서는 안될 경우
      컬럼값에 중복값을 제한하는 제약조건
*/

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

DROP TABLE MEM_UNIQUE;

-- 테이블레벨 방식 : 모든 컬럼들 나열 후 마지막에 기술
--                 제약조건(컬럼명)
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID) --> 테이블레벨방식
);

INSERT INTO MEM_UNIQUE VALUES(1, 'user01', 'pass01', '신짱구', NULL, NULL, NULL);
INSERT INTO MEM_UNIQUE VALUES(2, 'user01', 'pass02', '김철수', NULL, NULL, NULL);
-- UNIQUE 제약조건에 위배되었으므로 INSERT 실패
-- 문제발생!) 오류 위치를 알려주지 않기 때문에 오류부분 발견이 어려움 => 제약조건명 필요

DROP TABLE MEM_UNIQUE;

/*
    * 제약조건 부여시 제약조건명까지 지어주는 방법
    
    > 컬럼레벨방식
    CREATE TABLE 테이블명(
        컬럼명 자료형 제약조건,
        컬럼명 자료형
    );
    
    > 테이블레벨방식
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형,
        [CONSTRAINT 제약조건명] 제약조건(컬럼명)
    );
*/

CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER CONSTRAINT MEMNO_NN NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NN NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMID_UQ UNIQUE(MEM_ID)
);

INSERT INTO MEM_UNIQUE VALUES(1, 'user01', 'pass01', '신짱구', NULL, NULL, NULL);
INSERT INTO MEM_UNIQUE VALUES(2, 'user01', 'pass02', '김철수', NULL, NULL, NULL);
-- MEMID_UQ unique constraint 발생 (제약조건명을 넣어 오류 위치를 쉽게 알수 있음)

SELECT * FROM MEM_UNIQUE;

INSERT INTO MEM_UNIQUE VALUES(3, 'user03', 'pass03', '한유리', 'ㅎ', NULL, NULL);
-- 문제발생!) 성별에 유효하지 않은 값이 들어와도 INSERT => CHECK(조건식) 제약조건 필요

----------------------------------------------------------------------

/*
    * CHECK(조건식) 제약조건
      해당 컬럼에 들어올 수 있는 값에 대한 조건을 제시
*/

CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')), -- 컬럼레벨방식
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
    -- ,CHECK(GENDER IN ('남', '여')) -- 테이블레벨방식
);

INSERT INTO MEM_CHECK 
VALUES(1, 'user01', 'pass01', '신짱구', '남', null, null);

INSERT INTO MEM_CHECK
VALUES(2, 'user02', 'pass02', '한유리', 'ㅇ', null, null);
--> CHECK 제약조건 위배로 오류 발생 (성별에 유효하지 않은 값 입력)

INSERT INTO MEM_CHECK
VALUES(2, 'user02', 'pass02', '홍길녀', null, null, null);
--> GENDER 컬럼에 데이터값을 넣고자 한다면 CHECKE 제약조건에 만족하는 값을 넣어야
--> NULL도 INSERT // NULL값도 유효하지 않은 값으로 처리하려면 NOT NULL 제약조건 사용

SELECT * FROM MEM_CHECK;

INSERT INTO MEM_CHECK
VALUES(2, 'user03', 'pass03', '한수지', '여', null, null);
--> 문제발생!) 회원번호가 동일해도 insert => PRIMARY KEY 제약조건 필요

----------------------------------------------------------------------

/*
    * PRIMARY KEY(기본키) 제약조건
      테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건 (식별자의 역할)
      
      EX) 회원번호, 학번, 사원번호, 부서코드, 직급코드, 주문번호, 예약번호, 운송장번호, ....
      
      PRIMARY KEY 제약조건을 부여하면 그 컬럼에 자동으로 NOT NULL + UNIQUE 제약조건 수행
      
      * 유의사항 : 한 테이블당 한 개만 설정 가능 
*/
CREATE TABLE MEM_PRI(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY, --> 컬럼레벨 방식
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
    -- , CONSTRAINT MEMNO_PK PRIMARY KEY(MEM_NO) --> 테이블레벨 방식
);

INSERT INTO MEM_PRI
VALUES(1, 'user01', 'pass01', '한유리', '여', '010-1111-2222', null);

INSERT INTO MEM_PRI
VALUES(1, 'user02', 'pass02', '이훈이', '남', null, null);
--> 기본키(MEM_NO)에 중복값을 담으려고 할 때 (unique 제약조건 위배)

INSERT INTO MEM_PRI
VALUES(null, 'user02', 'pass02', '이훈이', '남', null, null);
--> 기본키에(MEM_NO) null을 담으려고 할 때 (not null 제약조건 위배)

INSERT INTO MEM_PRI
VALUES(2, 'user02', 'pass02', '맹구', '남', null, null);

SELECT * FROM MEM_PRI;




CREATE TABLE MEM_PRI2(
    MEM_NO NUMBER, 
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    PRIMARY KEY(MEM_NO, MEM_ID) --> 묶어서 PRIMARY KEY 제약조건 부여 (복합키)
);

INSERT INTO MEM_PRI2
VALUES(1, 'user01', 'pass01', '김철수', null, null, null);

INSERT INTO MEM_PRI2
VALUES(1, 'user02', 'pass02', '신수지', null, null, null);
-- (MEM_NO, MEM_ID)를 묶어서 중복되는지 확인 -> MEM_ID가 다르기 때문에 INSERT

INSERT INTO MEM_PRI2
VALUES(2, 'user02', 'pass03', '이훈이', null, null, null);
-- 마찬가지로 MEM_NO가 중복되지 않기때문에 INSERT

INSERT INTO MEM_PRI2
VALUES(null, 'user02', 'pass03', '신짱구', null, null, null);
--> PRIMARY KEY로 묶여있는 각 컬럼에는 NULL값 X


-- 복합키 사용 예시 (어떤 회원이 어떤 상품을 찜하는지 데이터를 보관하는 테이블)
CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE); -- 1회원이 A 찜
INSERT INTO TB_LIKE VALUES(1, 'B', SYSDATE); -- 1회원이 B 찜
INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE); -- 1회원이 A 찜 (오류, 중복찜X)


----------------------------------------------------------------------


-- 회원등급에 대한 데이터를 따로 보관하는 테이블 
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');

SELECT * FROM MEM_GRADE;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER --> 회원등급번호 보관할 컬럼
);
INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '신짱아', '여', null, null, null);

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '김철수', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '맹구', null, null, null, 40);
--> 문제발생!) 유효한 회원등급번호가 아닌데 INSERT => FOREIGN KEY 제약조건 필요

----------------------------------------------------------------------

/*
    * FOREIGN KEY(외래키) 제약조건 
      다른테이블에 존재하는 값만 특정 컬럼에 부여하는 제약조건 
      --> 다른테이블을 참조한다고 표현
      --> 주로 FOREIGN KEY 제약조건에 의해 테이블 간의 관계가 형성
      
      > 컬럼레벨방식
      컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명[(참조할컬럼명)]
      
      > 테이블레벨방식
      [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)]
      
      --> 참조할컬럼명 생략시 참조할테이블에 PRIMARY KEY로 지정된 컬럼으로 매칭 
*/

DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE --(GRADE_CODE) --> 컬럼레벨 방식
    -- , FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) --> 테이블레벨방식
);
INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '신짱아', '여', null, null, null);
--> 외래키 제약조건이 부여된 컬럼에 기본적으로 NULL 허용됨 

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '김철수', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '맹구', null, null, null, 40);
--> PARENT KEY를 찾을 수 없다는 오류 발생 



-- MEM_GRADE(부모테이블) -|------<- MEM(자식테이블)

--> 이때 부모테이블(MEM_GRADE)에서 데이터값을 삭제할 경우
-- 데이터 삭제 : DELETE FROM 테이블명 WHERE 조건;

--> MEM_GRADE 테이블에서 10번 등급 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--> 자식테이블(MEM)에 10이라는 값을 사용하고 있기 때문에 삭제가 X

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 30;
--> 자식테이블(MEM)에 30이라는 값을 사용하고 있지 않기 때문에 삭제 O

--> 자식테이블에 이미 사용하고 있는 값이 있을 경우
--  부모테이블에는 "삭제제한" 옵션 

ROLLBACK;

----------------------------------------------------------------------

/*
    자식테이블 생성시 외래키 제약조건 부여할 때 삭제옵션 지정가능
    * 삭제옵션 : 부모테이블의 데이터 삭제 시 그 데이터를 사용하고 있는 
                자식테이블의 값을 처리해주는 옵션 
    
    - ON DELETE RESTRICTED (기본값) : 삭제제한옵션으로, 자식데이터로 쓰이는 부모데이터 삭제 X
    - ON DELETE SET NULL : 부모데이터 삭제시 해당 데이터를 쓰고 있는 자식데이터의 값을 NULL로 변경
    - ON DELETE CASCADE : 부모데이터 삭제시 해당 데이터를 쓰고 있는 자식데이터도 같이 삭제
*/
DROP TABLE MEM;


-- ON DELETE SET NULL
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE SET NULL
);
INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '신짱아', '여', null, null, null);
--> 외래키 제약조건이 부여된 컬럼에 기본적으로 NULL 허용

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '김철수', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '맹구', null, null, null, 20);

INSERT INTO MEM
VALUES(4, 'user04', 'pass04', '한유리', null, null, null, 10);

-- 10번 등급 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--> 삭제 O (단, 10을 가져다 쓰고있던 자식데이터값은 NULL로 변경)

ROLLBACK;
DROP TABLE MEM;


-- ON DELETE CASCADE
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE CASCADE
);
INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '신짱아', '여', null, null, null);

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '김철수', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '맹구', null, null, null, 20);

INSERT INTO MEM
VALUES(4, 'user04', 'pass04', '한유리', null, null, null, 10);

-- 10번 등급 삭제
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--> 삭제 O (단, 해당 데이터를 사용하고 있던 자식데이터도 같이 DELETE)

----------------------------------------------------------------------

/*
    < DEFAULT 기본값 > ** 제약조건 아님!! **
    컬럼을 선정하지 않고 NULL이 아닌 기본값을 INSERT하고자 할때 세팅해둘 수 있는 값 
*/
DROP TABLE MEMBER;

-- 컬럼명 자료형 DEFAULT 기본값 [제약조건]
CREATE TABLE MEMBER(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    MEM_AGE NUMBER,
    HOBBY VARCHAR2(20) DEFAULT '없음',
    ENROLL_DATE DATE DEFAULT SYSDATE
);

-- INSERT INTO 테이블명 VALUES(컬럼값, 컬럼값, 컬럼값, ....);
INSERT INTO MEMBER VALUES(1, '한유리', 20, '소꿉놀이', '19/12/13');
INSERT INTO MEMBER VALUES(2, '신짱구', NULL, NULL, NULL);
INSERT INTO MEMBER VALUES(3, '이훈이', NULL, DEFAULT, DEFAULT);

-- INSERT INTO 테이블명(컬럼명, 컬럼명) VALUES(컬럼값, 컬럼값);
INSERT INTO MEMBER(MEM_NO, MEM_NAME) VALUES(4, '맹구');
--> 선택되지 않은 컬럼에는 기본적으로 NULL이 들어감
--  단, 해당 컬럼에 DEFAULT값이 부여되어있을 경우 NULL이 아닌 DEFAULT값이 들어감



--==================== KH계정으로 실행 ======================

/*
    
    < SUBQUERY를 이용한 테이블 생성 >
    테이블 복사하는 개념
    
    [표현식]
    CREATE TABLE 테이블명 
    AS 서브쿼리;
    
*/

-- EMPLOYEE 테이블을 복제한 새로운 테이블 생성 
CREATE TABLE EMPLOYEE_COPY
AS SELECT * 
   FROM EMPLOYEE;

SELECT * FROM EMPLOYEE_COPY;
--> 컬럼, 데이터값, 제약조건 같은 경우 NOT NULL만 복사됨 

CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
   FROM EMPLOYEE
   WHERE 1 = 0; --> 구조만을 복사하고자 할 때 쓰이는 구문 (데이터값은 복사X)

SELECT * FROM EMPLOYEE_COPY2;

CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 "연봉"
   FROM EMPLOYEE;
--> 서브쿼리 SELECT절에 산술식 또는 함수식 기술된 경우 반드시 별칭 지정

SELECT EMP_NAME, 연봉
FROM EMPLOYEE_COPY3;

----------------------------------------------------------------------

/*
    * 테이블 다 생성된 후에  제약조건 추가 
    
    ALTER TABLE 테이블명 변경할내용;
    
    - PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
    - FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)];
    - UNIQUE      : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
    - CHECK       : ALTER TABLE 테이블명 ADD CHECK(컬럼에대한조건식);
    - NOT NULL    : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
*/
-- EMPLOYEE_COPY 테이블에 PRIMARY KEY 제약조건 추가 (EMP_ID)
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

-- EMPLOYEE 테이블에 DEPT_CODE에 외래키제약조건 추가 (참조하는테이블(부모) : DEPARTMENT(DEPT_ID))
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;

-- EMPLOYEE 테이블에 JOB_CODE에 외래키제약조건 추가 (JOB 테이블 참조)
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;

-- DEPARTMENT 테이블에 LOCATION_ID에 외래키제약조건 추가 (LOCATION테이블 참조)
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION;

