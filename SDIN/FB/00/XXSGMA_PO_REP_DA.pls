create or replace PROCEDURE XXSGMA_PO_REP_DA( o_errbuf     VARCHAR2,
                                                  o_errcode    VARCHAR2)
									
IS 
l_error_message VARCHAR2(3000); 
l_error_code VARCHAR2(2); 
l_org_id NUMBER; 
l_invoice_num VARCHAR2(60); 
l_vendor_id NUMBER; 
l_vendor_site_id NUMBER; 
l_term_id NUMBER; 
l_code_combination_id NUMBER; 
l_inv_seq NUMBER; 
v_separateur                varchar2(25);
nbr_charge0                 number;
nbr_charge1                 number;
nbr_charge2                 number;
x_concat_segs               varchar2(100);
x_id_flex_num               number;
x_code_combination_id       number;
p_sob_id                    number;
w_oui                       varchar2 (1) := 'Y';
w_non                       varchar2 (1) := 'N';
w_error                     boolean;
w_avertiss                  boolean;
w_msg                       varchar2 (1000);
w_bool                      boolean;
v_master_organization_id    number(15);



                      ---la liste des ols inexistant
cursor ol_ko is
select distinct ol_name
from   xxsgma_po_reprise_da
where  ol_name not in (select organization_name from org_organization_definitions);

                      ---la liste des org inexistant
cursor org_ko is
select distinct org_name
from   xxsgma_po_reprise_da
where  org_name not in (select name from hr_operating_units);

                    ---la liste des articles inexistantes
cursor article_ko is
select distinct item_name
from   xxsgma_po_reprise_da
where  item_name not in (select segment1||'.'||segment2||'.'||segment3 from mtl_system_items );  --ajouter l'OL


                      ---la liste des ols non valides
cursor location_code_ko is
select distinct location_code
from   xxsgma_po_reprise_da
where  location_code not in (select location_code from hr_locations_all );

                      ---la liste des types des lignes non valides
cursor type_lignes_ko is
select distinct line_type
from   xxsgma_po_reprise_da
where  line_type not in (select line_type from po_line_types_tl where language = 'F' );

                      ---la liste des personnes non valides
cursor requestor_name_ko is
select distinct employee_number
from   xxsgma_po_reprise_da
where  employee_number not in (select xx.employee_number from per_people_f xx,per_business_groups yy where  xx.business_group_id = yy.business_group_id and yy.name = 'SGMA_BG' );


                      ---la liste des types des lignes non valides
cursor udm_ko is
select distinct uom_code
from   xxsgma_po_reprise_da
where  uom_code not in (select uom_code from mtl_units_of_measure_tl where language='F');

                      ---la liste des types des lignes non valides
cursor magasin_ko is
select distinct destination_subinventory
from   xxsgma_po_reprise_da
where  destination_subinventory not in (select secondary_inventory_name from mtl_subinventories_all_v );

--compte imputation

cursor  cpt_ach_entite_ko is
select  distinct cpt_ach_entite
from    xxsgma_po_reprise_da
where   cpt_ach_entite
not in (select flex_value from fnd_flex_values where enabled_flag='Y'
        and flex_value_set_id = (select flex_value_set_id from fnd_flex_value_sets where upper(flex_value_set_name) = 'SGMA_GL_CCF_SOCIETE'));


cursor  cpt_ach_compte_general_ko is
select  distinct cpt_ach_compte_general
from    xxsgma_po_reprise_da
where   cpt_ach_compte_general not in (select flex_value from fnd_flex_values where enabled_flag='Y'
                                        and flex_value_set_id = (select flex_value_set_id from fnd_flex_value_sets where upper(flex_value_set_name) = 'SGMA_GL_CCF_CPT_SOCIAL'));


cursor  cpt_ach_centre_budgetaire_ko is
select  distinct cpt_ach_centre_budgetaire
from    xxsgma_po_reprise_da
where   cpt_ach_centre_budgetaire not in (select flex_value from fnd_flex_values where enabled_flag='Y'
                                          and flex_value_set_id = (select flex_value_set_id from fnd_flex_value_sets where upper(flex_value_set_name) = 'SGMA_GL_CCF_CB'));


cursor  cpt_ach_centre_couts_ko is
select  distinct cpt_ach_centre_couts
from    xxsgma_po_reprise_da
where   cpt_ach_centre_couts not in (select flex_value from fnd_flex_values where enabled_flag='Y'
                                      and flex_value_set_id = (select flex_value_set_id from fnd_flex_value_sets where upper(flex_value_set_name) = 'SGMA_GL_CCF_CC'));


cursor  cpt_ach_projet_ko is
select  distinct cpt_ach_projet
from    xxsgma_po_reprise_da xx
where   cpt_ach_projet  not in (select fv.flex_value
                                from FND_FLEX_VALUES fv
                                where enabled_flag='Y'
                                and fv.flex_value_set_id = (select flex_value_set_id from fnd_flex_value_sets where upper(flex_value_set_name) = 'SGMA_GL_CCF_PROJET'));

cursor  cpt_ach_nature_ko is
select  distinct cpt_ach_nature
from    xxsgma_po_reprise_da xx
where   cpt_ach_nature not in (select flex_value
                                from fnd_flex_values
                                where enabled_flag='Y'
                                and flex_value_set_id = (select flex_value_set_id from fnd_flex_value_sets where flex_value_set_name = 'SGMA_GL_CCF_INTER_FILIALE')
                                ) ;

cursor  cpt_ach_futur1_ko is
select  distinct cpt_ach_futur1
from    xxsgma_po_reprise_da
where   cpt_ach_futur1 not in (select flex_value from fnd_flex_values where enabled_flag='Y' and flex_value_set_id = (select flex_value_set_id from fnd_flex_value_sets where upper(flex_value_set_name) = 'SGMA_GL_CCF_R1'));


cursor  cpt_ach_futur2_ko is
select  distinct cpt_ach_futur2
from    xxsgma_po_reprise_da
where   cpt_ach_futur2 not in (select flex_value from fnd_flex_values where enabled_flag='Y' and flex_value_set_id = (select flex_value_set_id from fnd_flex_value_sets where upper(flex_value_set_name) = 'SGMA_GL_CCF_R2'));


cursor  cpt_ach_futur3_ko is
select  distinct cpt_ach_futur3
from    xxsgma_po_reprise_da
where   cpt_ach_futur3 not in (select flex_value from fnd_flex_values where enabled_flag='Y' and flex_value_set_id = (select flex_value_set_id from fnd_flex_value_sets where upper(flex_value_set_name) = 'SGMA_GL_CCF_R3'));

cursor expense_account_ccf is
select distinct cpt_ach_entite                   
,cpt_ach_compte_general          
,cpt_ach_centre_couts            
,cpt_ach_centre_budgetaire       
,cpt_ach_projet                  
,cpt_ach_nature                  
,cpt_ach_futur1                  
,cpt_ach_futur2                  
,cpt_ach_futur3 
from   xxsgma_po_reprise_da
where       cpt_ach_entite              is not  null and
            cpt_ach_compte_general              is not  null and
            cpt_ach_centre_couts              is not  null and
            cpt_ach_centre_budgetaire              is not  null and
            cpt_ach_projet              is not  null and
            cpt_ach_nature              is not  null and
            cpt_ach_futur1              is not  null and
            cpt_ach_futur2              is not  null and
            cpt_ach_futur3              is not  null ;

       -------Le journal de sortie du traitement de chargement des données par numero de facture
CURSOR Journal_DA is
select count(*) nbr_charge0,item_name
from   xxsgma_po_reprise_da
where  statut!='E'
group  by item_name;		

BEGIN

v_separateur:=chr(9);
w_error := FALSE;
---entité compatble
select  fnd_profile.value('GL_SET_OF_BKS_ID')
into    p_sob_id
from    dual;

     -- Enlever les espaces des champs
  UPDATE xxsgma_po_reprise_da xx
      SET ol_name                      =trim(ol_name)   
         ,org_name                     =trim(org_name)   
        ,item_name                     =trim(item_name)                  
        ,location_code	               =trim(location_code)
        --,employee_number	           =trim(employee_number)	 
        ,employee_number	   =trim(employee_number)	
        ,destination_subinventory	   =trim(destination_subinventory)	
        ,destination_type_code	       =trim(destination_type_code)	   
        ,document_type_code	           =trim(document_type_code)	       
        ,expenditure_item_date         =trim(expenditure_item_date)      
        ,expenditure_type	           =trim(expenditure_type)	       	                                    	           
       -- ,group_code	                   =trim(group_code)	                	               		
        --,interface_source_code	       =trim(interface_source_code)	   	       
        ,line_type	                   =trim(line_type)	               	                   		
        ,quantity	                   =trim(quantity)	               
        ,rate	                       =trim(rate)	                   
        ,rate_date	                   =trim(rate_date)	               
        ,rate_type			           =trim(rate_type)			          
        ,source_type_code	           =trim(source_type_code)	          	                        
        ,task_num	                   =trim(task_num)	                      	                    
        ,tax_name	                   =trim(tax_name)	                       	        
        ,unit_of_measure	           =trim(unit_of_measure)	            
        ,unit_price	                   =trim(unit_price)	                	                
        ,uom_code	                   =trim(uom_code)                   
        ,cpt_ach_entite                =trim(cpt_ach_entite)
        ,cpt_ach_compte_general        =trim(cpt_ach_compte_general) 
        ,cpt_ach_centre_couts          =trim(cpt_ach_centre_couts)
        ,CPT_ACH_CENTRE_BUDGETAIRE     =trim(CPT_ACH_CENTRE_BUDGETAIRE)  
        ,cpt_ach_projet                =trim(cpt_ach_projet)             
        ,cpt_ach_nature                =trim(cpt_ach_nature)             
        ,cpt_ach_futur1                =trim(cpt_ach_futur1)             
        ,cpt_ach_futur2                =trim(cpt_ach_futur2)             
        ,cpt_ach_futur3                =trim(cpt_ach_futur3)             
        ,header_attribute_category	   =trim(header_attribute_category)	
        ,header_attribute1		       =trim(header_attribute1)		   
        ,header_attribute2	           =trim(header_attribute2)	       
        ,header_attribute3             =trim(header_attribute3)          
        ,line_attribute_category	   =trim(line_attribute_category)	   
        ,line_attribute1	           =trim(line_attribute1)	           
        ,line_attribute2	           =trim(line_attribute2)	           
        ,line_attribute3               =trim(line_attribute3)           
        ,currency_code                 =trim(currency_code) 
        ,item_description		       =trim(item_description)		
        ,org_id		                   =trim(org_id)		               
        ,preparer_id                   =trim(preparer_id)                
        ,project_id                    =trim(project_id)                 
        ,task_id                       =trim(task_id)                    
        ,item_id                       =trim(item_id)                    
        ,tax_code_id                   =trim(tax_code_id)                
        ,line_type_id                  =trim(line_type_id)               
        ,budget_account_id	           =trim(budget_account_id)	       
        ,charge_account_id             =trim(charge_account_id)          
        ,expenditure_organization_id   =trim(expenditure_organization_id)
        ,destination_organization_id   =trim(destination_organization_id)
        ,deliver_to_location_id	       =trim(deliver_to_location_id)	   
        ,deliver_to_requestor_id	   =trim(deliver_to_requestor_id)	   
        ,statut                        =trim(statut)                     
	  ;
   COMMIT;

-- phase de contrôle des DA
   fnd_file.put_line(fnd_file.log, 'Phase de Contrôle des DA à charger');
   fnd_file.put_line(fnd_file.log, '----------------------------------------');
   fnd_file.put_line(fnd_file.log, '');


   fnd_file.put_line(fnd_file.log, 'Liste des ols Non Valides');
   for x in ol_ko loop
     w_error := TRUE;
     fnd_file.put_line(fnd_file.log, x.ol_name);
   end loop; 

   fnd_file.put_line(fnd_file.log, 'la liste des organisations Non Valides');
   for x in org_ko loop
     w_error := TRUE;
     fnd_file.put_line(fnd_file.log, x.org_name);
   end loop;

   fnd_file.put_line(fnd_file.log, 'Liste des articles déja existants');
   for x in article_ko loop
     w_error := TRUE;
     fnd_file.put_line(fnd_file.log, x.item_name);
   end loop;

     fnd_file.put_line(fnd_file.log, 'Liste des emplyee Non Valides');
   for x in requestor_name_ko loop
     w_error := TRUE;
     fnd_file.put_line(fnd_file.log, x.employee_number);
   end loop;

   fnd_file.put_line(fnd_file.log, 'Liste des lieux livraison Non Valides');
   for x in location_code_ko loop
     w_error := TRUE;
     fnd_file.put_line(fnd_file.log, x.location_code);
   end loop;

    fnd_file.put_line(fnd_file.log, 'Liste des types de lignes Non Valides');
   for x in type_lignes_ko loop
     w_error := TRUE;
     fnd_file.put_line(fnd_file.log, x.line_type);
   end loop;

     fnd_file.put_line(fnd_file.log, 'Liste des uom_code Non Valides');
   for x in udm_ko loop
     w_error := TRUE;
     fnd_file.put_line(fnd_file.log, x.uom_code);
   end loop;

     fnd_file.put_line(fnd_file.log, 'Liste des magasin_ko Non Valides');
   for x in magasin_ko loop
     w_error := TRUE;
     fnd_file.put_line(fnd_file.log, x.destination_subinventory);
   end loop;

   -- CONTROLE DE LA CCF IMPUTATION
   fnd_file.put_line(fnd_file.log,'Liste des SGMA_GL_ENTITE Non Valides');
   for x in cpt_ach_entite_ko loop
   w_error := TRUE;
   fnd_file.put_line(fnd_file.log, x.cpt_ach_entite);
   end loop;

   fnd_file.put_line(fnd_file.log,'Liste des SGMA_GL_COMPTE_COMPTABLE Non Valides');
   for x in cpt_ach_compte_general_ko loop
   w_error := TRUE;
   fnd_file.put_line(fnd_file.log, x.cpt_ach_compte_general);
   end loop;

    fnd_file.put_line(fnd_file.log,'Liste des SGMA_GL_CENTRE_BUDGETAIRE Non Valides');
   for x in cpt_ach_centre_couts_ko loop
   w_error := TRUE; fnd_file.put_line(fnd_file.log, x.cpt_ach_centre_couts);
   end loop;


   fnd_file.put_line(fnd_file.log,'Liste des SGMA_GL_CENTRE_COUT Non Valides');
   for x in CPT_ACH_CENTRE_BUDGETAIRE_ko loop
   w_error := TRUE; fnd_file.put_line(fnd_file.log, x.CPT_ACH_CENTRE_BUDGETAIRE);
   end loop;

   fnd_file.put_line(fnd_file.log,'Liste des SGMA_GL_PROJET Non Valides');
   for x in cpt_ach_projet_ko loop
   w_error := TRUE; fnd_file.put_line(fnd_file.log, x.cpt_ach_projet);
   end loop;

   fnd_file.put_line(fnd_file.log,'Liste des SGMA_GL_NATURE Non Valides');
   for x in cpt_ach_nature_ko loop
   w_error := TRUE; fnd_file.put_line(fnd_file.log, x.cpt_ach_nature);
   end loop;

   fnd_file.put_line(fnd_file.log,'Liste des SGMA_GL_FUTUR1 Non Valides');
   for x in cpt_ach_futur1_ko loop
   w_error := TRUE; fnd_file.put_line(fnd_file.log, x.cpt_ach_futur1);
   end loop;

   fnd_file.put_line(fnd_file.log,'Liste des SGMA_GL_FUTUR2 Non Valides');
   for x in cpt_ach_futur2_ko loop
   w_error := TRUE; fnd_file.put_line(fnd_file.log, x.cpt_ach_futur2);
   end loop;

   fnd_file.put_line(fnd_file.log,'Liste des SGMA_GL_FUTUR3 Non Valides');
   for x in cpt_ach_futur3_ko loop
   w_error := TRUE; fnd_file.put_line(fnd_file.log, x.cpt_ach_futur3);
   end loop;



--CODE_COMBINATION_ID 

    begin
     select id_flex_num into x_id_flex_num from fnd_id_flex_structures where id_flex_code='GL#' and upper(id_flex_structure_code)='SGMA_LIVRE_CPT_SOCIAL'; --
    end;

   fnd_file.put_line(fnd_file.log,'Liste des Combinaisons de CCF-Achat Non Valides');
   for x in expense_account_ccf loop
     x_concat_segs := x.cpt_ach_entite||'.'||x.cpt_ach_compte_general||'.'||x.cpt_ach_centre_couts||'.'||x.cpt_ach_centre_budgetaire||'.'||x.cpt_ach_projet||'.'||
                     x.cpt_ach_nature||'.'||x.cpt_ach_futur1||'.'||x.cpt_ach_futur2||'.'||x.cpt_ach_futur3;
     x_code_combination_id := fnd_flex_ext.get_ccid('SQLGL','GL#' , x_id_flex_num, null, x_concat_segs);
     if x_code_combination_id <= 0 then
          w_error := TRUE;
          fnd_file.put_line(fnd_file.log, x_concat_segs);
     else
       begin
         update xxsgma_po_reprise_da
            set charge_account_id=x_code_combination_id
          where cpt_ach_entite=x.cpt_ach_entite
            and cpt_ach_compte_general=x.cpt_ach_compte_general
            and cpt_ach_centre_couts=x.cpt_ach_centre_couts
            and cpt_ach_centre_budgetaire=x.cpt_ach_centre_budgetaire
            and cpt_ach_projet=x.cpt_ach_projet
            and cpt_ach_nature=x.cpt_ach_nature
            and cpt_ach_futur1=x.cpt_ach_futur1
            and cpt_ach_futur2=x.cpt_ach_futur2
            and cpt_ach_futur3=x.cpt_ach_futur3;
       end;
     end if;
     -- fnd_file.put_line(fnd_file.output,'id_compte_charge:=' ||x_code_combination_id);
   end loop;

   --IF w_error then fnd_file.put_line(fnd_file.log, 'w_error is true');end if;

   IF w_error -- ON QUITTE SI VALIDATION KO
   THEN
      w_bool :=
         fnd_concurrent.set_completion_status (
            'ERROR',
            'Il existe des Erreurs dans le fichier! Consultez la sortie, Corrigez votre fichier .csv en entrée et Relancez'
         );
      GOTO fin;
   END IF;
/*
  begin
       select distinct organization_id
       into V_MASTER_ORGANIZATION_ID
       from mtl_parameters;
    exception when too_many_rows then begin
                                       fnd_file.put_line(fnd_file.log, 'Erreur - Plusieures organisations principales sont parametrées');
                                       end;
   end;
*/
--ORG_ID 
   UPDATE xxsgma_po_reprise_da xx
      SET org_id =
             (SELECT organization_id
                FROM hr_operating_units ood
               WHERE ood.name = xx.org_name);


--item_id
UPDATE xxsgma_po_reprise_da xx
      SET item_id =
             (SELECT inventory_item_id
                FROM mtl_system_items_b msib
               WHERE msib.organization_id = (SELECT organization_id
                                                FROM org_organization_definitions ood
                                               WHERE ood.organization_name = xx.ol_name)
                 and msib.segment1||'.'||msib.segment2||'.'||msib.segment3 = xx.item_name
                 );


--rechercher deliver_to_location_id			   
   update xxsgma_po_reprise_da xx
      set deliver_to_location_id =
             (select apt.location_id
                from hr_locations apt
               where apt.location_code = xx.location_code);

--rechercher preparer_id			   
   update xxsgma_po_reprise_da xx
      set preparer_id =
             (select apt.person_id
                from per_all_people_f apt
               where apt.employee_number = xx.employee_number);

--rechercher project_id			   
   update xxsgma_po_reprise_da xx
      set project_id =
             (select apt.location_id
                from pa_projects_all apt
               where apt.name = xx.project_name);               

--rechercher task_id			   
   update xxsgma_po_reprise_da xx
      set task_id =
             (select apt.task_id
                from pa_tasks apt
               where apt.task_number = xx.task_num  ); 

--rechercher tax_code_id			   
/*   update xxsgma_po_reprise_da xx
      set tax_code_id =
             (select apt.location_id
                from hr_locations apt
               where apt.location_code = xx.location_code);  */

--rechercher line_type_id			   
   update xxsgma_po_reprise_da xx
      set line_type_id =
             (select apt.line_type_id
                from po_line_types_tl apt
               where apt.line_type = xx.line_type and language = 'F');                 

--rechercher deliver_to_requestor_id			   
   update xxsgma_po_reprise_da xx
      set deliver_to_requestor_id =
             (select apt.person_id
                from per_all_people_f apt
               where apt.employee_number = xx.employee_number);  

--destination_organization_id 
   UPDATE xxsgma_po_reprise_da xx
      SET destination_organization_id =
             (SELECT organization_id
                FROM org_organization_definitions ood
               WHERE ood.organization_name = xx.ol_name);             
--expenditure_organization_id      



COMMIT;

    ---Vider les tables d'intergace
   DELETE FROM   po_requisitions_interface_all;
   DELETE FROM   PO_INTERFACE_ERRORS where interface_type = 'REQIMPORT';


 insert into po_requisitions_interface_all(
                      batch_id,                      --1
                      group_code,                    --2
                      interface_source_code,         --3
                      destination_type_code,         --4
                      preparer_id,                   --5
                     -- creation_date,               --6
                      header_description,            --7
                      header_attribute_category,     --8
                      line_attribute_category,       --9
                      --suggested_vendor_name,         --10
                      --suggested_vendor_site,         --11
                      --suggested_vendor_contact,      --12
                      --suggested_vendor_phone,        --13
                      line_type_id,                  --14
                      tax_code_id,                   --15
                      need_by_date,                  --16
                      source_type_code,              --17
                      authorization_status,          --18
                      charge_account_id,             --19
                      budget_account_id,             --20
                      item_id,                       --21
                      quantity,                      --22
                      unit_price,                    --23
                      rate,                          --24
                      rate_date,                     --25
                      rate_type,                     --26
                     -- destination_subinventory,    --27
                      --tax_user_override_flag,        --28
                      destination_organization_id,   --29
                      deliver_to_location_id,        --30
                      deliver_to_requestor_id,       --31
                      org_id,                        --32
                      creation_date,                 --33
                      created_by,                    --34
                      last_update_date,              --35
                      last_updated_by,               --36
                      last_update_login,             --37
                      request_id,                    --38
                      program_application_id,        --39
                      program_id,                    --40
                      program_update_date,           --41
                      project_id,                    --42
                      task_id,                       --43
                      gl_date,                       --44
                     -- project_accounting_context,    --45
                     -- wip_entity_id,                 --46
                     -- wip_line_id,                   --47
                     -- wip_operation_seq_num,         --48
                     -- wip_repetitive_schedule_id,    --49
                      --wip_resource_seq_num,          --50
                      req_number_segment1,           --51
                      header_attribute1 ,            --52
                      header_attribute2,             --53
                      header_attribute3,             --54
                      --header_attribute5,             --55
                      --header_attribute6,             --56
                      --header_attribute7,             --57
                      line_attribute1,               --58
                      line_attribute2,               --59
                      line_attribute3,               --60
                      --line_attribute4,               --61
                      --unit_of_measure,               --62
                      uom_code,                      --63
                      currency_code,                 --64
                      item_description,              --65
                      destination_subinventory,       --66
                      accrual_account_id ,            --67
                      variance_account_id             --68
					  )      
      select          fnd_global.conc_request_id,    --1
                      0,                             --2
                      'SGMA REPRISE DA' ,            --3
                      decode(destination_type_code
                            ,'STOCK','INVENTORY','EXPENSE'),     --4
                      preparer_id,                   --5  
                     -- creation_date,               --6
                      header_description,            --7  -- description_DA
                      header_attribute_category,     --8
                      line_attribute_category,       --9
                      --suggested_vendor_name,         --10
                      --suggested_vendor_site,         --11
                      --suggested_vendor_contact,      --12
                      --suggested_vendor_phone,        --13
                      line_type_id,                  --14  --line_type_id
                      tax_code_id,                   --15
                      trunc(sysdate),                --16  --need_by_date
                      'VENDOR'        ,              --17
                      'APPROVED',                    --18
                      charge_account_id,             --19  --charge_account_id
                      charge_account_id,             --20  --budget_account_id
                      item_id,                       --21  --item_id
                      quantity,                      --22   --quantity
                      unit_price,                    --23   --unit_price
                      rate,                          --24
                      rate_date,                     --25
                      rate_type,                     --26
                     -- destination_subinventory,    --27
                      --tax_user_override_flag,        --28
                      destination_organization_id,   --29   --destination_organization_id
                      deliver_to_location_id,        --30   --deliver_to_location_id
                      deliver_to_requestor_id,       --31  --employer_id
                      org_id,                        --32  --org_id
                      trunc(sysdate) ,               --33
                      fnd_global.user_id,            --34
                      trunc(sysdate),                --35
                      fnd_global.user_id,            --36
                      fnd_global.login_id,           --37
                      fnd_global.conc_request_id,    --38
                      fnd_global.prog_appl_id,       --39
                      fnd_global.conc_program_id,    --40
                      trunc(sysdate)     ,           --41
                      project_id,                    --42   -- avoir
                      task_id,                       --43   -- avoir
                      TO_DATE('28/12/2020', 'DD/MM/YYYY'),                       --44
                     -- project_accounting_context,    --45 --N'
                     -- wip_entity_id,                 --46
                      --wip_line_id,                   --47
                      --wip_operation_seq_num,         --48
                      --wip_repetitive_schedule_id,    --49
                      --wip_resource_seq_num,          --50
                      req_number_segment1,           --51
                      header_attribute1 ,            --52
                      header_attribute2,             --53
                      header_attribute3,             --54
                      --header_attribute5,             --55
                      --header_attribute6,             --56
                      --header_attribute7,             --57
                      line_attribute1,               --58
                      line_attribute2,               --59
                      line_attribute3,               --60
                      --line_attribute4,               --61
                      --unit_of_measure,               --62
                      uom_code,                      --63  --UDM
                      currency_code,                 --64  --VG_REQ_CURRENCY
                      item_description,              --65  --v_description_ligne_DA
                      destination_subinventory,      --66  --Magasin
                      charge_account_id ,            --67
                      charge_account_id              --68
        FROM   xxsgma_po_reprise_da t1
        WHERE  statut!='E'
       /*  AND    (invoice_num not in (  SELECT invoice_num
									FROM   ap_invoices_all aia
									WHERE  aia.invoice_num=xx.invoice_num
									and aia.org_id = xx.org_id))*/
									;	



   COMMIT;



            -------Le journal de sortie du traitement de chargement des données

      fnd_file.put_line(fnd_file.output, v_separateur||v_separateur||'Etat des DA chargés' );
      fnd_file.put_line(fnd_file.output, '' );
      fnd_file.put_line(fnd_file.output, '' );
      fnd_file.put_line(fnd_file.output, 'DA'||v_separateur||'Nombre des DA' );

     for rec in journal_DA loop
       fnd_file.put_line(fnd_file.output,rec.item_name||v_separateur||rec.nbr_charge0);
     end loop;




  <<fin>>
   BEGIN
      NULL;
   END;
END;