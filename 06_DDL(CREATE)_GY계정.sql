/*
    * DDL (DATE DEFINITION LANGUAGE) : ������ ���� ���
    ����Ŭ���� �����ϴ� ��ü(OBJECT)�� �����(CREATE),
    ������ ����(ALTER)�ϰ�, ���� ��ü�� ����(DROP)�ϴ� ���
    ��, ���� ������ ���� �ƴ� ���� ��ü�� �����ϴ� ���
    
    ����Ŭ������ ��ü(����) : ���̺�(TABLE), ��(VIEW), ������(SEQUENCE)
                           �ε���(INDEX), ��Ű��(PACKAGE), Ʈ����(TRIGGER)
                           ���ν���(PROCEDURE), �Լ�(FUNCTION), ���Ǿ�(SYNONYM), �����(USER)
                           
    < CREATE >
    ��ü�� �����ϴ� ����
*/

/*
    1. ���̺� ����
    - ���̺� : ��(ROW)�� ��(COLUMN)�� �����Ǵ� ���� �⺻���� �����ͺ��̽� ��ü
              ��� �����͵��� ���̺��� ���ؼ� ����
              (DBMS��� �� �ϳ���, �����͸� ������ ǥ ���·� ǥ���� ��)
              
    [ǥ����]
    CREATE TABLE ���̺��(
        �÷��� �ڷ���(ũ��),
        �÷��� �ڷ���(ũ��),
        ...
    );
    
    * �ڷ���
    - ���� (CHAR(����Ʈũ��) | VARCHAR2(����Ʈũ��)) (�ݵ�� ũ�� ����)
      > CHAR : �ִ� 2000BYTE���� ���� ���� / ���� ����
               (������ ũ�⺸�� �� ���� ���� ������ �������� ä�� ������ ũ�⸸ŭ ����)
      > VARCHAR2 : �ִ� 4000BYTE���� ���� ���� / ���� ����
                   (��� ���� ���� ������ ũ�� ����)
      
    - ���� (NUMBER)
    - ��¥ (DATE)
*/

-- ȸ���� ���� �����͸� ������� ���̺� MEMBER ����
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

-- ������ ��ųʸ� : �پ��� ��ü���� ������ �����ϰ� �ִ� �ý��� ���̺�� 
-- [����] USER_TABLES : �� ����ڰ� ������ �ִ� ���̺���� �������� ������ Ȯ�� �� �� �ִ� �ý������̺�
SELECT * FROM USER_TABLES;
-- [����] USER_TAB_COLUMNS : �� ����ڰ� ������ �ִ� ���̺�� ���� ��� �÷��� �������� ������ Ȯ�� �� �� �ִ� �ý������̺�
SELECT * FROM USER_TAB_COLUMNS;


----------------------------------------------------------------------

/*
    2. �÷��� �ּ� �ޱ� (�÷��� ���� ����)
    
    [ǥ����]
    COMMENT ON COLUMN ���̺��.�÷��� IS '�ּ�����';
    
    >> �߸� �ۼ��ؼ� �������� ��� ���� �� �ٽ� ���� ����
*/
COMMENT ON COLUMN MEMBER.MEM_NO IS 'ȸ����ȣ';
COMMENT ON COLUMN MEMBER.MEM_ID IS 'ȸ�����̵�';

COMMENT ON COLUMN MEMBER.MEM_PWD IS 'ȸ����й�ȣ';
COMMENT ON COLUMN MEMBER.MEM_NAME IS 'ȸ����';
COMMENT ON COLUMN MEMBER.GENDER IS '����(��/��)';
COMMENT ON COLUMN MEMBER.PHONE IS '��ȭ��ȣ';
COMMENT ON COLUMN MEMBER.EMAIL IS '�̸���';
COMMENT ON COLUMN MEMBER.MEM_DATE IS 'ȸ��������';

-- ���̺� �����ϰ��� �� �� : DROP TABLE ���̺��;

-- ���̺� ������ �߰���Ű�� ���� (DML : INSERT)
-- INSERT INTO ���̺�� VALUES(��, ��, ��, ...);
INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '��¯��', '��', '010-1111-2222', 'zzanggoo@zgnmmr.com', '20/12/30');
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '��ö��', '��', NULL, NULL, SYSDATE);


INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- �����߻�!) NULL���� INSERT��(������ ���� ����) => NOT NULL �������� �ʿ�

----------------------------------------------------------------------

/*
    < �������� CONSTRAINTS >
    - ���ϴ� �����Ͱ�(��ȿ�� ������ ��)�� �����ϱ� ���ؼ� Ư�� �÷��� �����ϴ� ����
    - ������ ���Ἲ ������ ����
    
    ���� : NOT NULL, UNIQUE, CHECK(����), PRIMARY KEY, FOREIGN KEY
*/

/*
    * NOT NULL ��������
      �ش� �÷��� �ݵ�� NULL�� �ƴ� ���� �����ؾ߸� �ϴ� ���
      ����/���� �� NULL���� ������� �ʵ��� ����
      
      ���������� �ο��ϴ� ����� �÷��������/���̺������ �� ����
      * NOT NULL���������� �÷�����������θ� ����
*/

--�÷�������� : �÷��� �ڷ��� ��������
CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);

INSERT INTO MEM_NOTNULL VALUES(1, 'user01', 'pass01', '��¯��', '��', NULL, NULL);
INSERT INTO MEM_NOTNULL VALUES(2, 'user02', NULL, '��ö��', '��', NULL, 'cheolsoo@zgnmmr.com');
-- NOTNULL�������ǿ� ����Ǿ� ���� �߻�

INSERT INTO MEM_NOTNULL VALUES(2, 'user01', 'pass02', '��ö��', '��', NULL, 'cheolsoo@zgnmmr.com');
-- �����߻�!) ���̵� �ߺ��Ǿ������� �߰� => UNIQUE ���������ʿ�


----------------------------------------------------------------------

/*
    * UNIQUE ��������
      �ش� �÷��� �ߺ��� ���� �ԷµǼ��� �ȵ� ���
      �÷����� �ߺ����� �����ϴ� ��������
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

-- ���̺��� ��� : ��� �÷��� ���� �� �������� ���
--                 ��������(�÷���)
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_ID) --> ���̺������
);

INSERT INTO MEM_UNIQUE VALUES(1, 'user01', 'pass01', '��¯��', NULL, NULL, NULL);
INSERT INTO MEM_UNIQUE VALUES(2, 'user01', 'pass02', '��ö��', NULL, NULL, NULL);
-- UNIQUE �������ǿ� ����Ǿ����Ƿ� INSERT ����
-- �����߻�!) ���� ��ġ�� �˷����� �ʱ� ������ �����κ� �߰��� ����� => �������Ǹ� �ʿ�

DROP TABLE MEM_UNIQUE;

/*
    * �������� �ο��� �������Ǹ���� �����ִ� ���
    
    > �÷��������
    CREATE TABLE ���̺��(
        �÷��� �ڷ��� ��������,
        �÷��� �ڷ���
    );
    
    > ���̺������
    CREATE TABLE ���̺��(
        �÷��� �ڷ���,
        �÷��� �ڷ���,
        [CONSTRAINT �������Ǹ�] ��������(�÷���)
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

INSERT INTO MEM_UNIQUE VALUES(1, 'user01', 'pass01', '��¯��', NULL, NULL, NULL);
INSERT INTO MEM_UNIQUE VALUES(2, 'user01', 'pass02', '��ö��', NULL, NULL, NULL);
-- MEMID_UQ unique constraint �߻� (�������Ǹ��� �־� ���� ��ġ�� ���� �˼� ����)

SELECT * FROM MEM_UNIQUE;

INSERT INTO MEM_UNIQUE VALUES(3, 'user03', 'pass03', '������', '��', NULL, NULL);
-- �����߻�!) ������ ��ȿ���� ���� ���� ���͵� INSERT => CHECK(���ǽ�) �������� �ʿ�

----------------------------------------------------------------------

/*
    * CHECK(���ǽ�) ��������
      �ش� �÷��� ���� �� �ִ� ���� ���� ������ ����
*/

CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')), -- �÷��������
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
    -- ,CHECK(GENDER IN ('��', '��')) -- ���̺������
);

INSERT INTO MEM_CHECK 
VALUES(1, 'user01', 'pass01', '��¯��', '��', null, null);

INSERT INTO MEM_CHECK
VALUES(2, 'user02', 'pass02', '������', '��', null, null);
--> CHECK �������� ����� ���� �߻� (������ ��ȿ���� ���� �� �Է�)

INSERT INTO MEM_CHECK
VALUES(2, 'user02', 'pass02', 'ȫ���', null, null, null);
--> GENDER �÷��� �����Ͱ��� �ְ��� �Ѵٸ� CHECKE �������ǿ� �����ϴ� ���� �־��
--> NULL�� INSERT // NULL���� ��ȿ���� ���� ������ ó���Ϸ��� NOT NULL �������� ���

SELECT * FROM MEM_CHECK;

INSERT INTO MEM_CHECK
VALUES(2, 'user03', 'pass03', '�Ѽ���', '��', null, null);
--> �����߻�!) ȸ����ȣ�� �����ص� insert => PRIMARY KEY �������� �ʿ�

----------------------------------------------------------------------

/*
    * PRIMARY KEY(�⺻Ű) ��������
      ���̺��� �� ����� �ĺ��ϱ� ���� ���� �÷��� �ο��ϴ� �������� (�ĺ����� ����)
      
      EX) ȸ����ȣ, �й�, �����ȣ, �μ��ڵ�, �����ڵ�, �ֹ���ȣ, �����ȣ, ������ȣ, ....
      
      PRIMARY KEY ���������� �ο��ϸ� �� �÷��� �ڵ����� NOT NULL + UNIQUE �������� ����
      
      * ���ǻ��� : �� ���̺�� �� ���� ���� ���� 
*/
CREATE TABLE MEM_PRI(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY, --> �÷����� ���
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
    -- , CONSTRAINT MEMNO_PK PRIMARY KEY(MEM_NO) --> ���̺��� ���
);

INSERT INTO MEM_PRI
VALUES(1, 'user01', 'pass01', '������', '��', '010-1111-2222', null);

INSERT INTO MEM_PRI
VALUES(1, 'user02', 'pass02', '������', '��', null, null);
--> �⺻Ű(MEM_NO)�� �ߺ����� �������� �� �� (unique �������� ����)

INSERT INTO MEM_PRI
VALUES(null, 'user02', 'pass02', '������', '��', null, null);
--> �⺻Ű��(MEM_NO) null�� �������� �� �� (not null �������� ����)

INSERT INTO MEM_PRI
VALUES(2, 'user02', 'pass02', '�ͱ�', '��', null, null);

SELECT * FROM MEM_PRI;




CREATE TABLE MEM_PRI2(
    MEM_NO NUMBER, 
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    PRIMARY KEY(MEM_NO, MEM_ID) --> ��� PRIMARY KEY �������� �ο� (����Ű)
);

INSERT INTO MEM_PRI2
VALUES(1, 'user01', 'pass01', '��ö��', null, null, null);

INSERT INTO MEM_PRI2
VALUES(1, 'user02', 'pass02', '�ż���', null, null, null);
-- (MEM_NO, MEM_ID)�� ��� �ߺ��Ǵ��� Ȯ�� -> MEM_ID�� �ٸ��� ������ INSERT

INSERT INTO MEM_PRI2
VALUES(2, 'user02', 'pass03', '������', null, null, null);
-- ���������� MEM_NO�� �ߺ����� �ʱ⶧���� INSERT

INSERT INTO MEM_PRI2
VALUES(null, 'user02', 'pass03', '��¯��', null, null, null);
--> PRIMARY KEY�� �����ִ� �� �÷����� NULL�� X


-- ����Ű ��� ���� (� ȸ���� � ��ǰ�� ���ϴ��� �����͸� �����ϴ� ���̺�)
CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME)
);

INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE); -- 1ȸ���� A ��
INSERT INTO TB_LIKE VALUES(1, 'B', SYSDATE); -- 1ȸ���� B ��
INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE); -- 1ȸ���� A �� (����, �ߺ���X)


----------------------------------------------------------------------


-- ȸ����޿� ���� �����͸� ���� �����ϴ� ���̺� 
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);

INSERT INTO MEM_GRADE VALUES(10, '�Ϲ�ȸ��');
INSERT INTO MEM_GRADE VALUES(20, '���ȸ��');
INSERT INTO MEM_GRADE VALUES(30, 'Ư��ȸ��');

SELECT * FROM MEM_GRADE;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER --> ȸ����޹�ȣ ������ �÷�
);
INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '��¯��', '��', null, null, null);

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '��ö��', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '�ͱ�', null, null, null, 40);
--> �����߻�!) ��ȿ�� ȸ����޹�ȣ�� �ƴѵ� INSERT => FOREIGN KEY �������� �ʿ�

----------------------------------------------------------------------

/*
    * FOREIGN KEY(�ܷ�Ű) �������� 
      �ٸ����̺� �����ϴ� ���� Ư�� �÷��� �ο��ϴ� �������� 
      --> �ٸ����̺��� �����Ѵٰ� ǥ��
      --> �ַ� FOREIGN KEY �������ǿ� ���� ���̺� ���� ���谡 ����
      
      > �÷��������
      �÷��� �ڷ��� [CONSTRAINT �������Ǹ�] REFERENCES ���������̺��[(�������÷���)]
      
      > ���̺������
      [CONSTRAINT �������Ǹ�] FOREIGN KEY(�÷���) REFERENCES ���������̺��[(�������÷���)]
      
      --> �������÷��� ������ ���������̺� PRIMARY KEY�� ������ �÷����� ��Ī 
*/

DROP TABLE MEM;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE --(GRADE_CODE) --> �÷����� ���
    -- , FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) --> ���̺������
);
INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '��¯��', '��', null, null, null);
--> �ܷ�Ű ���������� �ο��� �÷��� �⺻������ NULL ���� 

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '��ö��', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '�ͱ�', null, null, null, 40);
--> PARENT KEY�� ã�� �� ���ٴ� ���� �߻� 



-- MEM_GRADE(�θ����̺�) -|------<- MEM(�ڽ����̺�)

--> �̶� �θ����̺�(MEM_GRADE)���� �����Ͱ��� ������ ���
-- ������ ���� : DELETE FROM ���̺�� WHERE ����;

--> MEM_GRADE ���̺��� 10�� ��� ����
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--> �ڽ����̺�(MEM)�� 10�̶�� ���� ����ϰ� �ֱ� ������ ������ X

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 30;
--> �ڽ����̺�(MEM)�� 30�̶�� ���� ����ϰ� ���� �ʱ� ������ ���� O

--> �ڽ����̺� �̹� ����ϰ� �ִ� ���� ���� ���
--  �θ����̺��� "��������" �ɼ� 

ROLLBACK;

----------------------------------------------------------------------

/*
    �ڽ����̺� ������ �ܷ�Ű �������� �ο��� �� �����ɼ� ��������
    * �����ɼ� : �θ����̺��� ������ ���� �� �� �����͸� ����ϰ� �ִ� 
                �ڽ����̺��� ���� ó�����ִ� �ɼ� 
    
    - ON DELETE RESTRICTED (�⺻��) : �������ѿɼ�����, �ڽĵ����ͷ� ���̴� �θ����� ���� X
    - ON DELETE SET NULL : �θ����� ������ �ش� �����͸� ���� �ִ� �ڽĵ������� ���� NULL�� ����
    - ON DELETE CASCADE : �θ����� ������ �ش� �����͸� ���� �ִ� �ڽĵ����͵� ���� ����
*/
DROP TABLE MEM;


-- ON DELETE SET NULL
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE SET NULL
);
INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '��¯��', '��', null, null, null);
--> �ܷ�Ű ���������� �ο��� �÷��� �⺻������ NULL ���

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '��ö��', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '�ͱ�', null, null, null, 20);

INSERT INTO MEM
VALUES(4, 'user04', 'pass04', '������', null, null, null, 10);

-- 10�� ��� ����
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--> ���� O (��, 10�� ������ �����ִ� �ڽĵ����Ͱ��� NULL�� ����)

ROLLBACK;
DROP TABLE MEM;


-- ON DELETE CASCADE
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('��', '��')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE CASCADE
);
INSERT INTO MEM
VALUES(1, 'user01', 'pass01', '��¯��', '��', null, null, null);

INSERT INTO MEM
VALUES(2, 'user02', 'pass02', '��ö��', null, null, null, 10);

INSERT INTO MEM
VALUES(3, 'user03', 'pass03', '�ͱ�', null, null, null, 20);

INSERT INTO MEM
VALUES(4, 'user04', 'pass04', '������', null, null, null, 10);

-- 10�� ��� ����
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;
--> ���� O (��, �ش� �����͸� ����ϰ� �ִ� �ڽĵ����͵� ���� DELETE)

----------------------------------------------------------------------

/*
    < DEFAULT �⺻�� > ** �������� �ƴ�!! **
    �÷��� �������� �ʰ� NULL�� �ƴ� �⺻���� INSERT�ϰ��� �Ҷ� �����ص� �� �ִ� �� 
*/
DROP TABLE MEMBER;

-- �÷��� �ڷ��� DEFAULT �⺻�� [��������]
CREATE TABLE MEMBER(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    MEM_AGE NUMBER,
    HOBBY VARCHAR2(20) DEFAULT '����',
    ENROLL_DATE DATE DEFAULT SYSDATE
);

-- INSERT INTO ���̺�� VALUES(�÷���, �÷���, �÷���, ....);
INSERT INTO MEMBER VALUES(1, '������', 20, '�Ҳ߳���', '19/12/13');
INSERT INTO MEMBER VALUES(2, '��¯��', NULL, NULL, NULL);
INSERT INTO MEMBER VALUES(3, '������', NULL, DEFAULT, DEFAULT);

-- INSERT INTO ���̺��(�÷���, �÷���) VALUES(�÷���, �÷���);
INSERT INTO MEMBER(MEM_NO, MEM_NAME) VALUES(4, '�ͱ�');
--> ���õ��� ���� �÷����� �⺻������ NULL�� ��
--  ��, �ش� �÷��� DEFAULT���� �ο��Ǿ����� ��� NULL�� �ƴ� DEFAULT���� ��



--==================== KH�������� ���� ======================

/*
    
    < SUBQUERY�� �̿��� ���̺� ���� >
    ���̺� �����ϴ� ����
    
    [ǥ����]
    CREATE TABLE ���̺�� 
    AS ��������;
    
*/

-- EMPLOYEE ���̺��� ������ ���ο� ���̺� ���� 
CREATE TABLE EMPLOYEE_COPY
AS SELECT * 
   FROM EMPLOYEE;

SELECT * FROM EMPLOYEE_COPY;
--> �÷�, �����Ͱ�, �������� ���� ��� NOT NULL�� ����� 

CREATE TABLE EMPLOYEE_COPY2
AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
   FROM EMPLOYEE
   WHERE 1 = 0; --> �������� �����ϰ��� �� �� ���̴� ���� (�����Ͱ��� ����X)

SELECT * FROM EMPLOYEE_COPY2;

CREATE TABLE EMPLOYEE_COPY3
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 "����"
   FROM EMPLOYEE;
--> �������� SELECT���� ����� �Ǵ� �Լ��� ����� ��� �ݵ�� ��Ī ����

SELECT EMP_NAME, ����
FROM EMPLOYEE_COPY3;

----------------------------------------------------------------------

/*
    * ���̺� �� ������ �Ŀ�  �������� �߰� 
    
    ALTER TABLE ���̺�� �����ҳ���;
    
    - PRIMARY KEY : ALTER TABLE ���̺�� ADD PRIMARY KEY(�÷���);
    - FOREIGN KEY : ALTER TABLE ���̺�� ADD FOREIGN KEY(�÷���) REFERENCES ���������̺��[(�������÷���)];
    - UNIQUE      : ALTER TABLE ���̺�� ADD UNIQUE(�÷���);
    - CHECK       : ALTER TABLE ���̺�� ADD CHECK(�÷����������ǽ�);
    - NOT NULL    : ALTER TABLE ���̺�� MODIFY �÷��� NOT NULL;
*/
-- EMPLOYEE_COPY ���̺� PRIMARY KEY �������� �߰� (EMP_ID)
ALTER TABLE EMPLOYEE_COPY ADD PRIMARY KEY(EMP_ID);

-- EMPLOYEE ���̺� DEPT_CODE�� �ܷ�Ű�������� �߰� (�����ϴ����̺�(�θ�) : DEPARTMENT(DEPT_ID))
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT;

-- EMPLOYEE ���̺� JOB_CODE�� �ܷ�Ű�������� �߰� (JOB ���̺� ����)
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;

-- DEPARTMENT ���̺� LOCATION_ID�� �ܷ�Ű�������� �߰� (LOCATION���̺� ����)
ALTER TABLE DEPARTMENT ADD FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION;

