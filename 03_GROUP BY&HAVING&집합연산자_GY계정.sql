/*
     < GROUP BY >
     �׷������ ������ �� �ִ� ���� (�ش� �׷���غ��� ���� �׷����� ���� ����)
     �������� ������ �ϳ��� �׷����� ��� ó���� �������� ���
*/

SELECT SUM(SALARY)
FROM EMPLOYEE; --> ��ü ����� �ϳ��� �׷����� ��� ������ ���� ���

-- �� �μ��� �� �޿���
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- �� �μ��� ��� ��
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- ���� ����
SELECT DEPT_CODE, SUM(SALARY)  -- 3
FROM EMPLOYEE       -- 1
GROUP BY DEPT_CODE  -- 2
ORDER BY DEPT_CODE; -- 4

-- �� ���޺� �ѻ����, ���ʽ����޴»����, �޿���, ��ձ޿�, �����޿�, �ְ�޿�
SELECT DEPT_CODE, COUNT(*) "�ѻ����", COUNT(BONUS) "���ʽ����޴»����", 
       SUM(SALARY) "�޿���", FLOOR(AVG(SALARY)) "��ձ޿�",
       MIN(SALARY) "�����޿�", MAX(SALARY) "�ִ�޿�"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

-- GROUP BY���� �Լ��� ��� ����
SELECT DECODE( SUBSTR(EMP_NO, 8, 1), '1', '��', '2', '��' ), COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);


----------------------------------------------------------------------

/*
    < HAVING >
    �׷쿡 ���� ������ ������ �� ���Ǵ� ����
    (�ַ� �׷��Լ������� ������ ������ �� ���)
    !) WHERE���� SELECT�� ���� ����
*/

-- �� �μ��� ��� �޿� ��ȸ
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE 
group by DEPT_CODE;

-- �μ��� ��ձ޿��� 300���� �̻��� �μ��鸸 ��ȸ
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
WHERE AVG(SALARY) >= 3000000
GROUP BY DEPT_CODE; -- ���� �߻� (�׷��Լ��� ���� ���� �� WHERE�������� X)

SELECT DEPT_CODE, ROUND(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

SELECT DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

----------------------------------------------------------------------

/*
    < SELECT�� ������� >
    5: SELECT    * | ��ȸ�ϰ����ϴ� �÷� AS ��Ī | ����� "��Ī" | �Լ��� AS "��Ī"
    1:   FROM    ��ȸ�ϰ����ϴ� ���̺�� 
    2:  WHERE    ���ǽ� (�����ڵ� ������ ���)
    3:  GROUP BY �׷�������� ���� �÷� | �Լ���
    4: HAVING    ���ǽ� (�׷��Լ��� ������ ���)
    6:  ORDER BY �÷�|��Ī|�÷����� [ASC|DESC] [NULLS FIRST|NULLS LAST]
*/


----------------------------------------------------------------------

/*
    < ���� �Լ� > 
    �׷캰 ����� ��� ���� �߰����踦 ���
    
    ROLLUP, CUBE
    
    => GROUP BY ���� ����ϴ� �Լ�
*/
-- �� ���޺� �޿���
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- ������ ������ ��ü �� �޿��ձ��� ���� ��ȸ�ϰ��� �� �� 
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY JOB_CODE;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY JOB_CODE;

-- �׷������ �÷��� �ϳ��� ���� CUBE, ROLLUP�� �������� ���� ����
-- �� �������� ������ �Ѵٸ� �׷������ �÷��� �ΰ��� �־�ߵ�!!

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE;

-- ROLLUP(�÷�1, �÷�2) : �÷�1 �������� �߰����踦 ���� �Լ� 
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

-- CUBE(�÷�1, �÷�2) : �÷�1 �������� �߰�����, �÷�2�� ��������
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;

----------------------------------------------------------------------

/*
    < ���� ������ == SET OPERATION >
    
    �������� �������� ������ �ϳ��� ���������� ����� ������ 
    
    - UNION     : OR | ������ (�� ������ ������ ��� ����� BUT �ߺ��� ������� �ѹ���)
    - INTERSECT : AND | ������ (�� �������� �ߺ��� �����)
    - UNION ALL : ������ + ������ (UNION�� �ٸ��� �ߺ��Ǵ� ������� �ߺ��Ǵ� ��ŭ)
    - MINUS     : ������ (���� ��������� ���� ������� �� ������)
*/


-- 1. UNION
-- �μ��ڵ尡 D5�� ��� �Ǵ� �޿��� 300���� �ʰ��� ����� ��ȸ (���, �̸�, �μ��ڵ�, �޿�)

-- �μ��ڵ尡 D5�� ����鸸 ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 6�� �� (�ڳ���, ������, ���ؼ�, "�ɺ���", ������, "���ȥ")

-- �޿��� 300���� �ʰ��� ����鸸 ��ȸ 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8�� �� (������, ������, ���ö, �����, ������, "�ɺ���", "���ȥ", ������)


SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' -- 6��
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8�� 
--> 12�� �� (�ߺ��� ��(2��) �ѹ���)

-- ���� ������ ��� �Ʒ�ó�� WHERE���� OR�ᵵ �ذᰡ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' OR SALARY > 3000000;


-- 2. INTERSECT (������)
-- �μ��ڵ尡 D5�̸鼭 �޿������� 300���� �ʰ��� ��� ��ȸ
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- �����ϰ� AND�� ����
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY > 3000000;

----------------------------------------------------------------------

-- ���տ����� ��� �� ���ǻ��� --
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- �� �������� SELECT���� �ۼ��Ǿ��ִ� �÷� ���� �����ؾ�.

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY "���ʽ��Ǵ±޿�"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, BONUS
FROM EMPLOYEE
WHERE SALARY > 3000000;

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE SALARY > 3000000;
-- �÷� ���� �Ӹ� �ƴ϶� �� �÷��ڸ����� ������ Ÿ������ ����ؾ�.

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' 
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000
ORDER BY EMP_NAME;
-- ORDER BY ���� ���̰��� �Ѵٸ� �������ٿ� ���

----------------------------------------------------------------------

-- 3. UNION ALL 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' -- 6��
UNION ALL
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8��
-- �ߺ��� ������ ��� ���ؼ� 14���� ����� 


-- 4. MINUS : ���� SELECT������� ���� SELECT����� �� ������ (������)
-- �μ��ڵ尡 D5�� ����� �� �޿��� 300���� �ʰ��� ����� �����ؼ� ��ȸ 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' 
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- AND�� �����ϰ� �ذᰡ��
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' AND SALARY <= 3000000;
