/*
    DQL (QUERY ������ ���� ���) : SELECT 
    
    DML (MANIPULATION ������ ���� ���) : [SELECT], INSERT, UPDATE, DELETE
    DDL (DEFINITION ������ ���� ���) : CREATE, ALTER, DROP
    DCL (CONTROL ������ ���� ���) : GRANT, REVOKE, [COMMIT, ROLLBACK]
    
    TCL (TRANSACTION Ʈ����� ���� ���) : COMMIT, ROLLBACK
    
    < DML : DATA MANIPULATION LANGUAGE >
    ������ ���� ���
    
    ���̺� ���� ����(INSERT)�ϰų�, ����(UPDATE)�ϰų�, ����(DELETE)�ϴ� ����
    
*/

/*
    1. INSERT
       ���̺� ���ο� ���� �߰��ϴ� ����
       
       [ǥ����]
       1) INSERT INTO ���̺�� VALUES(��, ��, ��, ��, ...);
          ���̺� ��� �÷��� ���� ���� ���� �����ؼ� �� �� INSERT�ϰ��� �� �� ��� 
          �÷� ������ ���Ѽ� VALUES�� ���� ����
*/

INSERT INTO EMPLOYEE 
VALUES(900, '�Ѽ���', '980914-2451321', 'suji_han@gy.or.kr', '01011112222',
       'D1', 'J7', 4000000, 0.2, 200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

/*
    2) INSERT INTO ���̺��(�÷���, �÷���, �÷���) VALUES(��, ��, ��);
       ���̺��� ������ �÷��� ���� ���� INSERT�� �� ��� 
       �� �� ������ �߰��Ǳ� ������ 
       ���þȵ� �÷��� �⺻������ NULL 
       => NOT NULL���������� �ɷ��ִ� �÷��� �ݵ�� �����ؼ� ���� �� ����
       ��, �⺻��(DEFAULT)�� �����Ǿ������� NULL�� �ƴ� �⺻��
       
*/
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES(901, '���̸�', '870918-2456124', 'J7', SYSDATE);

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
       , '���̸�'
       , '870918-2456124'
       , 'J7'
       , SYSDATE
       );

----------------------------------------------------------------------

/*
    3) INSERT INTO ���̺�� (��������);
       VALUES �� ���� ���� ����ϴ°� ��ſ�
       ���������� ��ȸ�� ������� ��ä�� INSERT ���� (������ INSERT ����)
*/
-- ���ο� ���̺� ����
CREATE TABLE EMP_01 (
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

-- ��ü ������� ���, �̸�, �μ��� ��ȸ
INSERT INTO EMP_01
    (SELECT EMP_ID, EMP_NAME, DEPT_TITLE
     FROM EMPLOYEE
     LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));
     -- LEFT ��� �� : �μ��� NULL���� ����� ����
     -- LEFT ��� �� : �μ� NULL�� ����� ����

----------------------------------------------------------------------

/*
    2. INSERT ALL
       �ΰ� �̻��� ���̺� ���� INSERT�Ҷ� 
       �̶� ���Ǵ� ���������� ���� �� ��� 
*/
--> �켱 �׽�Ʈ�� ���̺� �����
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

-- �μ��ڵ尡 D1�� ������� ���, �̸�, �μ��ڵ�, �Ի���, ������ ��ȸ 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

/*
    [ǥ����]
    INSERT ALL
    INTO ���̺��1 VALUES(�÷���, �÷���, ..)
    INTO ���̺��2 VALUES(�÷���, �÷���, ...)
        ��������;
*/
INSERT ALL
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';

SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;


-- * ������ ����ؼ��� �� ���̺� �� INSERT ����

-- 2000�⵵ ���� �Ի��� �Ի��ڵ� ���� ���̺�
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1=0;
   
-- 2000�⵵ ���� �Ի��� �Ի��ڵ� ���� ���̺�
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1=0;
   
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

/*
    [ǥ����]
    INSERT ALL
    WHEN ����1 THEN
        INTO ���̺��1 VALUES(�÷���, �÷���, ..)
    WHEN ����2 THEN
        INTO ���̺��2 VALUES(�÷���, �÷���, ..)
    ��������;
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
    ���̺� ���� �����͸� �����ϴ� ����
    
    [ǥ����]
    UPDATE ���̺��
    SET �÷��� = �ٲܰ�,
        �÷��� = �ٲܰ�,
        ...     --> �������� �÷��� ���ú��� ���� (,�� ���� AND X)
        [WHERE ����];  --> �����ϸ� ��ü ��� ���� ������ ���� 
*/

-- ���纻 ���̺� ���� �� �۾�
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

-- D9�μ��� �μ����� '������ȹ��'���� ����
UPDATE DEPT_COPY
SET DEPT_TITLE = '������ȹ��'; -- �����߻�!) 9�� �� ������Ʈ => ���� ����

ROLLBACK;

UPDATE DEPT_COPY
SET DEPT_TITLE = '������ȹ��'
WHERE DEPT_ID = 'D9';

-- ���ö ����� �޿��� 100�������� ����
-- ������ ����� �޿��� 700����, ���ʽ��� 0.2�� ����
-- (���纻���� ����)
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
   FROM EMPLOYEE;
   
UPDATE EMP_SALARY
SET SALARY = 1000000
WHERE EMP_NAME = '������';

SELECT * FROM EMP_SALARY;

UPDATE EMP_SALARY
SET SALARY = 7000000,
    BONUS = 0.2
WHERE EMP_NAME = '��ö��';

/*
    UPDATE�� ���������� ��� ����
    
    UPDATE ���̺��
    SET �÷��� = (��������)
    WHERE ����;
*/

-- ������ ����� �޿��� ���ʽ����� ��ö������� �޿��� ���ʽ������� ����
UPDATE EMP_SALARY 
SET SALARY = (SELECT SALARY
              FROM EMP_SALARY
              WHERE EMP_NAME = '��ö��'),
    BONUS = (SELECT BONUS
             FROM EMP_SALARY
             WHERE EMP_NAME = '��ö��')
WHERE EMP_NAME = '������';

-- ���߿� ���������ε� ����
UPDATE EMP_SALARY
SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                       FROM EMP_SALARY
                       WHERE EMP_NAME = '��ö��')
WHERE EMP_NAME = '������';

-- ASIA �������� �ٹ��ϴ� ������� ���ʽ����� 0.3���� ����

-- ASIA���� ����� ��ȸ (ASIA1, ASIA2, ASIA3)
SELECT *
FROM EMP_SALARY
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
WHERE LOCAL_NAME LIKE 'ASIA%';

-- ASIA���� ����� ���ʽ� 0.3 ����
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                 FROM EMP_SALARY
                 JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                 JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                 WHERE LOCAL_NAME LIKE 'ASIA%');
                 
                 
----------------------------------------------------------------------

-- UPDATE�� �ش� �÷��� ���� �������ǿ� ����Ǹ� X

-- ����� 200���� ����� �̸��� NULL�� ����
UPDATE EMPLOYEE
SET EMP_NAME = NULL
WHERE EMP_ID = 200; --> NOT NULL �������� ����(EMP_NAME�� NOT NULL ����)

-- ������ ����� �����ڵ带 J9�� ����
UPDATE EMPLOYEE
SET JOB_CODE = 'J9'
WHERE EMP_NAME = '������';  -- FOREIGN KEY �������� ���� ('J9'�� �������� �ʱ� ����)


----------------------------------------------------------------------
COMMIT;

/*
    4. DELETE
       ���̺� ��ϵ� �����͸� �����ϴ� ���� (�� �� ������ ����)
       
       [ǥ����]
       DELETE FROM ���̺��
       [WHERE ����]; --> !!!! WHERE�� ���� ���ϸ� ��ü �� �� ���� !!!!
*/

DELETE FROM EMPLOYEE; -- ��ü ����

SELECT * FROM EMPLOYEE;
ROLLBACK; --> ������ Ŀ�Խ������� ����

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '�Ѽ���';

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '���̸�';

COMMIT;

-- �����Ͱ��� �ڽĵ����Ͱ� ����ϰ� �ִٸ� ���� X
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1'; -- D1�� ���� ����ϴ� �ڽĵ����Ͱ� �ֱ� ������ ����X

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D3'; 

ROLLBACK;



-- * TRUNCATE : ���̺��� ��ü ���� ������ �� ���Ǵ� ����
--              DELETE���� �� ���� ����ӵ�
--              ������ �������� �Ұ�, ROLLBACK �Ұ�
-- [ǥ����] TRUNCATE TABLE ���̺��;

SELECT * FROM EMP_SALARY;

TRUNCATE TABLE EMP_SALARY;
ROLLBACK; -- �ѹ� �Ұ�
