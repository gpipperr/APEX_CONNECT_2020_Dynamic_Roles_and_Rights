create or replace PACKAGE PKG_APEX_SECURITY 
AS 

 -- =====================
 -- Demo for dynamic use of APEX role concept
 -- Gunther Pippèrr 2020(C) 
 -- https://www.pipperr.de/dokuwiki/doku.php
 -- 
 -- APEX Connect 2020
 -- https://programm.doag.org/apex/2020/#/scheduledEvent/594982
 --
 -- =====================


  -- global variables 
  g_pck   CONSTANT VARCHAR2 (30) := 'pkg_apex_security';

  -- =====================
  type splitResultTab IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

    
   -- =====================
   -- function checkReportAuthorisation
   --  check if user can access Element of the Page
   --  
   -- return true or false
   -- 
   -- =====================   
    function checkElementAuthorisation (  p_user varchar2
                                     , p_application_id  varchar2
                                     , p_page_id         varchar2
                                     , p_component_id    varchar2
                                     , p_component_name  varchar2
                                     , p_component_type  varchar2)
    return boolean;
    
 
   -- =====================
   -- function checkPageAuthorisation
   --  check if user can access this page
   --  
   -- return true or false
   -- 
   -- =====================   
    function checkPageAuthorisation (  p_user varchar2
                                     , p_application_id  varchar2
                                     , p_page_id         varchar2
                                     , p_component_id    varchar2
                                     , p_component_name  varchar2
                                     , p_component_type  varchar2)
    return boolean;
    
    -- =====================
   -- function getUserRoles
   --  get all Roles of a user
   --  
   -- return List of Roles
   -- 
   -- =====================   
    function getUserRoles(p_username  varchar2,p_app_id number)
    return varchar2;   
    
    
    -- =====================
    -- function checkUserInRole
    --  Check if User have a role
    --  
    --  return true is ok
    -- 
    -- =====================   
    function checkUserInRole(  p_username  varchar2
                             , p_role      varchar
                             , p_app_id    number)
    return boolean;   
    
    
   -- =====================
   -- procedure reloadPageSecurity
   -- Reload the Page Securtiy Table  
   -- =====================  
   procedure reloadPageSecurity(p_application_id varchar2);
 
   -- =====================
   -- procedure reloadElementSecurity
   -- Reload the Page Securtiy Table  
   -- =====================  
   procedure reloadElementSecurity(p_application_id varchar2);     


END PKG_APEX_SECURITY;
/
