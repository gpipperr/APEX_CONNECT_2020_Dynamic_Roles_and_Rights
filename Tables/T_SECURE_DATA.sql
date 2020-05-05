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
--  DDL for Table T_SECURE_DATA_EXAMPLES
-- Sample data to show data driven security 
--------------------------------------------------------


drop sequence T_SECURE_DATA_EXAMPLES_SEQ;

create sequence T_SECURE_DATA_EXAMPLES_SEQ start with 1 minvalue 1;

-- +====================================================+	

drop table T_SECURE_DATA_EXAMPLES;

create table T_SECURE_DATA_EXAMPLES (
     SEC_SK                     number(15) not null constraint T_SECURE_DATA_EXAMP_PK primary key
    ,CUSTOMER                   varchar2(255)
    ,RABATT_LEVEL               number(15)
    ,EDITER_ROLE			    varchar2(255)
)
;



-- +====================================================+	
COMMENT ON TABLE T_SECURE_DATA_EXAMPLES         is 'Example Data Page for data driven Securtiy';

COMMENT ON COLUMN T_SECURE_DATA_EXAMPLES.SEC_SK                 is 'Primary Key';
COMMENT ON COLUMN T_SECURE_DATA_EXAMPLES.CUSTOMER               is 'DEMO Customer';
COMMENT ON COLUMN T_SECURE_DATA_EXAMPLES.RABATT_LEVEL           is 'Same importand data to secure';
COMMENT ON COLUMN T_SECURE_DATA_EXAMPLES.EDITER_ROLE            is 'Role you need to edit this item';


-- +====================================================+	

-- Example data


insert into T_SECURE_DATA_EXAMPLES(SEC_SK,CUSTOMER,RABATT_LEVEL,EDITER_ROLE) values (T_SECURE_DATA_EXAMPLES_SEQ.nextval,' Normale User A',0,'OPERATOR');
insert into T_SECURE_DATA_EXAMPLES(SEC_SK,CUSTOMER,RABATT_LEVEL,EDITER_ROLE) values (T_SECURE_DATA_EXAMPLES_SEQ.nextval,' Normale User B',0,'OPERATOR');
insert into T_SECURE_DATA_EXAMPLES(SEC_SK,CUSTOMER,RABATT_LEVEL,EDITER_ROLE) values (T_SECURE_DATA_EXAMPLES_SEQ.nextval,' Normale User C',0,'OPERATOR');
insert into T_SECURE_DATA_EXAMPLES(SEC_SK,CUSTOMER,RABATT_LEVEL,EDITER_ROLE) values (T_SECURE_DATA_EXAMPLES_SEQ.nextval,' VIP User A'    ,10,'ANALYST');
insert into T_SECURE_DATA_EXAMPLES(SEC_SK,CUSTOMER,RABATT_LEVEL,EDITER_ROLE) values (T_SECURE_DATA_EXAMPLES_SEQ.nextval,' VIP User B'    ,10,'ANALYST');
insert into T_SECURE_DATA_EXAMPLES(SEC_SK,CUSTOMER,RABATT_LEVEL,EDITER_ROLE) values (T_SECURE_DATA_EXAMPLES_SEQ.nextval,' VIP User C'    ,10,'ADMINISTRATOR');

commit;

