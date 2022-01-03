/*
    * �������� (SUBQUERY)
    - �ϳ��� SQL�� �ȿ� �� �ٸ� SELECT�� 
    - ���� SQL���� ���� ������ �ϴ� ������ 
*/

-- ���� �������� ���� 1. 
-- ��¯�� ����� ���� �μ��� ���� ����� ��ȸ

-- 1) ���� ��¯�� ����� �μ��ڵ� ��ȸ 
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '��¯��'; --> D9

-- 2) �μ��ڵ尡 D9�� ����� ��ȸ 
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--> ���� 2�ܰ踦 �ϳ��� ����������
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '��¯��');
                   
-- ���� �������� ����2
-- �� ������ ��� �޿����� ���� �޿��� �޴� ������� ���, �̸�, �����ڵ�, �޿� ��ȸ 

-- 1) �� ������ ��� �޿� ��ȸ
SELECT AVG(SALARY)
FROM EMPLOYEE; --> �� 3050000��

-- 2) �޿��� 3050000�� �̻��� ������� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3050000;

-- ���� 2�ܰ踦 �ϳ��� ����������
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                 FROM EMPLOYEE);

----------------------------------------------------------------------

/*
    * ���������� ����
      ���������� ������ ������� n�� n�������� ���� �з�
      
      - ������ �������� : ���������� ��ȸ ������� ������ 1���� �� (1�� 1��)
      - ������ �������� : ���������� ��ȸ ������� �������� �� (������ 1��)
      - ���߿� �������� : ���������� ��ȸ ������� �� �������� �÷��� �������� �� (1�� ������)
      - ������ ���߿� �������� : ���������� ��ȸ ������� ������ �����÷��� �� (������ ������)
      
      >> ���������� ������ ���� ������ ����� �޶��� 
*/


/*
    1. ������ �������� (SINGLE ROW SUBQUERY)
    ���������� ��ȸ ������� ������ 1���� �� (1�� 1��)
    �Ϲ� �񱳿����� ��밡��
    = != ^= > < >=, ... 
*/

-- 1) �� ������ ��ձ޿����� ���� �޴� ������� �����, �����ڵ�, �޿� ��ȸ
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE)
ORDER BY SALARY;

-- 2) ���� �޿��� �޴� ����� ���, �̸�, �޿�, �Ի��� ��ȸ 
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);

-- 3) ��¯�� ����� �޿����� �� ���� �޴� ������� ���, �̸�, �μ��ڵ�, �޿� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '��¯��');

-- >> ����Ŭ ���� ����             
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '��¯��')
  AND DEPT_CODE = DEPT_ID;
  
-- >> ANSI����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '��¯��');

-- 4) �μ��� �޿� ���� ���� ū �μ��� �μ��ڵ�, �޿� �� ��ȸ
-- 4_1) ���� ���� ū �μ��� �޿� �� ��ȸ
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 17700000��

-- 4_2) �μ��� �޿� ���� 17700000���� �μ� ��ȸ
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

-- ���� �� �ܰ踦 �ϳ��� ����������
SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);

-- ����������� ���� �μ������� ���, �����, ��ȭ��ȣ, �Ի���, �μ���
-- ��, �������� ���� 
-- >> ����Ŭ ����
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID 
  AND DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '������')
  AND EMP_NAME != '������';

-- >> ANSI����
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '������')
  AND EMP_NAME != '������';

----------------------------------------------------------------------

/*
    2. ������ �������� (MULTI ROW SUBQUERY)
    ���������� ������ ������� ���� ���� �� (�÷��� �ϳ�)
    
    - IN �������� : �������� ����� �߿��� �Ѱ��� ��ġ�ϴ� ���� �ִٸ� 
    
    - > ANY �������� : �������� ����� �߿��� '�� ����' Ŭ ��� (�������� ����� �߿��� ���� ������ ���� Ŭ ���)
    - < ANY �������� : �������� ����� �߿��� '�� ����' ���� ��� (�������� ����� �߿��� ���� ū �� ���� ���� ���)
    
        �񱳴�� > ANY (��1, ��2, ��3)
        �񱳴�� > ��1 OR �񱳴�� > ��2 OR �񱳴�� > ��3
    
    - > ALL �������� : �������� '���' ������� ���� Ŭ ��� 
    - < ALL �������� : �������� '���' ������� ���� ���� ��� 
    
        �񱳴�� > ALL (��1, ��2, ��3)
        �񱳴�� > ��1 AND �񱳴�� > ��2 AND �񱳴�� > ��3
    
*/

-- 1) ��ö�� �Ǵ� ������ ����� ���� ������ ������� ���, �����, �����ڵ�, �޿� 
-- 1_1) ��ö�� �Ǵ� ������ ����� � �������� ��ȸ
SELECT JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME IN ('��ö��', '������');  -- J3, J7

-- 1_2) J3, J7 ������ ����� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN ('J3', 'J7');

-- ���� �� �ܰ踦 �ϳ��� ������
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('��ö��', '������'));

-- ��� => �븮 => ���� => ���� => ���� ...
-- 2) �븮 �����ε� ���� ���� �ּ� �޿����� ���� �޴� ���� ��ȸ (���, �̸�, ����, �޿�)
-- 2_1) ���� ���� ������ ������� �޿� ��ȸ 
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '����'; -- 2200000, 2500000, 3760000

-- 2_2) ������ �븮�̸鼭 �޿����� ���� ��ϵ� �� �߿� �ϳ��� ū ���
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮' 
  AND SALARY > ANY (2200000, 2500000, 3760000);

-- ���� �� �ܰ踦 �ϳ��� ����������
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮' 
  AND SALARY > ANY (SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '����');

--> ������ ���������ε� ����! 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '�븮' 
  AND SALARY > (SELECT MIN(SALARY)
                FROM EMPLOYEE
                JOIN JOB USING(JOB_CODE)
                WHERE JOB_NAME = '����');
                
-- 3) ���� �����ε� ���������� ������� ��� �޿����ٵ� �� ���� �޴� ��� ��ȸ
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '����'
  AND SALARY > ALL (SELECT SALARY
                    FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME = '����');

----------------------------------------------------------------------

/*
    3. ���߿� �������� 
    ������� ���������� ������ �÷����� �������� ��� 
*/
-- 1) ������ ����� ���� �μ��ڵ�, ���� �����ڵ忡 �ش��ϴ� ����� ��ȸ
-- >> ������ ���������ε� ����
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '�Ѽ���') -- D5
  AND JOB_CODE = (SELECT JOB_CODE
                  FROM EMPLOYEE
                  WHERE EMP_NAME = '�Ѽ���'); -- J5 

-- >> ���߿� ����������
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME = '�Ѽ���');

-- ��¯�� ����� ���� �����ڵ�, ���� ����� ������ �ִ� ������� ���, �����, �����ڵ�, ������ ��ȸ 
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE
WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME = '��¯��');

----------------------------------------------------------------------

/*
    4. ������ ���߿� ��������
    �������� ��ȸ ������� ������ �������� ��� 
*/
-- 1) �� ���޺� �ּұ޿��� �޴� ��� ��ȸ
-->> �� ���޺� �ּұ޿� ��ȸ
SELECT JOB_CODE, MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' AND SALARY = 3700000
   OR JOB_CODE = 'J7' AND SALARY = 1380000
   OR JOB_CODE = 'J3' AND SALARY = 3400000
   ....;

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) = ('J2', 3700000)
   OR (JOB_CODE, SALARY) = ('J7', 1380000)
   OR (JOB_CODE, SALARY) = ('J3', 3400000)
   ... ;

-- ���������� ���� 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE);

-- 2) �� �μ��� �ְ�޿��� �޴� ������� ���, �����, �μ��ڵ�, �޿� 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY)
                              FROM EMPLOYEE
                              GROUP BY DEPT_CODE);

----------------------------------------------------------------------

/*
    5. �ζ��� �� (INLINE-VIEW)
    FROM ���� ���������� �ۼ��� �� 
    
    ���������� ������ ����� ���̺�ó�� ���
*/

-- ������� ���, �̸�, ���ʽ����Կ���, �μ��ڵ� ��ȸ    => ���ʽ����Կ��� NULL X
-- ��, ���ʽ����Կ����� 3000�����̻��� ����鸸 ��ȸ 
SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 "����", DEPT_CODE
FROM EMPLOYEE
WHERE (SALARY + SALARY * NVL(BONUS, 0)) * 12 >= 30000000; --WHERE���� ��Ī ��� X


SELECT *
FROM (SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 "����", DEPT_CODE
      FROM EMPLOYEE)
WHERE ���� >= 30000000;

SELECT EMP_NAME, DEPT_CODE, ����
FROM (SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 "����", DEPT_CODE
      FROM EMPLOYEE)
WHERE ���� >= 30000000;

-- >> �ζ��� �並 �ַ� ����ϴ� �� => TOP-N�м�

-- �� ���� �� �޿��� ���� ���� ���� 5�� ��ȸ 
-- * ROWNUM : ����Ŭ���� �������ִ� �÷� , ��ȸ�� ������� 1���� ������ �ο����ִ� �÷� 
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;
-- ������� FROM --> SELECT ROWNUM (�̶� ���� �ο� == ���ĵ� �ϱ� ���� �̹� ���� �ο�)

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5
ORDER BY SALARY DESC;
-- �������� ��ȸX

-- => ORDER BY���� �� ����� ����� ROWNUM�ο� �� 5�� ��ȸ 
SELECT ROWNUM, E.*
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
      FROM EMPLOYEE
      ORDER BY SALARY DESC) E
WHERE ROWNUM <= 5;

-- ���� �ֱٿ� �Ի��� ��� 5�� ��ȸ  (�����, �޿�, �Ի���)
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM (SELECT *
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

-- �� �μ��� ��ձ޿��� ���� 3���� �μ� ��ȸ 
SELECT DEPT_CODE, FLOOR(��ձ޿�)
FROM (SELECT DEPT_CODE, AVG(SALARY) "��ձ޿�"
      FROM EMPLOYEE
      GROUP BY DEPT_CODE
      ORDER BY 2 DESC)
WHERE ROWNUM <= 3;

----------------------------------------------------------------------

/*
    * ���� ��� �Լ� (WINDOW FUNCTION)
    RANK() OVER(���ı���)   |   DENSE_RANK() OVER(���ı���)
    
    - RANK() OVER(���ı���) : ���� ���� ������ ����� ���� ������ŭ �ǳʶٰ� ���� �ο�
                             EX) ���� 1���� 2���̸� �� ���� ������ 3��
    - DENSE_RANK() OVER(���ı���) : ���� ���� �־ �پ�����ʰ� ���� �ο�
                                   EX) ���� 1���� 2���̴��� �� ���� ������ 2�� 
    
    >> SELECT�������� ��� ����
*/

-- �޿��� ���� ����� ���� �ο�
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "����"
FROM EMPLOYEE;
--> ���� 19�� 2�� �� ���� ������ 21�� 

SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "����"
FROM EMPLOYEE;
--> ���� 19�� 2�� �� ���� ������ 20�� 

--> ���� 5�� ��ȸ 
SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "����"
FROM EMPLOYEE
--WHERE ���� <= 5;
WHERE RANK() OVER(ORDER BY SALARY DESC) <= 5; -- ������! (WHERE���� ��� ����)

-->> �ζ��κ並 ���� �ۿ� ����!!
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "����"
        FROM EMPLOYEE)
WHERE ���� <= 5;