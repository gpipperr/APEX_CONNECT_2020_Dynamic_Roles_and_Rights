--------------------------------------------------------
--  DDL for Table T_SEC_PAGE_ACCESS
--------------------------------------------------------
--drop sequence T_SEC_PAGE_ACCESS_SEQ;

create sequence T_SEC_PAGE_ACCESS_SEQ start with 500 minvalue 500;;

-- +====================================================+	

--drop table T_SEC_PAGE_ACCESS;

create table T_SEC_PAGE_ACCESS (
     SEC_SK                         number(15) not null constraint t_sec_page_access_pk primary key
    ,PAGE_NAME                      varchar2(255)
    ,PAGE_ID                        number(15)
    ,MENUE_ID                       number
    ,MENU_NAME                      varchar2(255)
    ,OPERATOR_READONLY              varchar2(1) default 'N'
    ,OPERATOR                       varchar2(1) default 'N'
    ,OPERATOR_SENIOR                varchar2(1) default 'N'
    ,ANALYST                        varchar2(1) default 'N'
    ,ANALYST_SENIOR                 varchar2(1) default 'N'
    ,USER_ADMIN                     varchar2(1) default 'N'
    ,ADMINISTRATOR                  varchar2(1) default 'N'
    ,DEVELOPPER                     varchar2(1) default 'N'
)
;

create unique index IDX_T_SEC_PAGE_ACCESS_PAGE_ID on T_SEC_PAGE_ACCESS(PAGE_ID);
create index IDX_T_SEC_PAGE_ACCESS_MENUE_ID on T_SEC_PAGE_ACCESS(MENUE_ID);

-- +====================================================+	
COMMENT ON TABLE T_SEC_PAGE_ACCESS         is 'Role you need to access this page';

COMMENT ON COLUMN T_SEC_PAGE_ACCESS.SEC_SK                is 'Primary Key';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.PAGE_ID               is 'APEX PAGE ID';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.MENUE_ID              is 'APEX MENUE Entry for this Page';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.OPERATOR_READONLY     is 'OPERATOR_READONLY ROLE needed for this page';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.OPERATOR              is 'OPERATOR ROLE needed for this page';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.OPERATOR_SENIOR       is 'OPERATOR_SENIOR ROLE needed for this page';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.ANALYST               is 'ANALYST ROLE needed for this page';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.ANALYST_SENIOR        is 'ANALYST_SENIOR ROLE needed for this page';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.USER_ADMIN            is 'USER_ADMIN ROLE needed for this page';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.ADMINISTRATOR         is 'ADMINISTRATOR ROLE needed for this page';
COMMENT ON COLUMN T_SEC_PAGE_ACCESS.DEVELOPPER            is 'DEVELOPPER ROLE needed for this page';
