/*
    DDL (DATA DEFINITION LANGUAGE) : 데이터 정의 언어
    
    객체들을 생성(CREATE), 변경(ALTER), 삭제(DROP)하는 구문
    
    <ALTER>
    객체를 변경하는 구문
    
    [표현식]
    ALTER TABLE 테이블명 변경할내용;
    
    * 변경할 내용
    1) 컬럼 추가/수정/삭제
    2) 제약조건 추가 (기존 제약조건 수정은 불가, 삭제는 O 
                    즉, 삭제하고 다시 추가하는 것이 곧 수정)
    3) 컬럼명/제약조건명/테이블명 변경
*/


-- 1) 컬럼 추가/수정/삭제

-- 1-1) 컬럼 추가(ADD) : ADD 컬럼명 데이터타입 (DEFAULT 기본값)
-- DEPT_COPY에 CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20); -- 컬럼 생성 후 데이터는 NULL로 채워져

-- LNAME 컬럼 추가 (단, 기본값 지정)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';


-- 1-2) 컬럼 수정(MODIFY)
--      > 데이터 타입 수정 : MODIFY 컬럼명 바꾸고자하는데이터타입
--      > DEFAULT값 수정 : MODIFY 컬럼명 DEFAULT 바꾸고자하는기본값

ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER; -- 오류) 담겨있는 데이터값이 문자
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VACHAR2(10); -- 오류) 담긴 데이터값이 이미 용량 초과

-- 다중 컬럼 수정 가능
ALTER TABLE DEPT_COPY
     MODIFY DEPT_TITLE VARCHAR2(40)
     MODIFY LOCATION_ID VARCHAR2(2)
     MODIFY LNAME DEFAULT '미국';
     

-- 1-3) 컬럼 삭제(DROP COLUMN) : DROP COLUMN 삭제하고자하는컬럼명
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

-- DEPT_COPY2의 DEPT_ID 컬럼 삭제 (다중 컬럼 삭제 불가)
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;

ALTER TABLE DEPT_COPY2 DROP COLUMN LOVATION_ID;
-- 마지막 남은 컬럼을 삭제하려하니 오류발생) 컬럼 없는 테이블 존재가치X

----------------------------------------------------------------------

-- 2) 제약조건 추가 / 삭제

/*
    2_1) 제약조건 추가 
    PRIMARY KEY : ADD PRIMARY KEY(컬럼명)
    FOREIGN KEY : ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(컬럼명)]
    UNIQUE      : ADD UNIQUE(컬럼명)
    CHECK       : ADD CHECK(컬럼에대한조건)
    NOT NULL    : MODIFY 컬럼명 NULL|NOT NULL
    
    제약조건명을 지정하고자 한다면 [CONSTRAINT 제약조건명] 제약조건
*/

-- DEPT_ID에 PRIMARY KEY 제약조건 추가 ADD
-- DEPT_TITLE에 UNIQUE 제약조건 추가 ADD
-- LNAME에 NOT NULL 제약조건 추가 MODIFY
ALTER TABLE DEPT_COPY
    ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
    ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
    MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;

-- 2_2) 제약조건 삭제 : DROP CONSTRAINT 제약조건명 / MODIFY 컬럼명 NULL (NOT NULL제약조건일 경우)
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;

ALTER TABLE DEPT_COPY
    DROP CONSTRAINT DCOPY_UQ
    MODIFY LNAME NULL;

----------------------------------------------------------------------

-- 3) 컬럼명/제약조건명/테이블명 변경 (RENAME)

-- 3_1) 컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
-- DEPT_TITLE => DEPT_NAME
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3_2) 제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
-- SYS_C007140 => DCOPY_LID_NN
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007125 TO DCOPY_LID_NN;

-- 3_3_ 테이블 변경 : RENAME [기존테이블명] TO 바꿀테이블명
-- DEPT_COPY => DEPT_TEST
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

----------------------------------------------------------------------

-- 테이블 삭제
DROP TABLE DEPT_TEST;

-- 단, 어딘가에서 참조되고 있는 부모테이블은 함부로 삭제 X
-- 만약에 삭제하고자 한다면
-- 방법1. 자식테이블 먼저 삭제한 후 부모테이블 삭제
-- 방법2. 그냥 부모테이블만 삭제하는데 제약조건까지 같이 삭제
--        DROP TABLE 테이블명 CASCADE CONSTRAINT;