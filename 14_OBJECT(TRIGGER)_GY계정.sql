/*
    < Ʈ���� TRIGGER > 
    ������ ���̺� INSERT, UPDATE, DELETE ���� DML���� ���� ��������� ���� ��
    (���̺� �̺�Ʈ�� �߻����� ��)
    �ڵ����� �Ź� ������ ������ �̸� �����ص� �� �ִ� ��ü
    
    EX)
    - ȸ��Ż�� �� ���� ȸ�����̺� ������ DELETE ��
      ��ٷ� Ż��� ȸ���鸸 ���� �����ϴ� ���̺� �ڵ����� INSERT ó��
    - �Ű�Ƚ���� ���� ���� �Ѿ��� �� ���������� �ش� ȸ���� ������Ʈ ó��
    - ����� ���� �����Ͱ� ���(INSERT)�� ������ 
      �ش� ��ǰ�� ���� �������� �Ź� ����(UPDATE) ó��
      
    * Ʈ���� ����
    - SQL���� ����ñ⿡ ���� �з�
      > BEFORE TRIGGER : ������ ���̺� �̺�Ʈ�� �߻��Ǳ� �� Ʈ���� ����
      > AFTER TRIGGER : ������ ���̺� �̺�Ʈ�� �߻� �� Ʈ���� ����
      
    - SQL���� ���� ������ �޴� �� �࿡ ���� �з�
      > STATEMENT TRIGGER(���� Ʈ����) : �̺�Ʈ�� �߻��� SQL���� Ʈ���� �� �ѹ��� ����
      > ROW TRIGGER(�� Ʈ����) : �ش� SQL�� ������ ������ �Ź� Ʈ���� ����
                                (FOR EACH ROW �ɼ� ���)
                    > :OLD - BEFORE UPDATE, BEFORE DELETE
                    > :NEW - AFTER INSERT, AFTER UPDATE
                    
    * Ʈ���� ���� ����
    
    [ǥ����]
    CREATE [ OR REPLACE] TRIGGER Ʈ���Ÿ�
    BEFORE|AFTER   INSERT|UPDATE|DELETE   ON ���̺��
    [FOR EACH ROW]
    [DECLARE
        ��������;]
    BEGIN
        ���೻��(�ش� ���� ������ �̺�Ʈ �߻� �� �ڵ����� ������ ����)
    [EXCEPTION
        ����ó�� ����;]
    END;
    /
*/

-- EMPLOYEE ���̺� ���ο� ���� INSERT�� ������ �ڵ����� �޼��� ��µǴ� Ʈ���� ����
CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE
BEGIN 
    DBMS_OUTPUT.PUT_LINE('���Ի���� ȯ���մϴ�!');
END;
/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(500, '��ö��', '222222-111111', 'D7', 'J7', SYSDATE);

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
VALUES(501, '�ͱ�', '333333-111111', 'D8', 'J7', SYSDATE);


--------------------------------------------------------------------------------

-- ��ǰ �԰� �� ��� ���� ����
-- >> �ʿ��� ���̺� �� ������ ����

-- 1. ��ǰ�� ���� �����͸� ������ ���̺� ����
CREATE TABLE TB_PRODUCT(
    PCODE NUMBER PRIMARY KEY,        -- ��ǰ������ȣ
    PNAME VARCHAR2(30) NOT NULL,     -- ��ǰ��
    BRAND VARCHAR2(30) NOT NULL,     -- �귣���
    PRICE NUMBER,                    -- ����
    STOCK NUMBER DEFAULT 0           -- ������
);


-- ��ǰ��ȣ �ߺ� �ȵǰԲ� �Ź� ���ο� ��ȣ �߻���Ű�� ������ (200���� 5�� ����)
CREATE SEQUENCE SEQ_PCODE
START WITH 200
INCREMENT BY 5
NOCACHE;


-- ���õ����� �߰�
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '�ֳ��ÿ�', '�������', 2500, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '���̹� Ÿ��Ʈ', 'JJMT', 7000, 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '��׷������ں����', '�������', 4500, 20);

SELECT * FROM TB_PRODUCT;

COMMIT;


-- 2. ��ǰ ����� �� �̷� ���̺�
--    � ��ǰ�� ���� �󸶰� �԰� �Ǵ� ��� �Ǿ����� �����͸� ����ϴ� ���̺�
CREATE TABLE TB_PRODETAIL(
    DCODE NUMBER PRIMARY KEY,                         -- �̷¹�ȣ
    PCODE NUMBER REFERENCES TB_PRODUCT/*(PCODE)*/,    -- ��ǰ��ȣ
    PDATE DATE NOT NULL,                              -- ��ǰ�������
    AMOUNT NUMBER NOT NULL,                           -- ��������
    STATUS CHAR(6) CHECK(STATUS IN ('�԰�', '���'))   -- ����(�԰�/���)
);

-- �̷¹�ȣ�� �Ź� ���ο� ��ȣ �߻����Ѽ� �ߺ��� �ȵǰԲ� ������ ���� (SEQ_DCODE)
CREATE SEQUENCE SEQ_DCODE
NOCACHE;

-- 215�� ��ǰ�� ���ó�¥�� 10�� �԰�
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 215, SYSDATE, 10, '�԰�');
-- 215�� ��ǰ�� �������� 10 ����
UPDATE TB_PRODUCT
   SET STOCK = STOCK + 10
 WHERE PCODE = 215;

COMMIT;

-- 220�� ��ǰ�� ���ó�¥�� 5�� ���
INSERT INTO TB_PRODETAIL 
VALUES(SEQ_DCODE.NEXTVAL, 220, SYSDATE, 5, '���');
-- 220�� ��ǰ�� �������� 5 ����
UPDATE TB_PRODUCT
   SET STOCK = STOCK - 5
 WHERE PCODE = 220;

COMMIT;

-- 205�� ��ǰ�� ���ó�¥�� 20�� �԰�
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 205, SYSDATE, 20, '�԰�');
-- 205�� ��ǰ�� �������� 20 ����
UPDATE TB_PRODUCT
   SET STOCK = STOCK + 20
 WHERE PCODE = 200;

ROLLBACK; --> �Ǽ� �߻��Ͽ� ���󺹱�


-- 225�� ��ǰ�� ���ó�¥�� 5�� �԰�
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 220, SYSDATE, 5, '�԰�');
-- 225�� ��ǰ�� �������� 5 ����
UPDATE TB_PRODUCT
   SET STOCK = STOCK + 5
 WHERE PCODE = 225;

COMMIT;
-- �԰�/���� �Բ� �������� ���� �����ؾ��ϴ� ���ŷο� => Ʈ���� ���Ƿ� �����ذ�

--------------------------------------------------------------------------------

-- TB_PRODETAIL ���̺� INSERT �̺�Ʈ �߻��� 
-- TB_PRODUCT ���̺� �Ź� �ڵ����� ������ UPDATER�ǰԲ� Ʈ���� ����

/*
    - ��ǰ�� �԰�� ��� => �ش� ��ǰã�Ƽ� ������ ���� UPDATE
    UPDATE TB_PRODUCT
       SET STOCK = STOCK + �����԰�ȼ���(INSERT���ڷ���AMOUNT��)
     WHERE PCODE = �԰�Ȼ�ǰ��ȣ(INSERT���ڷ��� PCODE��);
    
    - ��ǰ�� ���� ��� => �ش� ��ǰã�Ƽ� ������ ���� UPDATE
    UPDATE TB_PRODUCT
       SET STOCK = STOCK - �������ȼ���(INSERT���ڷ���AMOUNT��)
     WHERE PCODE = ���Ȼ�ǰ��ȣ(INSERT���ڷ��� PCODE��);
*/

CREATE OR REPLACE TRIGGER TRG_02
AFTER INSERT ON TB_PRODETAIL  -- �� ���̺� INSERT�� ���Ŀ� Ʈ���� ����
FOR EACH ROW -- Ʈ���� �� �� Ʈ���� ����
BEGIN
    -- ��ǰ�� �԰�� ��� => ������ ����
    IF (:NEW.STATUS = '�԰�') -- :NEW == INSERT�� ��
        THEN
            UPDATE TB_PRODUCT
               SET STOCK = STOCK + :NEW.AMOUNT
             WHERE PCODE = :NEW.PCODE;
    END IF;
    -- ��ǰ�� ���� ��� => ������ ����
    IF (:NEW.STATUS = '���')
        THEN 
            UPDATE TB_PRODUCT
               SET STOCK = STOCK - :NEW.AMOUNT
             WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/

-- 220�� ��ǰ�� ���ó�¥�� 7�� ���� �Բ� ������ ����
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 220, SYSDATE, 7, '���');

-- 215�� ��ǰ�� ���ó�¥�� 30�� �԰�� �Բ� ���ÿ� ������ ����
INSERT INTO TB_PRODETAIL
VALUES(SEQ_DCODE.NEXTVAL, 215, SYSDATE, 30, '�԰�');