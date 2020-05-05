CREATE OR REPLACE FUNCTION checkRowAccess( p_row_val VARCHAR2 
                                           ,p_sec_check VARCHAR2 
                                           ,p_security_scheme VARCHAR2 
                                           ,p_link_to VARCHAR
                                           ,p_link_item VARCHAR2
                                           ,p_session VARCHAR2
                                           ,p_app_id VARCHAR2) 
                                           
-- ================================
-- Function checkRowAccess
--
-- Protect a link in Report, only user with role xxx will see the link
-- see https://www.pipperr.de/dokuwiki/doku.php?id=prog:apex_authorization_scheme_protect_link
-- 
-- =================================

-- Use like this:

/*
SELECT
 -- generate the link text, switch off security for this row!
    checkRowAccess( dn.id             -- p_row_val 
               ,   dn.ADMIN_LOCK      -- ,p_sec_check 
               ,  'APEX_Admin'        -- ,p_security_scheme 
               ,  '332'               -- ,p_link_to 
               ,  'P332_ID'           -- ,p_link_item 
               ,  '&SESSION.'         -- ,p_session 
               ,  '&APP_ID.'          -- ,p_app_id 
               )
    AS LINK_TEXT 
....
-- show that the case can only accessed by privileged user
,CASE WHEN dn.ADMIN_LOCK = 1 THEN 'fa-lock fam-minus fam-is-danger' ELSE 'fa-unlock fam-blank fam-is-success' END AS ADMIN_LOCK
FROM my_table
WHERE
*/

 -- =====================
 -- Demo for dynamic use of APEX role concept
 -- Gunther Pippèrr 2020(C) 
 -- https://www.pipperr.de/dokuwiki/doku.php
 -- 
 -- APEX Connect 2020
 -- https://programm.doag.org/apex/2020/#/scheduledEvent/594982
 --
 -- =====================

RETURN VARCHAR2
IS
    v_return      VARCHAR2(8000);
    v_admin_user BOOLEAN:=FALSE;
    v_row_link   VARCHAR2(8000);
 
BEGIN
    -- create the link with the correct checksum
    v_row_link := '<a href="' 
                || APEX_UTIL.PREPARE_URL( p_url => 'f?p=' 
                || p_app_id 
                || ':'
                || p_link_to
                ||':'
                || p_session
                ||'::NO::'
                || p_link_item
                ||':'
                || p_row_val
                , p_checksum_type => 'SESSION') 
                || '"><img src="/i/menu/pencil2_16x16.gif"></a>';
 
   -- check if the data is protected ( if 1 only Admin can change the data!)
 
    IF p_sec_check = '1'  THEN
        v_admin_user :=  apex_util.public_check_authorization(p_security_scheme =>  p_security_scheme );
    END IF;
    
   IF  p_sec_check = '1' 
     AND  v_admin_user=FALSE THEN
       v_return:='<span aria-hidden="true" class="fa fa-universal-access fam-minus fam-is-disabled"></span>';
   ELSE
        v_return:=v_row_link;
   END IF;
 
RETURN v_return;
 
END checkRowAccess;