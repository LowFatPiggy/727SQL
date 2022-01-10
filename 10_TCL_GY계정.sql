/*
    < TCL : TRANSACTION CONTROL LANGUAGE >
    트랜잭션 제어 언어
    
    * 트랜잭션 (TRANSACTION)
    - 데이터베이스의 논리적 연산단위 
    - 데이터의 변경사항(DML)들을 하나의 트랜잭션에 묶어서 처리
      DML문 한개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리
                           트랜잭션이 존재하지 않으면 트랜잭션을 만들어서 묶음
      COMMIT 하기 전까지의 변경사항들을 하나의 트랜잭션에 담게됨 
    - 트랜잭션의 대상이 되는 SQL : INSERT, UPDATE, DELETE (DML)
    
    COMMIT (트랜잭션 종료 처리 후 확정)
    ROLLBACK (트랜잭션 취소)
    SAVEPOINT (임시저장)
    
    - COMMIT; 진행 : 한 트랜잭션에 담겨있는 변경사항들을 실제 DB에 반영시키겠다는 의미 (후에 트랜잭션은 사라짐)
    - ROLLBACK; 진행 : 한 트랜잭션에 담겨있는 변경사항들을 삭제(취소) 한 후 마지막 COMMIT시점으로 돌아감
    - SAVEPOINT 포인트명; 진행 : 현재 이 시점에 해당 포인트명으로 임시저장점을 정의해두는 거 
                               ROLLBACK 진행시 전체 변경사항들을 다 삭제하는게 아니라 일부만 롤백가능 
     
*/

SELECT * FROM EMP_01;

-- 사번이 900 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 900;

-- 사번이 901 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 901;

ROLLBACK;

-------------------------------------------------------------------------

-- 200번 사원 지우기
DELETE FROM EMP_01
WHERE EMP_ID = 200;

-- 800, 흰둥이, 총무부  사원 추가
INSERT INTO EMP_01
VALUES(800, '흰둥이', '총무부');

SELECT * FROM EMP_01;

COMMIT;

ROLLBACK;

-----------------------------------------------------------------------------

-- 217, 216, 214 사원 지움
DELETE FROM EMP_01
WHERE EMP_ID IN (217, 216, 214);

SAVEPOINT SP; -- 임시저장

-- 801, 신짱아, 인사관리부 사원 추가
INSERT INTO EMP_01
VALUES(801, '신짱아', '인사관리부');

-- 218 사원 지움
DELETE FROM EMP_01
WHERE EMP_ID = 218;

SELECT * FROM EMP_01;

ROLLBACK TO SP; -- 임시저장했던 시점까지로 롤백

COMMIT;

--------------------------------------------------------------------------------

-- 900, 901사원 지움
DELETE FROM EMP_01
WHERE EMP_ID IN (901, 900);

-- 218 사원 지움
DELETE FROM EMP_01
WHERE EMP_ID = 218;

SELECT * FROM EMP_01;

-- 주의!
-- 갑자기 튀어나온 DDL문
CREATE TABLE TEST(
    TID NUMBER
);

ROLLBACK; -- 아무리 롤백해도 롤백되지 않음

--> DDL문(CREATE, ALTER, DROP)을 수행하는 순간 기존에 트랜잭션에 있던 변경사항들을
--  무조건 COMMIT(실제 DB에 반영)
--  즉, DDL문 수행 전 변경사항들이 있었다면 정확히 픽스(COMMIT, ROLLBACK)하고 작업
