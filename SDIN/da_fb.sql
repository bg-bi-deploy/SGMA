--XXSGMA_PO_REP_DA
--XXSGMA_PO_REPRISE_CMD_STD
--XXSGMA_PO_REPRISE_BLANKET


select * from all_objects 
where object_name like 'XXSGMA_PO%'
and object_type ='PROCEDURE'
;

XXSGMA_PO_REP_DA