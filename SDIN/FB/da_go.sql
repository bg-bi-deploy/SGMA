 exec fnd_global.apps_initialize(1318,50578,201);
 exec mo_global.set_policy_context('S',204);
ALTER SESSION SET NLS_LANGUAGE= 'AMERICAN' ;
 
 select * from hr_all_organization_units where name like '%%Vision Operations%';
 
 select * from fnd_application where application_id=200;
 
exec xxsgma_po_da_inject(4003);

select * from po_requisitions_interface_all;

select * from PO_INTERFACE_ERRORS;

     PO_INTERFACE_S.create_documents 

select *
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
        and mu.unit_of_measure = loc.UNIT_MEAS_LOOKUP_CODE
        ;

select * from po_requisition_headers_all order by creation_date desc;

select * from po_releases_all order by creation_date desc;
select * from po_headers_all order by creation_date desc;



select * from po_releases_all  where po_release_id=383880 ;

select *
from
po_headers_all poh
,po_releases_all por
where
poh.po_header_id=por.po_header_id
and por.po_release_id=383880
;

        select * from PO_LINE_LOCATIONS_RELEASE_V loc;
        
        
        select * from PO_DISTRIBUTIONS_V dis;
        
        
        
        select *  
                FROM  po_headers_all poh
        ,po_releases_all por
        ,PO_LINE_LOCATIONS_RELEASE_V loc
        ,PO_DISTRIBUTIONS_V dis
        WHERE  
        1=1
        --and poh.po_header_id=10007 -- sgma
        --and por.po_release_id=4003   --sgma
        --and poh.po_header_id=10007 -- bgbi
        and por.po_release_id=383880   --bgbi
        and poh.po_header_id=por.po_header_id
        and loc.po_header_id=poh.po_header_id
        and por.po_release_id=loc.po_release_id
        and dis.line_location_id=loc.line_location_id;
        
select * from PO_LINE_LOCATIONS_RELEASE_V
where po_release_id=383880;

select uom_code , unit_of_measure  from MTL_UNITS_OF_MEASURE_VL x where unit_of_measure='Hour' ;

select * from PO_LINE_LOCATIONS_RELEASE_V 
;

select * from po_requisition_headers_all
order by 3 desc;

select * from po_requisition_lines_all
order by creation_date desc;

update po_requisition_headers_all set segment1='990000' where segment1='REQSDI_0107210212'
and requisition_header_id=533795;

select sysdate from dual;
