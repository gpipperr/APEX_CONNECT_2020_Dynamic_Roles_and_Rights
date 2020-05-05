 -- =====================
 -- Demo for dynamic use of APEX role concept
 -- Gunther Pippèrr 2020(C) 
 -- https://www.pipperr.de/dokuwiki/doku.php
 -- 
 -- APEX Connect 2020
 -- https://programm.doag.org/apex/2020/#/scheduledEvent/594982
 --
 -- =====================

--------------------------------------------------------
--  DDL for Table T_SEC_ELEMENT_ACCESS
--------------------------------------------------------
 
drop sequence T_SEC_ELEMENT_ACCESS_SEQ;

create sequence T_SEC_ELEMENT_ACCESS_SEQ start with 500 minvalue 500;

-- +====================================================+	

drop table T_SEC_ELEMENT_ACCESS;

create table T_SEC_ELEMENT_ACCESS (
     SEC_SK                         number(15) not null constraint T_SEC_ELEMENT_ACCESS_pk primary key
    ,PAGE_NAME                      varchar2(255)
    ,PAGE_ID                        number(15)
    ,ELEMENT_ID                     number
    ,ELEMENT_NAME                   varchar2(255)
	,ELEMENT_LABEL                  varchar2(255)
    ,ELEMENT_TYPE					varchar2(255)
	,ELEMEMT_STATIC_ID				varchar2(255)
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

create index IDX_T_SEC_ELEMENT_ACCESS_PAGE_ID on T_SEC_ELEMENT_ACCESS(PAGE_ID);
create index IDX_T_SEC_ELEMENT_ACCESS_MENUE_ID on T_SEC_ELEMENT_ACCESS(ELEMENT_ID,ELEMENT_TYPE);

-- +====================================================+	
COMMENT ON TABLE T_SEC_ELEMENT_ACCESS         is 'Role you need to access this APEX element';

COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.SEC_SK                is 'Primary Key';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.PAGE_ID               is 'APEX PAGE ID';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.PAGE_NAME             is 'APEX PAGE Name';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.ELEMENT_ID            is 'APEX Element ID on this Page';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.ELEMENT_NAME          is 'APEX Element Name';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.ELEMENT_TYPE          is 'APEX Type of Element';
--- Roles
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.OPERATOR_READONLY     is 'OPERATOR_READONLY ROLE needed for this page';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.OPERATOR              is 'OPERATOR ROLE needed for this page';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.OPERATOR_SENIOR       is 'OPERATOR_SENIOR ROLE needed for this page';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.ANALYST               is 'ANALYST ROLE needed for this page';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.ANALYST_SENIOR        is 'ANALYST_SENIOR ROLE needed for this page';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.USER_ADMIN            is 'USER_ADMIN ROLE needed for this page';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.ADMINISTRATOR         is 'ADMINISTRATOR ROLE needed for this page';
COMMENT ON COLUMN T_SEC_ELEMENT_ACCESS.DEVELOPPER            is 'DEVELOPPER ROLE needed for this page';
