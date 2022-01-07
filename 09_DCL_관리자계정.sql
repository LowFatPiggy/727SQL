/*
    < DCL : DATA CONTROL LANGUAGE >
    ������ ���� ��� 
    
    �������� �ý��۱��� �Ǵ� ��ü���ٱ����� �ο�(GRANT)�ϰų� ȸ��(REVOKE)�ϴ� ����
    
    > �ý��� ���� : DB�� �����ϴ� ����, ��ü���� ������ �� �ִ� ���� 
    > ��ü���ٱ��� : Ư�� ��ü���� ������ �� �ִ� ����
*/

/*
    * �ý��۱��� ����
    - CREATE SESSION : ������ �� �ִ� ���� 
    - CREATE TABLE : ���̺��� ������ �� �ִ� ����
    - CREATE VIEW : �� ������ �� �ִ� ����
    - CREATE SEQUENCE : ������ ������ �� �ִ� ����
    .... 
*/

-- 1. SAMPLE/SAMPLE ���� ����
CREATE USER SAMPLE IDENTIFIED BY SAMPLE;
-- 2. ������ ���� CREATE SESSION ���� �ο�
GRANT CREATE SESSION TO SAMPLE;

-- 3_1. ���̺��� ������ �� �ִ� CREATE TABLE ���� �ο�
GRANT CREATE TABLE TO SAMPLE;
-- 3_2. TABLESPACE �Ҵ� (SAMPLE���� ����)
ALTER USER SAMPLE QUOTA 2M ON SYSTEM;

----------------------------------------------------------------

/*
    * ��ü ���� ���� ����
    Ư�� ��ü�� �����ؼ� ������ �� �ִ� ����
    
    ��������        Ư����ü
    SELECT   TABLE, VIEW, SEQUENCE
    INSERT   TABLE, VIEW
    UPDATE   TABLE, VIEW
    DELETE   TABLE, VIEW
    ...
    
    [ǥ����]
    GRANT �������� ON Ư����ü TO ������;
*/
GRANT SELECT ON GY.EMPLOYEE TO SAMPLE;
GRANT INSERT ON GY.DEPARTMENT TO SAMPLE;

-- ���� ȸ�� 
-- REVOKE ȸ���ұ��� FROM ������;
REVOKE SELECT ON GY.EMPLOYEE FROM SAMPLE;

----------------------------------------------------------------

GRANT CONNECT, RESOURCE TO ������;

/*
    < �� ROLE >
    - Ư�� ���ѵ��� �ϳ��� �������� ��Ƴ��� ��
    
    CONNECT : ������ �� �ִ� ���� (CREATE SESSION)
    RESOURCE : Ư�� ��ü���� ������ �� �ִ� ����(CREATE TABLE, CREATE SEQUENCE, ...) 
*/

SELECT *
FROM ROLE_SYS_PRIVS
WHERE ROLE IN ('CONNECT', 'RESOURCE')
ORDER BY 1;



-- �ǽ��� ���� ���� (FINAL/FINAL)
CREATE USER FINAL IDENTIFIED BY FINAL;
GRANT CONNECT, RESOURCE TO FINAL;