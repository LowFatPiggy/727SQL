/*
    < �Լ� FUNCTION >
    ���޵� �÷����� �о�鿩�� �Լ��� ������ ��� ��ȯ
    
    - ������ �Լ� : N���� ���� �о�鿩�� N���� ������� ���� (�� �ึ�� �Լ� ���� ��� ��ȯ)
    - �׷� �Լ� : N���� ���� �о�鿩�� 1���� ������� ���� (�׷��� ���� �׷캰�� �Լ� ���� ��� ��ȯ)
    
    >> SELECT ���� ������ �Լ��� �׷��Լ��� �Բ� ��� X
       ��? ��� ���� ������ �ٸ��� ����
       
    >> �Լ����� ����� �� �ִ� ��ġ : SELECT��, WHERE��, ORDER BY��, GROUP��, HAVING��
*/



--========================== < ������ �Լ� > ==========================
/*
    < ���� ó�� �Լ� >
    
    * LENGTH / LENGTHB      => ����� NUMBERŸ��
    
    LENGTH(�÷�|'���ڿ���') : �ش� ���ڿ����� ���ڼ� ��ȯ
    LENGTHB(�÷�|'���ڿ���') : �ش� ���ڿ����� ����Ʈ�� ��ȯ
    
    '��' '��' '��'       �� ���ڴ� 3BYTE
    ������, ����, Ư������ �� ���ڴ� 1BYTE
*/

SELECT LENGTH('����Ŭ'), LENGTHB('����Ŭ')
FROM DUAL; -- �������̺�

SELECT LENGTH('ORACLE'), LENGTHB('ORACLE')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME), 
       EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
FROM employee;



/*
    * INSTR
    ���ڿ��κ��� Ư�� ������ ������ġ�� ã�Ƽ� ��ȯ
    
    INSTR(�÷�|'���ڿ���', 'ã�����ϴ¹���', [ã����ġ�ǽ��۰�, [����]]) => ����� NUMBERŸ��
    
    ã�� ��ġ�� ���۰�
    1 : �տ������� 
    -1 : �ڿ�������
*/

SELECT INSTR('AABAACAABBAA', 'B') -- ã����ġ�ǽ��� �⺻�� 1, ���� �⺻�� 1
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1)
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', -1) -- ���� �⺻�� 1
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', 1, 2)
FROM DUAL;

SELECT INSTR('AABAACAABBAA', 'B', -1, 3)
FROM DUAL;


SELECT EMAIL, INSTR(EMAIL, '_', 1, 1) "_��ġ", INSTR(EMAIL, '@') "@��ġ"
FROM employee;


----------------------------------------------------------------------

/*
    * SUBSTR
    ���ڿ����� Ư�� ���ڿ��� �����ؼ� ��ȯ (�ڹٿ��� substring()�޼ҵ�� ����)
    
    SUBSTR(STRING, POSITION, LENGTH)    => ����� CHARACTERŸ��
    - STRING : ����Ÿ���÷� OR '���ڿ���'
    - POSITION : ���ڿ��� ������ ������ġ��
    - LENGTH : ������ ���� ���� (���� �� ������ �ǹ�)
*/

SELECT SUBSTR('KAHLUAMILK', 4) FROM DUAL;
SELECT SUBSTR('KAHLUAMILK', 5, 2) FROM DUAL;
SELECT SUBSTR('KAHLUAMILK', 1, 6) FROM DUAL;
SELECT SUBSTR('KAHLUAMILK', -8, 3) FROM DUAL;

SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) "����"
FROM employee;

-- ��������鸸 ��ȸ
SELECT EMP_NAME
FROM employee
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

SELECT EMP_NAME
FROM employee
WHERE SUBSTR(EMP_NO, 8, 1) IN (2, 4) -- ���ڿ��� �ǹ��ϴ� ''�� ���� ���X = �ڵ�����ȯ
ORDER BY 1;


-- �Լ� ��ø ���
-- �̸����� �������� �� ���̵� ����
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) "���̵�"
FROM employee;



----------------------------------------------------------------------

/*
    * LPAD / RPAD
    ���ڿ��� ��ȸ�� �� ���ϰ��ְ� ��ȸ�ϰ��� �� �� ���
    
    LPAD / RPAD(STRING, ���������ι�ȯ�ҹ����Ǳ���, [�����̰����ϴ¹���])   
    => ������� CHARACTERŸ��
    
    ���ڿ��� �����̰����ϴ� ���ڸ� ��,�����ʿ� ���ٿ��� ���� N���̸�ŭ ���ڿ� ��ȯ
*/

SELECT EMP_NAME, LPAD(EMAIL, 20) -- �����̰��� �ϴ� ���� ���� �� ������ �⺻��
FROM employee;
-- 20��ŭ�� �ڸ��� �����ǰ� ������ ������ �κ� �����ڸ��� �������� ä����

SELECT EMP_NAME, LPAD(EMAIL, 20, '#') 
FROM employee;

-- �ֹι�ȣ ���� ���ڸ� *�� ������
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;

SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******'
FROM employee;

----------------------------------------------------------------------


/*
    * LTRIM / RTRIM
    ���ڿ����� Ư�� ���ڸ� ������ �������� ��ȯ
    
    LTRIM/RTRIM(STRING, [�����ϰ����ϴ¹��ڵ�])   => ����� CHARACTERŸ��
*/

SELECT LTRIM('   BIS COTTI   ') FROM DUAL; -- ������ ������ ����X
SELECT LTRIM('123123BISCOTTI123', '123') FROM DUAL;
-- �ش� ���ڿ��� �ƴ� ���ڿ��� ������ �Ǹ� �۾��� ������ ��ȯ
SELECT RTRIM('4561BISCOTTI4848', '0123456789') FROM DUAL;

/*
    * TRIM
    ���ڿ��� ��/��/���ʿ� �ִ� ������ ���ڵ��� ������ ������ ���ڿ� ��ȯ
    
    TRIM([LEADING|TRAILING|BOTH] �����ϰ����ϴ¹��ڵ� FROM] STRING)
*/

-- �⺻�� : ���ʿ� �ִ� ���ڵ� ����
SELECT TRIM('   BIS COTTI  ') FROM DUAL;
SELECT TRIM('Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL; -- LTRIM
SELECT TRIM(TRAILING 'Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL; -- RTRIM
SELECT TRIM(BOTH 'Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL; -- BOTH ��������
SELECT TRIM('Z' FROM 'ZZZBISCOTTIZZZ') FROM DUAL;

/*
    * LOWER / UPPER /INITCAP
    
    LOWER/UPPER/INITCAP(STRING)     => ����� CHARACTERŸ��
    
    LOWER : �ҹ��ڷ� ������ ���ڿ� ��ȯ (�ڹٿ����� toLowerCase()�޼ҵ� ����)
    UPPER : �빮�ڷ� ������ ���ڿ� ��ȯ (�ڹٿ����� toUpperCase()�޼ҵ� ����)
    INITCAP : �ܾ� �ձ��ڸ��� �빮�ڷ� ������ ���ڿ� ��ȯ
*/

SELECT LOWER('Butterbar Please') FROM DUAL;
SELECT UPPER('Butterbar Please') FROM DUAL;
SELECT INITCAP('butterbar please') FROM DUAL;


----------------------------------------------------------------------

/*
    * CONCAT
    ���ڿ� �� �� ���޹޾� �ϳ��� ��ģ �� ��� ��ȯ
    
    CONCAT(STRING, STRING)      => ����� CHARACTERŸ��
*/

SELECT CONCAT('Earl Grey ', 'Choco Cake') FROM DUAL; -- ���� �̻��� X
SELECT 'Earl Grey ' || 'Choco Cake' FROM DUAL;


----------------------------------------------------------------------

/*
    * REPLACE
    Ư�� ����(��)�� ������ ����(��)�� ���� �� ��ȯ
    
    REPLACE(STRING, STR1, STR2)     => ����� CHARACTERŸ��
*/

SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'kh.or.kr', 'gmail.com')
FROM EMPLOYEE;


--====================================================================

/*
    < ���� ó�� �Լ� >
    
    * ABS
    ������ ���밪�� �����ִ� �Լ�
    
    ABS(NUMBER)     => ����� NUMBERŸ��
*/

SELECT ABS(-10) FROM DUAL;
SELECT ABS(-5.3) FROM DUAL;


----------------------------------------------------------------------

/*
    * MOD
    �� ���� ���� ���������� ��ȯ
    
    MOD(NUMBER, NUMBER)     => ����� NUMBER
*/

SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.5, 3) FROM DUAL; -- �Ǽ����� ����


----------------------------------------------------------------------

/*
    * ROUND
    �ݿø��� ����� ��ȯ
    
    ROUND(NUMBER, [��ġ])     => ����� NUMBERŸ��
         123.456
       -2-10.123 = ��ġ
*/

SELECT ROUND(123.456) FROM DUAL; -- ��ġ ������ �⺻�� 0
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;


----------------------------------------------------------------------

/*
    * CEIL
    �ø�ó��
    
    CEIL(NUMBER)
    ��ġ ���� �Ұ�, ����� �����θ� ��ȯ
*/
SELECT CEIL(365.247) FROM DUAL;


----------------------------------------------------------------------

/*
    * FLOOR
    �Ҽ��� �Ʒ� ��� ����ó��
    
    FLOOR(NUMBER)
    ��ġ ���� �Ұ�, ����� �����θ� ��ȯ
*/
SELECT FLOOR(365.947) FROM DUAL;


----------------------------------------------------------------------

/*
    * TRUNC
    ��ġ ���� ������ ����ó��
    
    TRUNC(NUMBER, [��ġ])
*/
SELECT TRUNC(365.247) FROM DUAL; -- �⺻�� �Ҽ�������
SELECT TRUNC(365.247, 1) FROM DUAL;
SELECT TRUNC(365.247, -1) FROM DUAL;


--====================================================================

/*
    < ��¥ ó�� �Լ� >
*/

-- * SYSDATE : �ý��� ��¥ �� �ð� ��ȯ (���� ��¥ �� �ð�)
SELECT SYSDATE FROM DUAL;


-- * MONTHS_BETWEEN(DATE1, DATE2) : �� ��¥ ������ ���� ��
-- >> ���������� (DATE1 - DATE2)/30OR31 �ð��� ���� => ������� NUMBERŸ��
SELECT EMP_NAME, HIRE_DATE, FLOOR(SYSDATE-HIRE_DATE)||'��' "�ٹ��ϼ�", 
       FLOOR(MONTHS_BETWEEN(SYSDATE,HIRE_DATE))||'����' "�ٹ�������"
FROM EMPLOYEE;


-- * ADD_MONTHS(DATE, NUMBER) : Ư�� ��¥�� �ش� ���ڸ�ŭ�� �������� ���� ��¥ ����
--   => ����� DATEŸ��
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;


-- * NEXT_DAY(DATE, ����(����|����)) : Ư����¥ ���Ŀ� ����� �ش� ������ ��¥ ��ȯ
--   => ����� DATEŸ��
SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), '�ݿ���') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), '��') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), '6') FROM DUAL;
-- 1: �Ͽ��� 2: ������, .. 6: �ݿ���, 7: �����

SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), 'FRIDAY') FROM DUAL; -- ����(KOREAN)
-- ����(KOP->ENG)
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(TRUNC(SYSDATE), 'FRIDAY') FROM DUAL; -- ����
-- ����(ENG->KOR)
ALTER SESSION SET NLS_LANGUAGE = KOREAN;


-- * LAST_DAY(DATE) : �ش� ���� ������ ��¥ ��ȯ
--   => ����� DATEŸ��
SELECT LAST_DAY(SYSDATE) FROM DUAL;


----------------------------------------------------------------------

/*
    * EXTRACT : ��¥ ����       => ����� NUMBERŸ��
    
    EXTRACT(YEAR FROM DATE) : �⵵ ����
    EXTRACT(MONTH FROM DATE) : �� ����
    EXTRACT(DAY FROM DATE) : �� ����
*/
SELECT EMP_NAME,
       EXTRACT(YEAR FROM HIRE_DATE) "�Ի�⵵",
       EXTRACT(MONTH FROM HIRE_DATE) "�Ի��",
       EXTRACT(DAY FROM HIRE_DATE) "�ϻ���"
FROM employee
ORDER BY �Ի�⵵ ASC;


--====================================================================

/*
    < ����ȯ �Լ� >
    
    * TO_CHAR : ���� Ÿ�� OR ��¥ Ÿ���� ���� ����Ÿ������ ��ȯ
    
    TO_CHAR(����|��¥, [����])        => ����� CHARACTERŸ��
*/

-- *����Ÿ�� => ����Ÿ��
SELECT TO_CHAR(1234) FROM DUAL; -- '1234'

SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 5ĭ ����Ȯ��, ����������, ��ĭ����
-- 9(��ĭ����) OR 0(��ĭ0)
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- ��ĭ 0
SELECT TO_CHAR(1234, 'L99999') FROM DUAL; -- ���� ������ ����(LOCAL) ȭ�����
SELECT TO_CHAR(1234, '$99999') FROM DUAL;

SELECT TO_CHAR(123456, 'L999,999') FROM DUAL;

-- *��¥Ÿ�� => ����Ÿ��
SELECT SYSDATE FROM DUAL; -- DATEŸ��
SELECT TO_CHAR(SYSDATE) FROM DUAL; -- CHARŸ��
SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL; -- PM/AM 24�ð�����
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'MON, YYYY') FROM DUAL;

-- �⵵ ����
SELECT TO_CHAR(SYSDATE, 'YYYY'),
       TO_CHAR(SYSDATE, 'YY'),
       TO_CHAR(SYSDATE, 'RRRR'),
       TO_CHAR(SYSDATE, 'RR'),
       TO_CHAR(SYSDATE, 'YEAR')
FROM DUAL;

-- �� ����
SELECT TO_CHAR(SYSDATE, 'MM'),
       TO_CHAR(SYSDATE, 'MON'),
       TO_CHAR(SYSDATE, 'MONTH'),
       TO_CHAR(SYSDATE, 'RM') -- �θ���ȣ
FROM DUAL;

-- �� ����
SELECT TO_CHAR(SYSDATE, 'DDD'), -- �� ���� ��ĥ°
       TO_CHAR(SYSDATE, 'DD'), -- �� ���� ��ĥ°
       TO_CHAR(SYSDATE, 'D') -- �� ���� ��ĥ°
FROM DUAL;

-- ���� ����
SELECT TO_CHAR(SYSDATE, 'DAY'),
       TO_CHAR(SYSDATE, 'DY')
FROM DUAL;


----------------------------------------------------------------------

/*
    * TO DATE : ����Ÿ�� OR ����Ÿ�� �����͸� ��¥Ÿ������ ��ȯ
    
    TO DATE(����|����, [����])        => ����� DATEŸ��
*/

SELECT TO_DATE(20210916) FROM DUAL; -- DATEŸ��
SELECT TO_DATE(210916) FROM DUAL;

SELECT TO_DATE(070101) FROM DUAL; -- ����
SELECT TO_DATE('070101') FROM DUAL;

SELECT TO_DATE('050505 143624', 'YYMMDD HH24MISS') FROM DUAL;

SELECT TO_DATE('210916', 'YYMMDD') FROM DUAL;
SELECT TO_DATE('951124', 'YYMMDD') FROM DUAL; -- 2095�� // YY : ���� ����� �ݿ�

SELECT TO_DATE('210916', 'RRMMDD') FROM DUAL; -- 2021��
SELECT TO_DATE('951124', 'RRMMDD') FROM DUAL; -- 1995�� 
-- // RR : �⵵�� 50�̸��� ��� ���缼�� �ݿ�, 50�̻��� ��� �������� �ݿ�


----------------------------------------------------------------------

/*
    * TO_NUMBER : ����Ÿ���� �����͸� ����Ÿ������ ��ȯ
    
    TO_NUMBER(����, [����])     => ����� NUMBERŸ��
*/
SELECT TO_NUMBER('0123456789') FROM DUAL;

SELECT '1000000' + '550000' FROM DUAL; -- ����Ŭ���� �ڵ�����ȯ O

SELECT '1,000,000' + '550,000' FROM DUAL; -- ����

SELECT TO_NUMBER('1,000,000', '9,999,999') + TO_NUMBER('550,000', '999,999') FROM DUAL;


--====================================================================

/*
    < NULL ó�� �Լ� >
*/

-- * NVL(�÷�, �ش��÷����� NULL�� ��� ��ȯ�� ��)
SELECT EMP_NAME, NVL(BONUS,0) -- ���ʽ��� NULL���� ��� 0���� �����
FROM EMPLOYEE;

-- NULL���� ���Ե� ������� ������� NULL��
SELECT EMP_NAME, (SALARY + SALARY * BONUS) *12
FROM EMPLOYEE;
-- �ذ�
SELECT EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) *12
FROM EMPLOYEE;

SELECT EMP_NAME, NVL(DEPT_CODE, '�μ� ����')
FROM employee;


-- * NVL2(�÷�, ��ȯ��1, ��ȯ��2)
--   �÷����� ������ ��� ��ȯ��1 ��ȯ, ����X ��ȯ��2 ��ȯ
SELECT EMP_NAME, BONUS, NVL2(BONUS, 0.7, 0.1)
FROM employee;

SELECT EMP_NAME, NVL2(DEPT_CODE, '�μ� ����', '�μ� ����')
FROM employee;

-- * NULLIF(�񱳴��1, �񱳴��2)
--   �� ���� ���� ��ġ�ϸ� NULL��ȯ, ��ġ���� X �񱳴��1�� ��ȯ
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL;


--====================================================================

/*
    < ���� �Լ� >

    * DECODE
    ���ϰ��� �ϴ� �÷�(��)�� ���ǽİ� ������ ����� ��ȯ
    (���ϰ����ϴ´��(�÷�|�������|�Լ���), �񱳰�1, �����1, �񱳰�2, �����2, ..., �����N)
    
    SWITCH(�񱳴��) {
    CASE �񱳰� 1:
    CASE �񱳰� 2:
    ...
    DEFAULT :
    }
*/
-- ���, �����, �ֹι�ȣ, ����
SELECT EMP_ID, EMP_NAME, EMP_NO, DECODE(SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��')"����"
FROM employee;

-- �μ����� �λ��ؼ� ��ȸ (J7�μ� 10%, J6 15%, J5 20%, �� �� 5%)
SELECT EMP_NAME, JOB_CODE, SALARY,
       DECODE(JOB_CODE, 'J7', SALARY * 1.1, 
                        'J6', SALARY * 1.15,
                        'J5', SALARY * 1.2, 
                              SALARY * 1.05)
FROM employee;


----------------------------------------------------------------------

/*
    * CASE WHEN THEN
    
    CASE WHEN ���ǽ�1 THEN �����1
         WHEN ���ǽ�2 THEN �����2
         ...
         ELSE �����N
    END
    
    �ڹٿ����� IF-ELSE IF��
*/

SELECT EMP_NAME, SALARY,
       CASE WHEN SALARY >= 5000000 THEN '���'
            WHEN SALARY >= 3500000 THEN '�߱�'
            ELSE '�ʱ�'
       END "���"
FROM employee;



--========================== < �׷� �Լ� > =============================

-- 1. SUM(����Ÿ���÷�) : �ش� �÷������� �� �հ� ��ȯ
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- �μ��ڵ尡 D5�� ������� �� ���� ��
SELECT SUM(SALARY*12)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';


-- 2. AGC(����Ÿ��) : �ش� �÷������� ��հ� ��ȯ
SELECT ROUND(AVG(SALARY)) -- �ݿø� ó��
FROM EMPLOYEE;


-- 3. MIN(ANYŸ��) : �ش� �÷������� ���� ���� �� ��ȯ
SELECT MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE)
FROM EMPLOYEE;


-- 4. MAX(ANYŸ��) : �ش� �÷������� ���� ū �� ��ȯ
SELECT MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE)
FROM EMPLOYEE;


-- 5. COUNT(*|�÷�|DISTINCT �÷� : �� ���� ��ȯ
--    COUNT(*) : ��ȸ�� ����� ��� �� ���� ��ȯ
--    CONNT(�÷�) : ������ �ش� �÷����� NULL�� �ƴ� �� ���� ��ȯ
--    COUNT(DISTINCT �÷�) : �ش� �÷��� �ߺ��� ������ �� ���� ��ȯ

-- ��ü ��� ��
SELECT COUNT(*)
FROM EMPLOYEE;

-- �μ� ��ġ�� ���� ��� ��
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE;

-- ������� �ش��� �μ� ���� ��ȸ
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;

