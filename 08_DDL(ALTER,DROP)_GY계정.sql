/*
    DDL (DATA DEFINITION LANGUAGE) : ������ ���� ���
    
    ��ü���� ����(CREATE), ����(ALTER), ����(DROP)�ϴ� ����
    
    <ALTER>
    ��ü�� �����ϴ� ����
    
    [ǥ����]
    ALTER TABLE ���̺�� �����ҳ���;
    
    * ������ ����
    1) �÷� �߰�/����/����
    2) �������� �߰� (���� �������� ������ �Ұ�, ������ O 
                    ��, �����ϰ� �ٽ� �߰��ϴ� ���� �� ����)
    3) �÷���/�������Ǹ�/���̺�� ����
*/


-- 1) �÷� �߰�/����/����

-- 1-1) �÷� �߰�(ADD) : ADD �÷��� ������Ÿ�� (DEFAULT �⺻��)
-- DEPT_COPY�� CNAME �÷� �߰�
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20); -- �÷� ���� �� �����ʹ� NULL�� ä����

-- LNAME �÷� �߰� (��, �⺻�� ����)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '�ѱ�';


-- 1-2) �÷� ����(MODIFY)
--      > ������ Ÿ�� ���� : MODIFY �÷��� �ٲٰ����ϴµ�����Ÿ��
--      > DEFAULT�� ���� : MODIFY �÷��� DEFAULT �ٲٰ����ϴ±⺻��

ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER; -- ����) ����ִ� �����Ͱ��� ����
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VACHAR2(10); -- ����) ��� �����Ͱ��� �̹� �뷮 �ʰ�

-- ���� �÷� ���� ����
ALTER TABLE DEPT_COPY
     MODIFY DEPT_TITLE VARCHAR2(40)
     MODIFY LOCATION_ID VARCHAR2(2)
     MODIFY LNAME DEFAULT '�̱�';
     

-- 1-3) �÷� ����(DROP COLUMN) : DROP COLUMN �����ϰ����ϴ��÷���
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

-- DEPT_COPY2�� DEPT_ID �÷� ���� (���� �÷� ���� �Ұ�)
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;

ALTER TABLE DEPT_COPY2 DROP COLUMN LOVATION_ID;
-- ������ ���� �÷��� �����Ϸ��ϴ� �����߻�) �÷� ���� ���̺� ���簡ġX

----------------------------------------------------------------------

-- 2) �������� �߰� / ����

/*
    2_1) �������� �߰� 
    PRIMARY KEY : ADD PRIMARY KEY(�÷���)
    FOREIGN KEY : ADD FOREIGN KEY(�÷���) REFERENCES ���������̺��[(�÷���)]
    UNIQUE      : ADD UNIQUE(�÷���)
    CHECK       : ADD CHECK(�÷�����������)
    NOT NULL    : MODIFY �÷��� NULL|NOT NULL
    
    �������Ǹ��� �����ϰ��� �Ѵٸ� [CONSTRAINT �������Ǹ�] ��������
*/

-- DEPT_ID�� PRIMARY KEY �������� �߰� ADD
-- DEPT_TITLE�� UNIQUE �������� �߰� ADD
-- LNAME�� NOT NULL �������� �߰� MODIFY
ALTER TABLE DEPT_COPY
    ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
    ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
    MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;

-- 2_2) �������� ���� : DROP CONSTRAINT �������Ǹ� / MODIFY �÷��� NULL (NOT NULL���������� ���)
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;

ALTER TABLE DEPT_COPY
    DROP CONSTRAINT DCOPY_UQ
    MODIFY LNAME NULL;

----------------------------------------------------------------------

-- 3) �÷���/�������Ǹ�/���̺�� ���� (RENAME)

-- 3_1) �÷��� ���� : RENAME COLUMN �����÷��� TO �ٲ��÷���
-- DEPT_TITLE => DEPT_NAME
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3_2) �������Ǹ� ���� : RENAME CONSTRAINT �����������Ǹ� TO �ٲ��������Ǹ�
-- SYS_C007140 => DCOPY_LID_NN
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007125 TO DCOPY_LID_NN;

-- 3_3_ ���̺� ���� : RENAME [�������̺��] TO �ٲ����̺��
-- DEPT_COPY => DEPT_TEST
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

----------------------------------------------------------------------

-- ���̺� ����
DROP TABLE DEPT_TEST;

-- ��, ��򰡿��� �����ǰ� �ִ� �θ����̺��� �Ժη� ���� X
-- ���࿡ �����ϰ��� �Ѵٸ�
-- ���1. �ڽ����̺� ���� ������ �� �θ����̺� ����
-- ���2. �׳� �θ����̺� �����ϴµ� �������Ǳ��� ���� ����
--        DROP TABLE ���̺�� CASCADE CONSTRAINT;