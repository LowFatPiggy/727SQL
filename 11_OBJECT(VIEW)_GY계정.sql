/*
    < VIEW �� >
    
    SELECT��(������)�� �����ص� �� �ִ� ��ü
    (���� ���� �� SELECT���� �����صθ� �� �� SELECT���� �Ź� �ٽ� ����� �ʿ� X)
    �ӽ����̺� ���� ���� (���� �����Ͱ� ��� ���� X => ������ ���̺�)
*/

-- '�ѱ�'���� �ٹ��ϴ� ������� ���, �̸�, �μ���, �޿�, �ٹ������� ��ȸ 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING(NATIONAL_CODE)
 WHERE NATIONAL_NAME = '�ѱ�';
 
-- '���þ�'���� �ٹ��ϴ� ������� ���, �̸�, �μ���, �޿�, �ٹ������� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING(NATIONAL_CODE)
 WHERE NATIONAL_NAME = '���þ�';

-- '�Ϻ�'���� �ٹ��ϴ� ���
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING(NATIONAL_CODE)
 WHERE NATIONAL_NAME = '�Ϻ�';

------------------------------------------------------------------

/*
    1. VIEW ���� ���
    
    [ǥ����]
    CREATE [OR REPLACE] VIEW ���
    AS ��������;
    
    [OR REPLACE] : �� ������ ������ �ߺ��� �̸��� �䰡 ���ٸ� ���� �並 �����ϰ�,
                            ������ �ߺ��� �̸��� �䰡 �ִٸ� �ش� �並 ����(����)�ϴ� �ɼ�
*/

CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME, BONUS
     FROM EMPLOYEE
     JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
     JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
     JOIN NATIONAL USING(NATIONAL_CODE);

-- GRANT CREATE VIEW TO kh;   --> �����ڰ������� ����

SELECT *
FROM VW_EMPLOYEE;
-- �Ʒ��� ���� �ƶ�
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
        FROM EMPLOYEE
        JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
        JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
        JOIN NATIONAL USING(NATIONAL_CODE));
        
-- ��� ������ ���� ���̺� (���������� �����͸� �����ϰ� ���� ����)

-- '�ѱ�', '���þ�', '�Ϻ�'�� �ٹ��ϴ� ���
SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '�ѱ�';

SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '���þ�';
 
SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '�Ϻ�';
 
-- [����]
SELECT * FROM USER_VIEWS;

------------------------------------------------------------------
/*
    * �� �÷��� ��Ī �ο�
      ���������� SELECT���� �Լ����̳� ���������� ����Ǿ����� ��� �ݵ�� ��Ī ����
*/
-- �� ����� ���, �̸�, ���޸�, ����(��/��), �ٹ������ ��ȸ�ϴ� SELECT���� 
-- ��(VW_EMP_JOB)�� ����
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, 
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��') "����", -- ��������
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) "�ٹ����" -- ��
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);

-- �Ʒ��� ���� ������ε� ��Ī �ο�����
-- ��� �ڿ� ��ȣ �ȿ� ��Ī �ۼ� (��, �̶��� ��� �÷��� ���� ��Ī�� �ۼ�)
CREATE OR REPLACE VIEW VW_EMP_JOB(���, �̸�, ���޸�, ����, �ٹ����)
AS SELECT EMP_ID, EMP_NAME, JOB_NAME, 
          DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��'),
          EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
     FROM EMPLOYEE
     JOIN JOB USING(JOB_CODE);

SELECT *
  FROM VW_EMP_JOB;
  
  
SELECT �̸�, ���޸�
  FROM VW_EMP_JOB
 WHERE ���� = '��';

SELECT *
  FROM VW_EMP_JOB
 WHERE �ٹ���� >= 20;

-- �� �����ϰ��� �Ѵٸ�
DROP VIEW VW_EMP_JOB;

------------------------------------------------------------------

-- ������ �並 �̿��ؼ� DML(INSERT, UPDATE, DELETE) ��밡��
-- �並 ���ؼ� �����ϰ� �Ǹ� ���� �����Ͱ� ����ִ� ���̽����̺� �ݿ���

CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE, JOB_NAME
     FROM JOB;

SELECT * FROM VW_JOB; -- ������ ���̺� (���������Ͱ� ������� ����)
SELECT * FROM JOB;    -- ���̽� ���̺� (���� �����Ͱ� �������)

-- �並 ���ؼ� INSERT
INSERT INTO VW_JOB VALUES('J8', '����'); -- ���̽����̺� ���������� INSERT

-- �並 ���ؼ� UPDATE
UPDATE VW_JOB
   SET JOB_NAME = '�˹�'
 WHERE JOB_CODE = 'J8';

-- �並 ���ؼ� DELETE
DELETE 
  FROM VW_JOB
 WHERE JOB_CODE = 'J8';

------------------------------------------------------------------

/*
    * ��, DML ��ɾ�� ������ �Ұ����� ���
    
    1) �信 ���ǵǾ����� ���� �÷��� �����Ϸ��� �ϴ� ���
    2) �信 ���ǵǾ����� ���� �÷� �߿� ���̽����̺� �� NOT NULL���������� �����Ǿ��ִ� ���
    3) ��������� �Ǵ� �Լ������� ���ǵǾ��ִ� ���
    4) �׷��Լ��� GROUP BY���� ���Ե� ��� 
    5) DISTINCT ������ ���Ե� ���
    6) JOIN�� �̿��ؼ� ���� ���̺��� ������ѳ��� ��� 
    
*/

-- 1) �信 ���ǵǾ����� ���� �÷��� �����Ϸ��� �ϴ� ���
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE
     FROM JOB;

SELECT * FROM VW_JOB;
SELECT * FROM JOB;

-- INSERT (�信 JOB_NAME�� ���ǵ��� �ʾұ� ������ ����)
INSERT INTO VW_JOB(JOB_CODE, JOB_NAME) VALUES('J8', '����');

-- UPDATE (���� ���� ��)
UPDATE VW_JOB
   SET JOB_NAME = '����'
 WHERE JOB_CODE = 'J7';

-- DELETE (���� ���� ��)
DELETE
  FROM VW_JOB
 WHERE JOB_NAME = '���';

-- 2) �信 ���ǵǾ����� ���� �÷� �߿��� ���̽����̺� NOT NULL ���������� ������ ��� 
CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_NAME
     FROM JOB;
     
SELECT * FROM VW_JOB;
SELECT * FROM JOB;

-- INSERT 
-- ���� ���̽����̺� INSERT�ؼ� (NULL, '����') �߰��Ϸ� ��
INSERT INTO VW_JOB VALUES('����'); --  JOB_CODE�� NOT NULL �������� ������ ����

-- UPDATE (�信 ���ǵǾ��ִ� ���� ������ ���̱� ������ ����) 
UPDATE VW_JOB
   SET JOB_NAME = '�˹�'
 WHERE JOB_NAME = '���';

ROLLBACK;

-- DELETE (�� �����͸� ���� �ִ� �ڽĵ����� �����ϱ� ������ �������� / ��, ���ٸ� ���� O)
DELETE 
  FROM VW_JOB
 WHERE JOB_NAME = '���';

-- 3) �Լ��� �Ǵ� ������������ ���ǵ� ��� 
CREATE OR REPLACE VIEW VW_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 ����
     FROM EMPLOYEE;

SELECT * FROM VW_EMP_SAL;
SELECT * FROM EMPLOYEE;

-- INSERT (SALARY*12 ���������� ���ԵǾ� ����)
INSERT INTO VW_EMP_SAL VALUES(400, 'ä����', 3000000, 36000000);

-- UPDATE
-- 200�� ����� ������ 8000��������
UPDATE VW_EMP_SAL
   SET ���� = 80000000
 WHERE EMP_ID = 200;  -- ����(���� SALARY*12 �������� ����)

-- 200�� ����� �޿��� 700��������
UPDATE VW_EMP_SAL
   SET SALARY = 7000000
 WHERE EMP_ID = 200;  -- ����

ROLLBACK;

-- DELETE (����)
-- ���������� ���ԵǾ� �ִ� �κ��� �ǵ帰�ٰ� ������ ���� X
-- ���̽����̺� �ݿ��Ǵµ� ���� ���ٸ� �۾� ����
DELETE 
  FROM VW_EMP_SAL
 WHERE ���� = 72000000;

ROLLBACK;

-- 4) �׷��Լ� �Ǵ� GROUP BY���� �����ϴ� ��� 
CREATE OR REPLACE VIEW VW_GROUPDEPT
AS SELECT DEPT_CODE, SUM(SALARY) "�հ�", FLOOR(AVG(SALARY)) "���"
     FROM EMPLOYEE
 GROUP BY DEPT_CODE;

SELECT * FROM VW_GROUPDEPT;

-- INSERT (GROUP BY�� ����, �Լ��ı��� ���ԵǾ� ����)
INSERT INTO VW_GROUPDEPT VALUES('D3', 8000000, 4000000);

-- UPDATE (�����͵��� �հ��ε� �����͸� �����ϰ� �Ǵ� ���̱� ������ ����)
UPDATE VW_GROUPDEPT
   SET �հ� = 8000000
 WHERE DEPT_CODE = 'D1';
 
-- DELETE (�׷��� �������� �����͸� �������� ������ ��Ȳ = ����)
DELETE 
  FROM VW_GROUPDEPT
 WHERE �հ� = 5210000;

-- 5) DISTINCT�� ���Ե� ���
CREATE OR REPLACE VIEW VW_DT_JOB
AS SELECT DISTINCT JOB_CODE -- DISTINCT ; �ߺ��� �͵��� �ѹ��� 
     FROM EMPLOYEE;

SELECT * FROM VW_DT_JOB; 

-- INSERT (����)
INSERT INTO VW_DT_JOB VALUES('J8');

-- UPDATE (����)
UPDATE VW_DT_JOB
   SET JOB_CODE = 'J8'
 WHERE JOB_CODE = 'J7';

-- DELETE (����)
DELETE
  FROM VW_DT_JOB
 WHERE JOB_CODE = 'J4';
 
-- 6) JOIN�� �̿��ؼ� ���� ���̺��� ������ ���
CREATE OR REPLACE VIEW VW_JOINEMP
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
     FROM EMPLOYEE
     JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT * FROM VW_JOINEMP;

-- INSERT (EMPLOYEE, DEPARTMENT �� ���̺� ������ �߰��Ǿ�� �ϴµ� �׷��Ա��� ����)
INSERT INTO VW_JOINEMP VALUES(300, '���̸�', '�ѹ���');

-- UPDATE
UPDATE VW_JOINEMP
   SET EMP_NAME = '������'
 WHERE EMP_ID = '200'; -- ����(������ ����)
 
UPDATE VW_JOINEMP
   SET DEPT_TITLE = 'ȸ���'
 WHERE EMP_ID = 200;  -- ����(JOIN�� ���� ����� ����� ������ X)
 
-- DELETE
DELETE 
  FROM VW_JOINEMP
 WHERE EMP_ID = 200; -- ����

SELECT * FROM EMPLOYEE;

ROLLBACK; 

------------------------------------------------------------------

/*
    * VIEW �ɼ�
    
    [��ǥ����]
    CREATE [OR REPLACE] [FORCE|"NOFORCE"] VIEW ���
    AS ��������
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    1) OR REPLACE : ������ ������ �䰡 ���� ��� ����, �������� ������ ���� ����
    2) FORCE | NOFORCE
       > FORCE : ���������� ����� ���̺��� �������� �ʾƵ� �� ����
       > NOFORCE : ���������� ����� ���̺��� �����ϴ� ���̺��̿��߸� �� ���� (������ �⺻��)
    3) WITH CHECK OPTION : DML�� ���������� ����� ���ǿ� ������ �����θ� DML ����
    4) WITH READ ONLY : �信 ���� ��ȸ�� ���� (DML�� ����Ұ�)
       
*/

-- 2) FORCE | NOFORCE
--    NOFORCE : ���������� ����� ���̺��� �����ϴ� ���̺��̿��߸� �� ���� 
CREATE OR REPLACE /*NOFORCE*/ VIEW VW_EMP -- ������ �⺻��
AS SELECT TCODE, TNAME, TCONTENT
     FROM TT; -- �̷� ���̺� ���� ������ ����

--    FORCE : ���������� ����� ���̺��� �������� �ʾƵ� �䰡 �켱�� ����
CREATE OR REPLACE FORCE VIEW VW_EMP
AS SELECT TCODE, TNAME, TCONTENT
     FROM TT; -- ������ ������ �Բ� �䰡 ����

SELECT * FROM VW_EMP; -- �䰡 ��������� �ߴµ� ���̺��� �������� �ʱ� ������ ��ȸ �Ұ�

-- TT���̺��� �����ؾ߸� �׶����� VIEW Ȱ�� ����
CREATE TABLE TT(
    TCODE NUMBER,
    TNAME VARCHAR2(20),
    TCONTENT VARCHAR2(30)
);

-- 3) WITH CHECK OPTION : ���������� ����� ���ǿ� �������� �ʴ� ������ ���� �� ����

-- WITH CHECK OPTION ���� �� �� ���
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
     FROM EMPLOYEE
    WHERE SALARY >= 3000000;

SELECT * FROM VW_EMP; -- 8�� ��ȸ

-- 200�� ����� �޿��� 200�������� ���� 
-- (���������� ���ǿ� ���յ��� �ʴ� ������ ����õ�) => ���� ����
UPDATE VW_EMP
   SET SALARY = 2000000
 WHERE EMP_ID = 200;

SELECT * FROM EMPLOYEE;

ROLLBACK;

-- WITH CHECK OPTION ���� �� ���
CREATE OR REPLACE VIEW VW_EMP
AS SELECT *
     FROM EMPLOYEE
    WHERE SALARY >= 3000000
WITH CHECK OPTION;
    
SELECT * FROM VW_EMP; -- 8�� ��ȸ 

UPDATE VW_EMP
   SET SALARY = 2000000
 WHERE EMP_ID = 200; --> ���������� ����� ���ǿ� ���յ��� �ʱ� ������ ���� �Ұ�
 
UPDATE VW_EMP
   SET SALARY = 4000000
 WHERE EMP_ID = 200; --> ���������� ����� ���ǿ� ���յǱ� ������ ���� ����
 
SELECT * FROM EMPLOYEE; 

ROLLBACK; 

-- 4) WITH READ ONLY : �信 ���� ��ȸ�� ���� (DML ����Ұ�)
CREATE OR REPLACE VIEW VW_EMP
AS SELECT EMP_ID, EMP_NAME, BONUS
     FROM EMPLOYEE
    WHERE BONUS IS NOT NULL
WITH READ ONLY;
    
SELECT * FROM VW_EMP;

DELETE 
  FROM VW_EMP
 WHERE EMP_ID = 200; -- ��ȸ�� ������ ��� DML ���� ����
    
