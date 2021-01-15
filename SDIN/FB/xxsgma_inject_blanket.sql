CREATE OR REPLACE PROCEDURE xxsgma_inject_blanket (
    p_po_release_id NUMBER
) IS

    CURSOR cur_po_releases (
        c_po_releases_id NUMBER
    ) IS
    SELECT
        poh.po_header_id,
        poh.end_date          expiration_date,
        poh.start_date        effective_date,
        poh.amount_limit,
        poh.amount_limit      amount_agreed,
        por.attribute3,
        por.attribute2,
        por.attribute1,
        por.attribute_category,
        poh.terms_id,
        poh.comments,
        por.note_to_vendor,
        poh.revision_num,
        poh.fob_lookup_code   fob,
        poh.bill_to_location_id,
        poh.ship_to_location_id,
        poh.vendor_site_id,
        poh.vendor_id,
        poh.agent_id,
        poh.rate,
        poh.rate_date,
        poh.rate_type,
        poh.currency_code,
        poh.segment1          document_num,
        poh.org_id
    FROM
        po_headers_all    poh,
        po_releases_all   por
    WHERE
        poh.po_header_id = por.po_header_id
        AND por.po_release_id = c_po_releases_id;

    CURSOR cur_por_lines (
        c_po_releases_id NUMBER
    ) IS
    SELECT
        pol.po_header_id,
        poll.price_override unit_price,
        mu.uom_code,
        pol.item_description,
        pol.item_id,
        pol.line_type_id,
        pol.line_num
    FROM
        po_lines_all              pol,
        po_line_locations_all     poll,
        po_distributions_all      pod,
        mtl_units_of_measure_vl   mu
    WHERE
        pol.po_line_id = poll.po_line_id
        AND poll.line_location_id = pod.line_location_id
        AND poll.po_release_id = c_po_releases_id
        AND mu.unit_of_measure = poll.unit_meas_lookup_code;

    v_interface_header_id   NUMBER;
    v_interface_line_id     NUMBER;
    p_sob_id                NUMBER;
    v_document_num          NUMBER;
BEGIN
    fnd_global.apps_initialize(1430, 50740, 201);
    mo_global.set_policy_context('M', 101);
---entité compatble
    SELECT
        fnd_profile.value('GL_SET_OF_BKS_ID')
    INTO p_sob_id
    FROM
        dual;

   


    ---Vider les tables d'intergace

    DELETE FROM po_headers_interface;

    DELETE FROM po_lines_interface;

    DELETE FROM po_interface_errors
    WHERE
        interface_type = 'PO_DOCS_OPEN_INTERFACE';

    COMMIT;
    FOR r0 IN cur_po_releases(p_po_release_id) LOOP
        SELECT
            po_headers_interface_s.NEXTVAL
        INTO v_interface_header_id
        FROM
            sys.dual;

        SELECT
            MAX(segment1)+1
        INTO v_document_num
        FROM
            po_headers_all
        WHERE
            type_lookup_code = 'BLANKET';

        INSERT INTO po_headers_interface (
            interface_header_id,  --01 
            batch_id,             --02 
            interface_source_code,--03 
            action,               --04 
            org_id,               --05 
            document_num,         --06 
            document_type_code,   --07  
            currency_code,        --08 
            rate_type,            --09  
            rate_date,            --10 
            rate,                 --11  
            agent_id,             --12 
            vendor_id,            --13 
            vendor_site_id,       --14 
            ship_to_location_id,  --15 
            bill_to_location_id,  --16 
            fob,                  --17 
            revision_num,         --18 
            note_to_vendor,       --19 
            comments,           -- 20 
            creation_date,        --21 
            terms_id,             --22 
            attribute_category,   --23 
            attribute1,           --24 
            attribute2,           --25 
            attribute3,           --26 
            acceptance_required_flag,--27  
            approval_status,      --28
            amount_agreed,        -- 29
            amount_limit,         -- 30
            effective_date,       -- 31
            expiration_date       -- 32
        ) VALUES (
            v_interface_header_id,   --01 
            1,                          --02 
            'SGMA BLANKET SDI', --03 
            'ORIGINAL',             --04 
            r0.org_id,               --05 
            v_document_num,         --06 
            'BLANKET',              --07  
            r0.currency_code,        --08 
            r0.rate_type,            --09  
            r0.rate_date,            --10 
            r0.rate,                 --11  
            r0.agent_id,             --12 
            r0.vendor_id,            --13 
            r0.vendor_site_id,       --14 
            r0.ship_to_location_id,  --15 
            r0.bill_to_location_id,  --16 
            r0.fob,                  --17 
            r0.revision_num,         --18 
            r0.note_to_vendor,       --19 
            r0.comments,           -- 20 
            trunc(sysdate),        --21 
            r0.terms_id,             --22 
            r0.attribute_category,   --23 
            r0.attribute1,           --24 
            r0.attribute2,           --25 
            r0.attribute3,           --26 
            'N',                    --27  
            'APPROVED',             -- 28
            r0.amount_agreed,        -- 29
            r0.amount_limit,         -- 30
            r0.effective_date,       -- 31
            r0.expiration_date       -- 32
        );

        FOR r1 IN cur_por_lines(p_po_release_id) LOOP
            SELECT
                po_lines_interface_s.NEXTVAL
            INTO v_interface_line_id
            FROM
                sys.dual;

            INSERT INTO po_lines_interface (
                interface_line_id,          --01 
                interface_header_id,        --02 
                line_num,                   --03 
                line_type_id,               --04 
                item_id,                    --05 
                item_description,           --06
                uom_code,                   --07 
                unit_price,                 --08
                price_break_lookup_code,    --09
                price_chg_accept_flag,      --10
                creation_date,              --11
                allow_price_override_flag,  --12
                not_to_exceed_price
            )        --13 		
             VALUES (
                v_interface_line_id,          --01     
                v_interface_header_id,        --02 
                r1.line_num,                   --03             
                r1.line_type_id,               --04 
                r1.item_id,                    --05 
                r1.item_description,           --06 
                r1.uom_code,                   --07                
                r1.unit_price,                 --08      
                'CUMULATIVE',                 --09 
                'N',                          --10
                trunc(sysdate),               --11
                'N',                          --12
                NULL                          --13 
            );

        END LOOP;

    END LOOP;

END;