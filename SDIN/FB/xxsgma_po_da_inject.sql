CREATE OR REPLACE PROCEDURE xxsgma_po_da_inject (
    p_po_release_id NUMBER
) IS
    w_segment1   NUMBER;
    v_output     NUMBER;
    v_org_id number:=101;
BEGIN
    EXECUTE IMMEDIATE 'alter session set NLS_LANGUAGE=AMERICAN';

--vision:OPERATIONS user
  /*
  fnd_global.apps_initialize(1318,50578,201);
  mo_global.set_policy_context('S',204);
*/

-- SGMA
    fnd_global.apps_initialize(1430, 50740, 201);
    
    mo_global.init('PO');
 mo_global.set_policy_context('S', v_org_id);
 --mo_global.init('PO');
 
 

    ---Vider les tables d'interface
    DELETE FROM po_requisitions_interface_all;

    DELETE FROM po_interface_errors
    WHERE
        interface_type = 'REQIMPORT';
-- from po_header_id=PO_HEADER_ID
-- cmd:30 
-- type:Commande ouverte

    SELECT
        COUNT(1) - 172 + 1000
    INTO w_segment1
    FROM
        po_requisition_headers_all;

    INSERT INTO po_requisitions_interface_all (
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
        header_attribute1,            --52
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
        accrual_account_id,            --67
        variance_account_id             --68
    )
        SELECT
            fnd_global.conc_request_id,    --1
            0,                             --2
            'SGMA DA FICTIVE',            --3
            decode(destination_type_code, 'STOCK', 'INVENTORY', 'EXPENSE'),     --4
            por.agent_id,--preparer_id,                   --5  
                     -- creation_date,               --6
            comments,--header_description,            --7  -- description_DA
            por.attribute_category,     --8
            loc.attribute_category,       --9
                      --suggested_vendor_name,         --10
                      --suggested_vendor_site,         --11
                      --suggested_vendor_contact,      --12
                      --suggested_vendor_phone,        --13
            1,--line_type_id,                  --14  --line_type_id
            tax_code_id,                   --15
            trunc(sysdate),                --16  --need_by_date
            'VENDOR',              --17
            'INCOMPLETE',-- 'APPROVED',                    --18
            dis.code_combination_id,--charge_account_id,             --19  --charge_account_id
            dis.code_combination_id,--charge_account_id,             --20  --budget_account_id
            loc.item_id,                       --21  --item_id
            loc.quantity,                      --22   --quantity
            loc.unit_price,                    --23   --unit_price
            NULL,--rate,                          --24
            NULL,--rate_date,                     --25
            rate_type,                     --26
                     -- destination_subinventory,    --27
                      --tax_user_override_flag,        --28
            destination_organization_id,   --29   --destination_organization_id
            162,--deliver_to_location_id,        --30   --deliver_to_location_id
            321,--dis.deliver_to_person_id,       --31  --employer_id
            loc.org_id,                        --32  --org_id
            trunc(sysdate),               --33
            fnd_global.user_id,            --34
            trunc(sysdate),                --35
            fnd_global.user_id,            --36
            fnd_global.login_id,           --37
            fnd_global.conc_request_id,    --38
            fnd_global.prog_appl_id,       --39
            fnd_global.conc_program_id,    --40
            trunc(sysdate),       --41
            project_id,                   --42   -- avoir
            task_id,                       --43   -- avoir
            TO_DATE('28/12/2020', 'DD/MM/YYYY'),                       --44
                     -- project_accounting_context,    --45 --N'
                     -- wip_entity_id,                 --46
                      --wip_line_id,                   --47
                      --wip_operation_seq_num,        --48
                      --wip_repetitive_schedule_id,    --49
                      --wip_resource_seq_num,         --50
            w_segment1,--to_char(sysdate,'MMDDHH24MISS'),--req_number_segment1,           --51
            por.attribute1,            --52
            por.attribute2,             --53
            por.attribute3,             --54
                      --header_attribute5,    --55
                      --header_attribute6,    --56
                      --header_attribute7,    --57
            loc.attribute1,             --58
            loc.attribute2,             --59
            loc.attribute3,             --60
                      --line_attribute4,               --61
                      --unit_of_measure,            --62
            mu.uom_code,--uom_code,                      --63  --UDM
            poh.currency_code,                 --64  --VG_REQ_CURRENCY
            loc.item_description,              --65  --v_description_ligne_DA
            dis.destination_subinventory,--destination_subinventory,      --66  --Magasin
            dis.code_combination_id,--charge_account_id ,            --67
            dis.code_combination_id--charge_account_id              --68
        FROM
            po_headers_all                poh,
            po_releases_all               por,
            po_line_locations_release_v   loc,
            po_distributions_v            dis,
            mtl_units_of_measure_vl       mu
        WHERE
            1 = 1
        --and poh.po_header_id=10007 -- sgma
        --and por.po_release_id=4003   --sgma
        --and poh.po_header_id=10007 -- bgbi
        --and por.po_release_id=383880   --bgbi
            AND por.po_release_id = p_po_release_id
            AND poh.po_header_id = por.po_header_id
            AND loc.po_header_id = poh.po_header_id
            AND por.po_release_id = loc.po_release_id
            AND dis.line_location_id = loc.line_location_id
            AND mu.unit_of_measure = loc.unit_meas_lookup_code;

    COMMIT;
     --
   -- CONC prog
    fnd_request.set_org_id(v_org_id); --this is passed as operating unit
    v_output := fnd_request.submit_request(application => 'PO', program => 'REQIMPORT', description => '', start_time => to_char(
    sysdate, 'DD-MON-YY HH24:MI:SS'), sub_request => false, argument1 => 'SGMA DA FICTIVE',--Interface Source code,
     argument2 => '',  ----APPS.SONA_BATCH_ID_S.CURRVAL,--Batch ID,
     argument3 => 'Item',--Group By,
                           argument4 => '',--Last Req Number,
                            argument5 => 'N',--Multi Distributions,
                            argument6 => 'Y');

    COMMIT;
END;