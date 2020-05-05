create or replace PACKAGE BODY PKG_APEX_SECURITY
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

    -- ============
    -- Cursor to get the Menu ID of a page
    -- =============

   cursor c_menuid(p_application_id varchar2)
    is
     SELECT    p.page_id
             , l.LIST_ENTRY_ID       
             , l.entry_text
        from  T_SEC_PAGE_ACCESS p  
        inner join APEX_APPLICATION_LIST_ENTRIES l
           on ( REPLACE(regexp_substr(l.entry_target, '[f?p=&APP_ID.:][[:digit:]]+[:]'),':','')=p.page_id)
         where l.application_id=p_application_id 
           and l.list_name='Desktop Navigation Menu' ;

   -- =====================
  -- split a string
  -- =====================
  function splitString ( p_string    varchar2
                     ,  p_seperator varchar2)
  return splitResultTab
  is
    v_returnTab splitResultTab;
    v_token_count pls_integer;
    v_tocken      varchar2(2000);
    v_string      varchar2(32000);
    v_pos1        pls_integer;
    v_sep_length pls_integer;
  begin



    v_token_count:= REGEXP_COUNT(p_string,p_seperator)+1;
    v_sep_length:=length(p_seperator);

    if v_token_count=1 then
        raise_application_error( -20020, ' seperator Char not exist in string to split - p_seperator:=' || p_seperator );
    end if;


    v_string:=p_string||p_seperator;
    -- loop
    for i in 1 .. v_token_count
    loop
       v_pos1 :=instr(v_string,p_seperator);

       v_tocken:=substr(v_string,1,v_pos1-1);
       v_returnTab(i):=v_tocken;

       v_string:=substr(v_string,v_pos1+v_sep_length,length(v_string));
    end loop;

    return v_returnTab;

  end splitString;

    -- =====================
   -- function getUserRoles
   --  get all Roles of a user
   --  
   -- return List of Roles
   -- 
   -- =====================   
    function getUserRoles(p_username  varchar2,p_app_id number)
    return varchar2
    is
     v_return varchar2(8000);
    begin
    
    select listagg(u.role_name,':') WITHIN GROUP (ORDER BY u.role_name) 
      into v_return
      from  APEX_APPL_ACL_USER_ROLES u 
    where u.application_id=p_app_id 
     and u.user_name=p_username
    group by  u.user_name;
    
    return upper(v_return);
    exception
       when NO_DATA_FOUND then
        return 'NO_ROLE';
       when others then
        raise;
    end getUserRoles;



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
    return boolean
    is
     
     v_count pls_integer;
     v_return boolean:=false;
     
    begin
         select count(*)
          into v_count
          from  APEX_APPL_ACL_USER_ROLES u 
        where u.application_id=p_app_id 
         and u.user_name=p_username
         and upper(u.role_name)=upper(p_role)
         ;
    
        if v_count > 0 then
         v_return:=true;
        else
         v_return:=false;
        end if;
        
        return v_return;
    
    exception
       when NO_DATA_FOUND then
        return false;
       when others then
        raise;
     end checkUserInRole;
    

    -- =====================
   -- function checkPageAuthorisation
   --  check if user can access this page
   --  
   -- return true or false
   -- 
   -- =====================   
   function checkPageAuthorisation (   p_user            varchar2
                                     , p_application_id  varchar2
                                     , p_page_id         varchar2
                                     , p_component_id    varchar2
                                     , p_component_name  varchar2
                                     , p_component_type  varchar2 )                                     
     return boolean
   is 
      v_check boolean:=false;
      v_role_list varchar2(8000);
      v_role_needed varchar2(8000);
      v_count pls_integer;
      v_role_tab splitResultTab;
   begin  

   
    if p_application_id is null then
      v_check:=false;
      RAISE_APPLICATION_ERROR(-20001, 'Applikation ID is empty');
    end if;
    
    if  p_user is null then
      v_check:=false;
      RAISE_APPLICATION_ERROR(-20001, 'User Name is empty');
    end if;
   
     -- get the groups of this user
     v_role_list := getUserRoles(p_username => p_user
                                ,p_app_id   => p_application_id );
      
     -- check if we have only one role to check
     if  instr(v_role_list,':') = 0 then
          v_role_tab(1):=v_role_list;
     else
        -- create table of the roles of this user
        v_role_tab := splitString( p_string => v_role_list, p_seperator => ':');
     end if;
   
   -- Secure Page
   
   IF p_component_type NOT LIKE 'APEX_APPLICATION_LIST_ENTRIES' then
   
    -- check if page still exits
     select count(*) into  v_count from T_SEC_PAGE_ACCESS where PAGE_ID=p_page_id;
      
      
     if v_count > 0  then
     
      -- check access rights
           
      select
          decode(OPERATOR_READONLY,'N',null,'OPERATOR_READONLY')
          ||':'||
          decode(OPERATOR,'N',null,'OPERATOR')
          ||':'||         
          decode(OPERATOR_SENIOR,'N',null,'OPERATOR_SENIOR')
          ||':'||  
          decode(ANALYST,'N',null,'ANALYST')
          ||':'||          
          decode(ANALYST_SENIOR,'N',null,'ANALYST_SENIOR')
          ||':'||   
          decode(USER_ADMIN,'N',null,'USER_ADMIN')
          ||':'||       
          decode(ADMINISTRATOR,'N',null,'ADMINISTRATOR')
          ||':'||    
          decode(DEVELOPPER,'N',null,'DEVELOPPER')     
       into v_role_needed  
      from T_SEC_PAGE_ACCESS
       where page_id=p_page_id;
         
         
       -- compare
     
       for i in v_role_tab.first .. v_role_tab.last
       loop
          -- ausgeben
          if v_role_tab.exists(i)
           then 
             if instr(v_role_needed,v_role_tab(i)) > 0 then
                 v_check:=true;
                 exit;
             end if;         
          end if;
      end loop;
    
      else
        -- grant access one time and write page into control table
         v_check:=true;
        
        -- grant the administrator the access rights to the page as default
         insert into T_SEC_PAGE_ACCESS(SEC_SK,PAGE_ID,ADMINISTRATOR) values ( T_SEC_PAGE_ACCESS_SEQ.nextval,p_page_id,'Y'); 
         
         -- refresh all Menu Items
         for rec in c_menuid( p_application_id => p_application_id)
         loop
            update T_SEC_PAGE_ACCESS
                set  MENUE_ID   = rec.LIST_ENTRY_ID 
                    ,MENU_NAME = rec.entry_text
            where page_id=rec.page_id;    
        end loop;
    
    
        commit;
      
       end if;
       
     else
     
     -- secure the menu item
     -- check if page still exits
     begin
        select count(*) into  v_count from T_SEC_PAGE_ACCESS where MENUE_ID=p_component_id;    
     exception
       when NO_DATA_FOUND then
       v_count:=0;
     end;
      
     if v_count > 0  then
     
      -- check access rights           
      select
          decode(OPERATOR_READONLY,'N',null,'OPERATOR_READONLY')
          ||':'||
          decode(OPERATOR,'N',null,'OPERATOR')
          ||':'||         
          decode(OPERATOR_SENIOR,'N',null,'OPERATOR_SENIOR')
          ||':'||  
          decode(ANALYST,'N',null,'ANALYST')
          ||':'||          
          decode(ANALYST_SENIOR,'N',null,'ANALYST_SENIOR')
          ||':'||   
          decode(USER_ADMIN,'N',null,'USER_ADMIN')
          ||':'||       
          decode(ADMINISTRATOR,'N',null,'ADMINISTRATOR')
          ||':'||    
          decode(DEVELOPPER,'N',null,'DEVELOPPER')     
          ||':'
       into v_role_needed  
      from T_SEC_PAGE_ACCESS
       where MENUE_ID=p_component_id;
                  
       -- compare     
       for i in v_role_tab.first .. v_role_tab.last
       loop
          -- ausgeben
          if v_role_tab.exists(i)
           then 
             if instr(v_role_needed,v_role_tab(i)||':') > 0 then
                 v_check:=true;
                 exit;
             end if;          
          end if;
      end loop;
    
      else
        -- grant access for all other menues
         v_check:=true;      
       end if;
     
     end if; 
    

     return v_check;
   
   end checkPageAuthorisation;
    
  -- =====================
  -- procedure reloadPageSecurity
  -- Reload the Page Securtiy Table  
  -- initialize the menu id pointing to this page
  --
  -- =====================  
  procedure reloadPageSecurity(p_application_id varchar2)
  is
    
 
 
  begin
   
    merge into T_SEC_PAGE_ACCESS s
     using (  select page_id,PAGE_NAME 
               from APEX_APPLICATION_PAGES where APPLICATION_ID=p_application_id) p
            on (s.page_id=p.page_id)
    when matched
      then 
       update set PAGE_NAME=p.PAGE_NAME
    when not matched
     then 
      insert ( SEC_SK,PAGE_NAME,PAGE_ID,ADMINISTRATOR) values
       ( T_SEC_PAGE_ACCESS_SEQ.nextval
        , p.PAGE_NAME
        , p.page_id
        ,'Y'
       );  
       
    commit;
      
    for rec in c_menuid( p_application_id => p_application_id)
    loop
       update T_SEC_PAGE_ACCESS
          set  MENUE_ID   = rec.LIST_ENTRY_ID 
              ,MENU_NAME = rec.entry_text
         where page_id=rec.page_id;    
    end loop;
    
    commit;        
    
  end;
  
      
   -- =====================
   -- function checkElementAuthorisation
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
    return boolean
    is

      v_check       boolean:=false;
      v_role_list   varchar2(8000);
      v_role_needed varchar2(8000);
      v_count     pls_integer;
      v_role_tab  splitResultTab;
      v_page_name varchar2(255);
      v_static_id varchar2(255);
      v_label     varchar2(255):=p_component_name;
   begin  
 
    if p_application_id is null then
      v_check:=false;
      RAISE_APPLICATION_ERROR(-20001, 'Applikation ID is empty');
    end if;
    
    if  p_user is null then
      v_check:=false;
      RAISE_APPLICATION_ERROR(-20001, 'User Name is empty');
    end if;
   
     -- get the groups of this user
     v_role_list := getUserRoles(p_username => p_user
                                ,p_app_id   => p_application_id );
      
     -- check if we have only one role to check
     if  instr(v_role_list,':') = 0 then
          v_role_tab(1):=v_role_list;
     else
        -- create table of the roles of this user
        v_role_tab := splitString( p_string => v_role_list, p_seperator => ':');
     end if;
   
   
   -- geht the static id of a region
    if p_component_type='APEX_APPLICATION_PAGE_REGIONS' then               
           select static_id,region_name into v_static_id ,v_label
            from apex_application_page_regions
           where REGION_ID=p_component_id
             and page_id=p_page_id;
   end if;          
   -- Secure the elment
  
    -- check if the element still exits
    
    if p_component_type='APEX_APPLICATION_PAGE_REGIONS' then       
    
          select count(*) into  v_count 
           from T_SEC_ELEMENT_ACCESS 
          where PAGE_ID=p_page_id 
           and ELEMEMT_STATIC_ID=v_static_id;
            
    else
    
     select count(*) into  v_count 
       from T_SEC_ELEMENT_ACCESS 
       where PAGE_ID=p_page_id 
         and ELEMENT_name=p_component_name;
   
     end if;
      
     -- + ==================================
     -- check the element access
      
     if v_count > 0  then
     
      -- check access rights
      select
          decode(OPERATOR_READONLY,'N',null,'OPERATOR_READONLY')
          ||':'||
          decode(OPERATOR,'N',null,'OPERATOR')
          ||':'||         
          decode(OPERATOR_SENIOR,'N',null,'OPERATOR_SENIOR')
          ||':'||  
          decode(ANALYST,'N',null,'ANALYST')
          ||':'||          
          decode(ANALYST_SENIOR,'N',null,'ANALYST_SENIOR')
          ||':'||   
          decode(USER_ADMIN,'N',null,'USER_ADMIN')
          ||':'||       
          decode(ADMINISTRATOR,'N',null,'ADMINISTRATOR')
          ||':'||    
          decode(DEVELOPPER,'N',null,'DEVELOPPER')     
          ||':' 
       into v_role_needed  
      from T_SEC_ELEMENT_ACCESS
      where PAGE_ID=p_page_id 
       and ELEMENT_name=p_component_name
       and rownum =1 ;         
       
       -- compare
     
       for i in v_role_tab.first .. v_role_tab.last
       loop
          -- ausgeben
          if v_role_tab.exists(i)
           then 
             if instr(v_role_needed,v_role_tab(i)||':') > 0 then
                 v_check:=true;
                 exit;
             end if;
            -- DBMS_OUTPUT.put_line('role #' || i || ' = ' || v_role_tab(i));
          end if;
      end loop;
    
      else
         -- grant access one time and wirte page into control table
         v_check:=true;      
       
         -- check if we have a problen to identify a existing element in the T_SEC_ELEMENT_ACCESS
       
         select count(*) into  v_count from T_SEC_ELEMENT_ACCESS where PAGE_ID=p_page_id and ELEMENT_ID=p_component_id;   
         
         if v_count > 1 then
       
            raise_application_error(-20099,'Duplicate entries in T_SEC_ELEMENT_ACCESS for ELEMENT_ID ('||p_component_type||') :'||p_component_id);
        
          elsif v_count = 1 then   
        
            if p_component_type='APEX_APPLICATION_PAGE_REGIONS' then         
           
             -- Check if Static ID was changed!
                    
                 update T_SEC_ELEMENT_ACCESS 
                     set ELEMEMT_STATIC_ID=v_static_id 
                       , ELEMENT_NAME=p_component_name
                     where PAGE_ID=p_page_id 
                       and ELEMENT_ID=p_component_id;             
              
             else
                   update T_SEC_ELEMENT_ACCESS 
                       set ELEMENT_NAME=p_component_name
                     where PAGE_ID=p_page_id 
                       and ELEMENT_ID=p_component_id; 
             end if;
         
        else        
                        
            select PAGE_NAME into v_page_name
                   from APEX_APPLICATION_PAGES 
            where APPLICATION_ID=p_application_id 
               and page_id=p_page_id;
               
            if p_component_type = 'APEX_APPLICATION_BUTTONS' 
            then
            
                 select  b.BUTTON_STATIC_ID
                        ,b.label 
                    into v_static_id ,v_label
                   from apex_application_page_buttons b  
                  where b.page_id = p_page_id 
                     and b.button_id = p_component_id;      
            
            end if;
            
            insert into T_SEC_ELEMENT_ACCESS(SEC_SK
                                          ,PAGE_ID
                                          ,PAGE_NAME
                                          ,ELEMENT_ID
                                          ,ELEMENT_NAME
                                          ,ELEMENT_LABEL
                                          ,ELEMENT_TYPE
                                          ,ELEMEMT_STATIC_ID
                                          ,ADMINISTRATOR) 
             values ( T_SEC_ELEMENT_ACCESS_SEQ.nextval
                     ,p_page_id
                     ,v_page_name
                     ,p_component_id
                     ,p_component_name
                     ,v_label
                     ,p_component_type
                     ,v_static_id
                     ,'Y'); 
          
         end if;         
         
         commit;
      
      end if; 
        
     return v_check;
     
    end checkElementAuthorisation;
    
      
  -- =====================
  -- procedure reloadElementSecurity
  -- Reload the Page Securtiy Table  
  -- =====================  
  procedure reloadElementSecurity(p_application_id varchar2)
  is
   
   cursor c_region_update( p_application_id varchar2)
        is   
      select r.STATIC_ID         
           , r.region_name
           , s.sec_sk
        from apex_application_page_regions r  
        inner join T_SEC_ELEMENT_ACCESS s on ( s.page_id=r.page_id and r.static_id=s.ELEMEMT_STATIC_ID and s.element_type='APEX_APPLICATION_PAGE_REGIONS')
        where r.application_id=p_application_id;

     cursor c_button_update( p_application_id varchar2)
     is
      select b.label
          ,  b.BUTTON_STATIC_ID
          , b.BUTTON_NAME
          , s.sec_sk
     from apex_application_page_buttons b  
      inner join T_SEC_ELEMENT_ACCESS s 
         on ( s.page_id=b.page_id and b.button_id=s.ELEMENT_ID and s.element_type='APEX_APPLICATION_BUTTONS')
      where b.application_id=p_application_id ;

  begin
    --- update all region Names
    for rec in c_region_update( p_application_id => p_application_id)
    loop
       update T_SEC_ELEMENT_ACCESS
          set   ELEMENT_NAME     = rec.region_name 
              , ELEMENT_LABEL    = rec.region_name 
              , ELEMEMT_STATIC_ID = rec.STATIC_ID
         where SEC_SK=rec.SEC_SK;    
    end loop;
    
    commit;        
  
    --- update all Button Names
    for rec in c_button_update( p_application_id => p_application_id)
    loop
       update T_SEC_ELEMENT_ACCESS
          set  ELEMENT_NAME    = rec.BUTTON_NAME
              ,ELEMENT_LABEL   = rec.label
             , ELEMEMT_STATIC_ID = rec.BUTTON_STATIC_ID
         where SEC_SK=rec.SEC_SK;    
    end loop;
    
    commit; 
    
    
    
  end reloadElementSecurity ;
    

END PKG_APEX_SECURITY;
/
