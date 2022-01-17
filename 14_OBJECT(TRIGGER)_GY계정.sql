/*
    < 트리거 TRIGGER > 
    지정한 테이블에 INSERT, UPDATE, DELETE 등의 DML문에 의해 변경사항이 생길 때
    (테이블에 이벤트가 발생했을 때)
    자동으로 매번 실행할 내용을 미리 정의해둘 수 있는 객체
    
    EX)
    - 회원탈퇴 시 기존 회원테이블에 데이터 DELETE 후
      곧바로 탈퇴된 회원들만 따로 보관하는 테이블에 자동으로 INSERT 처리
    - 신고횟수가 일정 수를 넘었을 때 묵시적으로 해당 회원을 블랙리스트 처리
    - 입출고에 대한 데이터가 기록(INSERT)될 때마다 
      해당 상품에 대한 재고수량을 매번 수정(UPDATE) 처리
      
    * 트리거 종류
    - SQL문의 실행시기에 따른 분류
      > BEFORE TRIGGER : 지정한 테이블에 이벤트가 발생되기 전 트리거 실행
      > AFTER TRIGGER : 지정한 테이블에 이벤트가 발생 후 트리거 실행
      
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
      > STATEMENT TRIGGER(문장 트리거) : 이벤트가 발생한 SQL문에 트리거 딱 한번만 실행
      > ROW TRIGGER(행 트리거) : 해당 SQL문 실행할 때마다 매번 트리거 실행
                                (FOR EACH ROW 옵션 기술)
                    > :OLD - BEFORE UPDATE, BEFORE DELETE
                    > :NEW - AFTER INSERT, AFTER UPDATE
                    
    * 트리거 생성 구문
    
    [표현식]
    CREATE [ OR REPLACE] TRIGGER 트리거명
    BEFORE|AFTER   INSERT|UPDATE|DELETE   ON 테이블명
    [FOR EACH ROW]
    [DECLARE
        변수선언;]
    BEGIN
        실행내용(해당 위에 지정된 이벤트 발생 시 자동으로 실행할 구문)
    [EXCEPTION
        예외처리 구문;]
    END;
    /
*/

-- EMPLOYEE 테이블에 새로운 행이 INSERT될 때마다 자동으로 메세지 출력되는 트리거 정의
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN 
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다!');
END;
/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(500, '김철수', '222222-111111', 'D7', 'J7', SYSDATE);

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(501, '맹구', '333333-111111', 'D8', 'J7', SYSDATE);


--------------------------------------------------------------------------------

-- 상품 입고 및 출고 관련 예시
-- >> 필요한 테이블 및 시퀀스 생성

-- 1. 상품에 대한 데이터를 보관할 테이블 생성
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY,        -- 상품고유번호
    PNAME VARCHAR2(30) NOT NULL,     -- 상품명
    BRAND VARCHAR2(30) NOT NULL,     -- 브랜드명
    PRICE NUMBER,                    -- 가격
    STOCK NUMBER DEFAULT 0           -- 재고수량
);


-- 상품번호 중복 안되게끔 매번 새로운 번호 발생시키는 시퀀스 (200부터 5씩 증가)
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5
NOCACHE;


-- 샘플데이터 추가
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '휘낭시에', '존재맛탱', 2500, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '보늬밤 타르트', 'JJMT', 7000, 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '얼그레이초코브라우니', '존재맛탱', 4500, 20);

SELECT * FROM TB_PRODUCT;

COMMIT;


-- 2. 상품 입출고 상세 이력 테이블
--    어떤 상품이 언제 얼마가 입고 또는 출고가 되었는지 데이터를 기록하는 테이블
CREATE TABLE TB_PRODETAIL(
    DCODE NUMBER PRIMARY KEY,                         -- 이력번호
    PCODE NUMBER REFERENCES TB_PRODUCT/*(PCODE)*/,    -- 상품번호
    PDATE DATE NOT NULL,                              -- 상품입출고일
    AMOUNT NUMBER NOT NULL,                           -- 입출고수량
    STATUS CHAR(6) CHECK(STATUS IN ('입고', '출고'))   -- 상태(입고/출고)
);

-- 이력번호를 매번 새로운 번호 발생시켜서 중복이 안되게끔 시퀀스 생성 (SEQ_DCODE)
CREATE SEQUENCE SEQ_DCODE
NOCACHE;

-- 215번 상품이 오늘날짜로 10개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 215, SYSDATE, 10, '입고');
-- 215번 상품의 재고수량을 10 증가
UPDATE TB_PRODUCT
   SET STOCK = STOCK + 10
 WHERE PCODE = 215;

COMMIT;

-- 220번 상품이 오늘날짜로 5개 출고
INSERT INTO TB_PRODETAIL 
VALUES(SEQ_DCODE.NEXTVAL, 220, SYSDATE, 5, '출고');
-- 220번 상품의 재고수량을 5 감소
UPDATE TB_PRODUCT
   SET STOCK = STOCK - 5
 WHERE PCODE = 220;

COMMIT;

-- 205번 상품이 오늘날짜로 20개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 205, SYSDATE, 20, '입고');
-- 205번 상품의 재고수량을 20 증가
UPDATE TB_PRODUCT
   SET STOCK = STOCK + 20
 WHERE PCODE = 200;

ROLLBACK; --> 실수 발생하여 원상복귀


-- 225번 상품이 오늘날짜로 5개 입고
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 220, SYSDATE, 5, '입고');
-- 225번 상품의 재고수량을 5 증가
UPDATE TB_PRODUCT
   SET STOCK = STOCK + 5
 WHERE PCODE = 225;

COMMIT;
-- 입고/출고와 함께 재고수량도 같이 업뎃해야하는 번거로움 => 트리거 정의로 문제해결

--------------------------------------------------------------------------------

-- TB_PRODETAIL 테이블에 INSERT 이벤트 발생시 
-- TB_PRODUCT 테이블에 매번 자동으로 재고수량 UPDATER되게끔 트리거 정의

/*
    - 상품이 입고된 경우 => 해당 상품찾아서 재고수량 증가 UPDATE
    UPDATE TB_PRODUCT
       SET STOCK = STOCK + 현재입고된수량(INSERT된자료의AMOUNT값)
     WHERE PCODE = 입고된상품번호(INSERT된자료의 PCODE값);
    
    - 상품이 출고된 경우 => 해당 상품찾아서 재고수량 감소 UPDATE
    UPDATE TB_PRODUCT
       SET STOCK = STOCK - 현재출고된수량(INSERT된자료의AMOUNT값)
     WHERE PCODE = 출고된상품번호(INSERT된자료의 PCODE값);
*/

CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL  -- 이 테이블에 INSERT된 이후에 트리거 실행
FOR EACH ROW -- 트리거 중 행 트리거 실행
BEGIN
    -- 상품이 입고된 경우 => 재고수량 증가
    IF (:NEW.STATUS = '입고') -- :NEW == INSERT를 뜻
        THEN
            UPDATE TB_PRODUCT
               SET STOCK = STOCK + :NEW.AMOUNT
             WHERE PCODE = :NEW.PCODE;
    END IF;
    -- 상품이 출고된 경우 => 재고수량 감소
    IF (:NEW.STATUS = '출고')
        THEN 
            UPDATE TB_PRODUCT
               SET STOCK = STOCK - :NEW.AMOUNT
             WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

-- 220번 상품이 오늘날짜로 7개 출고와 함께 재고수량 업뎃
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 220, SYSDATE, 7, '출고');

-- 215번 상품이 오늘날짜로 30개 입고와 함께 동시에 재고수량 업뎃
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 215, SYSDATE, 30, '입고');