-- 한 줄 주석
/*
    여러줄
    주석
*/

SELECT * FROM DBA_USERS; -- 현재 모든 계정들에 대해 조회하는 명령문

-- 일반 사용자계정 생성하는 구문 (오직 관리자 계정에서만 가능)
-- [표현법] CREATE USER 계정명 IDENFIED BY 비밀번호;
CREATE USER kh IDENTIFIED BY kh;

-- 생성 후 일반 사용자계정에게 최소한의 권한(데이터관리, 접속) 부여
-- [표현법] GRANT 권한1, 권한2, .. TO 계정명;
GRANT RESOURCE, CONNECT TO KH; -- 계정명은 대소문자 가리지 않음

