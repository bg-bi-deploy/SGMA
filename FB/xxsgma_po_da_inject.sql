CREATE OR REPLACE PROCEDURE xxsgma_po_da_inject IS
w_segment1 number;
BEGIN

execute immediate 'alter session set NLS_LANGUAGE=AMERICAN';

--vision:OPERATIONS user
  fnd_global.apps_initialize(1318,50578,201);
  mo_global.set_policy_context('S',204);

/*
 fnd_global.apps_initialize(1430,50740,201);
 mo_global.set_policy_context('M',123);
 --mo_global.init('PO');
 
 */

        ---Vider les tables d'interface
   DELETE FROM   po_requisitions_interface_all;
   DELETE FROM   PO_INTERFACE_ERRORS where interface_type = 'REQIMPORT';
-- from po_header_id=PO_HEADER_ID
-- cmd:30 
-- type:Commande ouverte

select count(1)-92249+100000 into w_segment1 from po_requisition_headers_all ;
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
                      'SGMA DA FICTIVE' ,            --3
                      decode(destination_type_code
                            ,'STOCK','INVENTORY','EXPENSE'),     --4
                      por.AGENT_ID,--preparer_id,                   --5  
                     -- creation_date,               --6
                      COMMENTS,--header_description,            --7  -- description_DA
                      por.attribute_category,     --8
                      loc.attribute_category,       --9
                      --suggested_vendor_name,         --10
                      --suggested_vendor_site,         --11
                      --suggested_vendor_contact,      --12
                      --suggested_vendor_phone,        --13
                      1,--line_type_id,                  --14  --line_type_id
                      tax_code_id,                   --15
                      trunc(sysdate),                --16  --need_by_date
                      'VENDOR'        ,              --17
                     'INCOMPLETE',-- 'APPROVED',                    --18
                      dis.CODE_COMBINATION_ID,--charge_account_id,             --19  --charge_account_id
                      dis.CODE_COMBINATION_ID,--charge_account_id,             --20  --budget_account_id
                      loc.item_id,                       --21  --item_id
                      loc.quantity,                      --22   --quantity
                      loc.unit_price,                    --23   --unit_price
                      null,--rate,                          --24
                      null,--rate_date,                     --25
                      rate_type,                     --26
                     -- destination_subinventory,    --27
                      --tax_user_override_flag,        --28
                      destination_organization_id,   --29   --destination_organization_id
                      deliver_to_location_id,        --30   --deliver_to_location_id
                      dis.DELIVER_TO_PERSON_ID,       --31  --employer_id
                      loc.org_id,                        --32  --org_id
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
                      w_segment1,--to_char(sysdate,'MMDDHH24MISS'),--req_number_segment1,           --51
                      por.attribute1 ,            --52
                      por.attribute2,             --53
                      por.attribute3,             --54
                      --header_attribute5,             --55
                      --header_attribute6,             --56
                      --header_attribute7,             --57
                      loc.attribute1,               --58
                      loc.attribute2,               --59
                      loc.attribute3,               --60
                      --line_attribute4,               --61
                      --unit_of_measure,               --62
                      mu.uom_code ,--uom_code,                      --63  --UDM
                      poh.currency_code,                 --64  --VG_REQ_CURRENCY
                      loc.item_description,              --65  --v_description_ligne_DA
                      dis.DESTINATION_SUBINVENTORY,--destination_subinventory,      --66  --Magasin
                      dis.CODE_COMBINATION_ID,--charge_account_id ,            --67
                      dis.CODE_COMBINATION_ID--charge_account_id              --68
        FROM  po_headers_all poh
        ,po_releases_all por
        ,PO_LINE_LOCATIONS_RELEASE_V loc
        ,PO_DISTRIBUTIONS_V dis
        ,MTL_UNITS_OF_MEASURE_VL mu
        WHERE  
        1=1
        --and poh.po_header_id=10007 -- sgma
        --and por.po_release_id=4003   --sgma
        --and poh.po_header_id=10007 -- bgbi
        and por.po_release_id=383880   --bgbi
        and poh.po_header_id=por.po_header_id
        and loc.po_header_id=poh.po_header_id
        and por.po_release_id=loc.po_release_id
        and dis.line_location_id=loc.line_location_id
        and mu.unit_of_measure = loc.UNIT_MEAS_LOOKUP_CODE;



   COMMIT;
END;