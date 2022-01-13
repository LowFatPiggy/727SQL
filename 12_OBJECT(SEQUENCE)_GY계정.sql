/*
    < ������ SEQUENCE >
    �ڵ����� ��ȣ �������ִ� ��ü
    �������� ���������� �������� ������Ű�鼭 ����
    
    EX) ȸ����ȣ, �����ȣ, �Խñ۹�ȣ, .. 
*/

/*
    1. ������ ��ü ���� 
    
    [ǥ����]
    CREATE SEQUENCE �������� 
    [START WITH ���ۼ���]       --> ó�� �߻���ų ���۰� ���� (�⺻�� 1)
    [INCREMENT BY ����]        --> �󸶾� ������ų�� �� ���� (�⺻�� 1)
    [MAXVALUE ����]            --> �ִ밪 ���� (�⺻�� 9999999...)
    [MINVALUE ����]            --> �ּҰ� ���� (�⺻�� 1)
    [CYCLE|NOCYCLE]            --> �� ��ȯ ���� ���� (�⺻�� NOCYCLE)
    [NOCACHE|CACHE ����Ʈũ��]  --> ĳ�ø޸� �Ҵ� (�⺻�� CACHE 20)
    
    * ĳ�ø޸� : �̸� �߻��� ������ �����ؼ� �����صδ� ���� 
                  �Ź� ȣ��ɶ� ���� ���� ��ȣ�� �����ϴ°� �ƴ϶� 
                  ĳ�ø޸� ������ �̸� ������ ������ ������ ��� ���� (�ӵ� ���)
                  ������ �����Ǹ� => ĳ�ø޸𸮿� �̸� ����� �� ��ȣ���� ��� �Ҹ�
                  
    ���̺�� : TB_
    ���    : VW_
    �������� : SEQ_
    Ʈ���Ÿ� : TRG_
*/

CREATE SEQUENCE SEQ_TEST;

-- [����] ���� ������ �����ϰ� �ִ� ���������� ������ �������Ҷ� 
SELECT * FROM USER_SEQUENCES;

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

/*
    2. ������ ���
    
    ��������.CURRVAL : ���� �������� �� (���������� ���������� ����� NEXTVAL�� ��)
    ��������.NEXTVAL : ���������� �������� �������Ѽ� �߻��� �� 
                      ���� ������ ������ INCREMENT BY�� ��ŭ ������ ��
                      == ��������.CURRVAL + INCREMENT BY��
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
-- ����!) NEXTVAL�� �� �ѹ��� �������� �ʴ� �̻� CURRVAL �Ҽ� ����
-- ��? : CURRVAL�� ���������� ����� NEXTVAL�� ���� �����ؼ� �����ִ� �ӽð�

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- NEXTVAL ���� 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 300

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310

SELECT * FROM USER_SEQUENCES;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- ������ MAXVALUE���� �ʰ��߱� ������ ���� �߻�
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 310

/*
    3. ������ ���� ����
    
    ALTER SEQUENCE ��������
    [INCREMENT BY ����]        --> �󸶾� ������ų ���� �� ���� (�⺻�� 1)
    [MAXVALUE ����]            --> �ִ밪 ���� (�⺻�� 99999999...)
    [MINVALUE ����]            --> �ּҰ� ���� (�⺻�� 1)
    [CYCLE|NOCYCLE]            --> �� ��ȯ ���� ���� (�⺻�� NOCYCLE)
    [NOCACHE|CACHE ����Ʈũ��]  --> ĳ�ø޸� �Ҵ� (�⺻�� CACHE 20)
    
    * START WITH �� ����Ұ�!!
*/

ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310 + 10  => 320

-- 4. ������ ����
DROP SEQUENCE SEQ_EMPNO;

-----------------------------------------------------------------------

-- �����ȣ�� Ȱ���� ������ ����
CREATE SEQUENCE SEQ_EID
START WITH 400
NOCACHE;

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
        SEQ_EID.NEXTVAL
      , '��¯��'
      , '111111-1111111'
      , 'J7'
      , SYSDATE
      );
      
      
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
        SEQ_EID.NEXTVAL
      , '������'
      , '222222-2222222'
      , 'J6'
      , SYSDATE
      );
      
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
        SEQ_EID.NEXTVAL
      , ?
      , ?
      , ?
      , SYSDATE
      );
       
SELECT * FROM EMPLOYEE;