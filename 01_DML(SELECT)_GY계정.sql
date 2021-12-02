/*
    < SELECT >
    ������ ��ȸ�� �� �ʿ��� ����
    
    >> RESULT SET : SELECT���� ���� ��ȸ�� ����� (��, ��ȸ�� ����� ����)
    
    [ǥ����]
    SELECT ��ȸ�ϰ����ϴ��÷�, �÷�, .. 
    FROM ���̺��; 
    // (�÷��� �ݵ�� �ش� ���̺� �����ؾ� ��)
*/

-- EMPLOYEE ���̺� ��� �÷�(*) ��ȸ
SELECT
    * FROM employee;
    
-- EMPLOYEE ���̺� ���, �̸�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY 
FROM employee;

-- JOB ���̺� ��� �÷�(*) ��ȸ
SELECT
    * FROM JOB;
    

-- 1. JOB ���̺� ���޸� �÷��� ��ȸ
SELECT JOB_NAME 
FROM JOB;

-- 2. DEPARTMENT ���̺��� ��� �÷� ��ȸ
SELECT 
    * FROM DEPARTMENT;

-- 3. DEPARTMENT ���̺� �μ��ڵ�, �μ��� ��ȸ
SELECT DEPT_ID, DEPT_TITLE
FROM department;


-------------------------------------------------------------

/*
    < �÷����� ���� ������� >
    SELECT �� �÷��� �ۼ��κп� ������� ��� ���� (�̶� �������� ��� ��ȸ)
*/

-- EMPLOYEE ���̺��� �����, ����� '����'(�޿�*12) ��ȸ
SELECT EMP_NAME, SALARY * 12
FROM employee;

-- EMPLOYEE�� �����, �޿�, ���ʽ�, ����, ���ʽ����Եȿ���(�޿�+���ʽ�*�޿�)*12) ��ȸ
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12, (SALARY + BONUS * SALARY) * 12
FROM employee;
-- // ������� ��, NULL���� ���Ե� ��쿡 ����� NULL��

-- EMPLOYEE�� �����, �Ի���, �ٹ��ϼ�(���ó�¥ - �Ի���) ��ȸ
-- DATE���ĳ����� ���� ����. *���� ��¥ : SYSDATE
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE
FROM employee;
-- DATE - DATE : ������� �� ������ ������ ��/��/�� �ð����������� ����

-- ���� �ý��� ��¥ �� �ð� ��ȸ
SELECT SYSDATE
FROM DUAL; -- ����Ŭ���� �����ϴ� �������̺�(�������̺�)
-- ���� ���̺������ ������ ���� ���� ��� �������̺� ���
-- ��/��/�� ��µ����� ��/��/�ʱ��� ����


-------------------------------------------------------------

/*
    < �÷��� ��Ī �����ϱ� >
    �÷��� ��Ī�� �ο��� ����� ����ϰ� ���µ� ����

    [ǥ����]
    �÷��� ��Ī / �÷��� AS ��Ī / �÷��� "��Ī" / �÷��� AS "��Ī"
    // ��Ī�� ���� OR Ư�����ڰ� ���Ե� ��� �ݵ�� ���������̼�("")�� ���
*/

SELECT EMP_NAME �����, SALARY AS �޿�, SALARY*12 "����(��)", (SALARY+BONUS*SALARY)*12 AS "�� �ҵ�"
FROM employee;


-------------------------------------------------------------

/*
    < ���ͷ� >
    ���Ƿ� ������ ���ڿ�
    
    SELECT���� ���ͷ��� �����ϸ� ��ġ ���̺�� �����ϴ� ������ó�� ��ȸ ����
    ��ȸ�� RESULT SET�� ��� �࿡ �ݺ������� ���
*/

-- EMPLOYEE�� ���, �����, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, SALARY, '��' AS ����
FROM employee;



/*
    < ���� ������ : || >
    ���� �÷������� �ϳ��� �÷��� ��ó�� �����ϰų�, �÷����� ���ͷ��� ����
    System.out.println("num" + num); ����� �ƶ�
*/

-- ���, �̸�, �޿��� �ϳ��� Į������ ��ȸ
SELECT EMP_ID || EMP_NAME || SALARY
FROM employee;

-- �÷����� ���ͷ� ����
-- XXX���� ������ XXX�� �Դϴ�.
SELECT EMP_NAME || '���� ������ ' || SALARY || '�� �Դϴ�.' "�޿� ����"
FROM employee;


-------------------------------------------------------------

/*
    < DISTINCT >
    �÷��� �ߺ��� ������ �� ������ ǥ���ϰ��� �� ��
*/

-- EMPLOYEE �����ڵ� ��ȸ
SELECT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE �����ڵ�(�ߺ�����) ��ȸ
SELECT DISTINCT JOB_CODE
FROM employee;

-- EMPLOYEE �μ��ڵ� (�ߺ�����) ��ȸ
SELECT DISTINCT DEPT_CODE
FROM employee;

-- ���ǻ��� : DISTINCT�� SELECT���� �� �ѹ� ��� ����
/*
SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE
FROM EMPLOYEE;
*/


SELECT DISTINCT JOB_CODE, DEPT_CODE
FROM employee;
-- JOB_CODE, DEPT_CODE�� ��� �ߺ� �Ǻ�


/*
    <WHERE>��
    ��ȸ�ϰ��� �ϴ� ���̺�κ��� Ư�� ���ǿ� �����ϴ� �����͸��� ��ȸ�ϰ��� �� ���
    ���ǽĿ����� �پ��� ������ ��밡��
    
    [ǥ����]
    SELECT ��ȸ�ϰ����ϴ��÷�, �÷�, �������,...
    FROM ���̺��
    WHERE ���ǽ�;
    
    >> �� ������ <<
    >, <, >=, <=       --> ��Һ�(�ڹٿ� ����)
    =                  --> �����(�ڹٿ��� ==)
    !=, ^=, <>         --> �ٸ��� �� 
*/

-- EMPLOYEE���� �μ��ڵ尡 'D9'�� �ش� ��� ��� �÷� ��ȸ
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE���� �μ��ڵ尡 'D1'�� ������� �����, �޿�, �μ��ڵ常 ��ȸ
SELECT EMP_NAME, SALARY /*, DEPT_CODE*/
FROM employee
WHERE DEPT_CODE = 'D1';

-- �μ��ڵ尡 'D1'�� �ƴ� ������� ���, �����, �μ��ڵ� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM employee
WHERE DEPT_CODE != 'D1';

-- �޿��� 400���� �̻��� ������� �����, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-- EMPLOYEE���� ������ (ENT_YN �÷����� 'N'��) ������� ���, �̸�, �Ի��� ��ȸ
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM employee
WHERE ENT_YN = 'N';

SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY*12 "����"
FROM EMPLOYEE
WHERE SALARY >= 3000000;

SELECT EMP_NAME, SALARY, SALARY*12 "����", DEPT_CODE
FROM EMPLOYEE
WHERE SALARY*12 >= 50000000;
-- WHERE ���� >= 50000000; // WHERE�������� SELECT���� �ۼ��� ��Ī ���Ұ�
-- ���� ���� : FROM�� -> WHERE�� -> SELECT��

SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
FROM employee
WHERE JOB_CODE != 'J3';

/*
    < �� ������ >
    ���� ���� ������ ��� �����ϰ��� �� ��
    
    AND ~�̸鼭, �׸���
    OR ~�̰ų�, �Ǵ�
*/

-- �μ��ڵ尡 'D9'�̸鼭 �޿��� 500���� �̻��� ������� �����, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE <= 'D9' AND SALARY >= 5000000;

-- �μ��ڵ尡 'D6'�̰ų� �޿��� 300���� �̻��� ������� �����, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >= 30000000;

-- �޿� 350���� �̻� 600���� ����
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

/*
    < BETENNE AND >
    ���ǽĿ��� ���Ǵ� ����
    �� �̻� �� ������ ������ ���� ������ ������ �� ���
    
    [ǥ����]
    �񱳴���÷� BETWEEN ���Ѱ� AND ���Ѱ�
    // ���Ѱ� �̻��̰� ���Ѱ� ����
*/

SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000;

-- �޿� 350���� �̻� 600���� ���� �� ���� ���
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
-- WHERE SALARY < 3500000 OR SALARY > 6000000;
WHERE NOT SALARY /*NOT(�� �ڸ����� ����)*/ BETWEEN 3500000 AND 6000000;
-- !(�ڹ�;������������) NOT(����Ŭ;������������)

-- �Ի����� '90/01/01' ~ '01/01/01'
SELECT *
FROM employee
-- WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '01/01/01'; -- DATE���� ��Һ� ����
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';


-------------------------------------------------------------

/*
    < LIKE >
    ���ϰ����ϴ� �÷����� ������ Ư�� ���Ͽ� ������ ��� ��ȸ
    
    [ǥ����]
    �񱳴���÷� LIKE 'Ư������'
    
    - Ư������ ���ý� '%', '_'�� ���ϵ�ī��� ��밡��
    >> '%' : 0���� �̻�
    EX) �񱳴���÷� LIKE '����%'   => �񱳴���� �÷����� '���ڷ� ����'�Ǵ� �� ��ȸ
        �񱳴��Į�� LIKE '%����'   => �񱳴���� �÷����� '���ڷ� ��'���� �� ��ȸ
        �񱳴���÷� LIKE '%����%'  => �񱳴���� �÷����� '���ڰ� ����'�� �� ��ȸ (Ű���� �˻�)
        
    >> '_' : 1���� �̻�
    EX) �񱳴���÷� LIKE '_����'   => �񱳴���� �÷����� '���ھ� �ѱ��ڰ� ����'�� ��ȸ
        �񱳴��Į�� LIKE '__����'   => �񱳴���� �÷����� '���ھ� �α��ڰ� ����'�� ��ȸ
        �񱳴���÷� LIKE '_����_'  => �񱳴���� �÷����� '���ھհ� �ڿ� �ѱ��ھ� ����'�� ��ȸ
*/

-- ���� '��'���� ��� ��ȸ
SELECT *
FROM employee
WHERE EMP_NAME LIKE '��%';

-- �̸� �߿� '��'�� ���Ե� ��� ��ȸ
SELECT *
FROM employee
WHERE EMP_NAME LIKE '%��%';

-- �̸��� '��� ���ڰ� ��'�� ��� ��ȸ
SELECT *
FROM employee
WHERE EMP_NAME LIKE '_��_';

-- ��ȭ��ȣ '����° �ڸ��� 1'�� ��� ��ȸ
SELECT *
FROM employee
WHERE PHONE LIKE '__1%';

-- �̸��� �� '_���� �ձ��ڰ� 3����'�� ��� ��ȸ
SELECT *
FROM employee
WHERE EMAIL LIKE '____%';
-- ���ϵ�ī��� �����Ͱ��� ���е��� �ʾ� ���ϴ� ��� ����X
-- �����Ͱ����� ����ϰ��� �ϴ� �� �տ� ESCAPE OPTION���� ���ϵ�ī��� ���
SELECT *
FROM employee
WHERE EMAIL LIKE '___$_%' ESCAPE '$';
-- �� ���� ����� ��ȸ WHERE EMAIL NOT LIKE '___$_%' ESCAPE '$';


-------------------------------------------------------------

/*
    < IS NULL / IS NOT NULL >
    �÷����� NULL�� ���� ��� NULL�� �񱳿� ���Ǵ� ������
*/
-- ���ʽ��� ���� ��� ��ȸ
SELECT *
FROM employee
WHERE BONUS IS NULL;


-------------------------------------------------------------

/*
    < IN >
    �񱳴���÷����� ������ ��� �߿� ��ġ�ϴ� ���� �ִ��� 
    
    [ǥ����]
    �񱳴���÷� IN ('��1', '��2', '��3', ..)
*/

-- �μ��ڵ尡 D6�̰ų� D8�̰ų� D5�� �μ��� ��ȸ
SELECT *
FROM employee
WHERE dept_code IN ('D6', 'D8', 'D5'); 
-- // �� ���� ��� NOT IN


--===========================================================

/*
    < ������ �켱���� >
    0. ()
    1. ���������
    2. ���Ῥ����
    3. �񱳿�����
    4. IS NULL / LIKE 'Ư������' / IN
    5. BETWEEN AND
    6. NOT(��������)
    7. AND(��������)
    8. OR(��������)
*/

-- ** OR���� AND�� ���� ����
-- �����ڵ� 'J2'�� 'J7' ��� �� �޿��� 200���� �̻� ��� ��ȸ
SELECT * 
FROM employee
WHERE (JOB_CODE = 'J2' OR JOB_CODE = 'J7') AND SALARY >= 2000000;


-------------------------------------------------------------

-- ������ ���� ����
SELECT EMP_ID, EMP_NAME, SALARY -- 3
FROM EMPLOYEE -- 1
WHERE DEPT_CODE IS NULL; -- 2


--===========================================================

/*
    < ORDER BY �� >
    SELECT�� ���� ������ �ٿ� �ۼ� (���൵ ��������)
    
    [ǥ����]
    SELECT ��ȸ���÷�, �÷�, �������� AS "��Ī", ...
    FROM ��ȸ�ϰ����ϴ����̺��
    WHERE ���ǽ�
    ORDER BY ���ı������÷���|��Ī|�÷����� [ASC/DESC] [NULLS FIRST|NULLS LAST]
    
    - ASC : �������� ���� (���� �� �⺻ ��)
    - DESC : �������� ����
    
    - NULLS FIRST : �����ϰ��� �ϴ� �÷����� NULL�� ���� ��� �ش� �����͸� �� �� ��ġ
    - NULLS LAST : �����ϰ��� �ϴ� �÷����� NULL�� ���� ��� �ش� �����͸� �� �� ��ġ 
                  (���� �� ASC�϶��� �⺻��)
*/


SELECT *
FROM employee
-- ORDER BY BONUS; -- // ������������ , NULLS LAST
-- ORDER BY BONUS ASC; -- // �������� ������ �� NULLS LAST�� �⺻��
-- ORDER BY BONUS ASC NULLS FIRST; -- // NULLS FIRST, �������� ����
-- ORDER BY BONUS DESC; -- // �������� ������ �� NULLS FIRST�� �⺻��
ORDER BY BONUS DESC, SALART ASC; -- ���ʽ��� ��ġ�� �� �޿� ������������ ���� ���� O
-- ���� ������ ������ ���� ���� ( ù��° ������ �÷����� ������ ��� �ι�° ������ �÷����� ����)



-- �� ����� �����, ������ȸ (�� �� ������ �������� ���� ��ȸ)
SELECT EMP_NAME, SALARY *12 "����"
FROM employee
--ORDER BY SALARY*12 DESC;
--ORDER BY ���� DESC;  -- ��Ī ��� ����
ORDER BY 2 DESC;    -- �÷� ���� ��� ����


