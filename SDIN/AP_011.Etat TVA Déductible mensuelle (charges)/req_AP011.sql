--new req
select  line_number,NumFact,DateFact,NomRaisonFrn,IdfFrn,IceFrn,DsgnBnSrvc,
MntHT,
sum(TauxTva) TauxTva,
sum(MntHT*TauxTva/100) MntTva,
sum(MntHT*(1+TauxTva/100)) MntTTC,
TauxPrataDed,MntTvaRec,ModePai,DatePai
from
(
SELECT 
apinvl1.line_number,
apinv.INVOICE_NUM NumFact,
to_char(apinv.INVOICE_DATE,'DD/MM/YYYY') DateFact,
aps.vendor_name  NomRaisonFrn,
aps.attribute1 IdfFrn,
aps.attribute2 IceFrn,
apinvl1.description DsgnBnSrvc,
nvl(apinvl1.base_amount ,apinvl1.amount) MntHT ,
nvl(zxl.TAX_RATE,0)  TauxTva,
nvl(zxl.tax_amt,0) MntTva,
0 MntTTC,
nvl(apinvd2.rec_nrec_rate,0) TauxPrataDed,
nvl(apinvd2.base_amount,apinvd2.amount) MntTvaRec,
paym.PAYMENT_METHOD_NAME ModePai,
to_char(apc.CHECK_DATE,'DD/MM/YYYY') DatePai
--,zxl.*
 from 
  ap_invoices_all apinv
 ,AP_INVOICE_PAYMENTS_ALL appay
 ,AP_INVOICE_DISTRIBUTIONS_all apinvd1
 ,AP_INVOICE_DISTRIBUTIONS_all apinvd2
 ,ap_checks_all apc
 ,ap_suppliers aps
 ,ap_invoice_lines_all apinvl1
 ,ZX_LINES zxl
  ,iby_payment_methods_vl paym
 where 
 1=1
 and apinvl1.LINE_TYPE_LOOKUP_CODE= 'ITEM'
 --and apinv.invoice_id in (47010,33008)
 --and apinv.invoice_id in (39019)
--and apinv.invoice_id in (18507,14793,188525,177200,545011,53965) --bg-bi server
and apinv.invoice_num='10016'
 and apinv.vendor_id=aps.vendor_id
 and apinv.invoice_id=apinvl1.invoice_id
 and zxl.trx_id(+)=apinv.invoice_id
 and zxl.trx_line_number(+)=apinvl1.line_number
 and zxl.trx_level_type(+) = 'LINE'
 --and zxl.trx_line_id = 1
 and zxl.CANCEL_FLAG(+) ='N'
 and appay.invoice_id=apinv.invoice_id
 and nvl(appay.reversal_flag,'N') = 'N'
 and appay.check_id=apc.check_id
 and apinv.invoice_id = apinvd1.invoice_id(+)
 and apinvl1.line_number=apinvd1.invoice_line_number
 and apinv.invoice_id = apinvd2.invoice_id(+)
 and apinvd1.invoice_distribution_id = apinvd2.charge_applicable_to_dist_id(+)
 and apinvd2.line_type_lookup_code(+) = 'REC_TAX'
 and paym.PAYMENT_METHOD_CODE(+)=apc.PAYMENT_METHOD_CODE
 )
 group by
 line_number,NumFact,DateFact,NomRaisonFrn,IdfFrn,IceFrn,DsgnBnSrvc,MntHT,TauxPrataDed,MntTvaRec,ModePai,DatePai
 order by 2,1
 ;


-- old req
SELECT 
apinv.INVOICE_NUM NumFact,
apinv.INVOICE_DATE DateFact,
apinv.VENDOR_ID NomRaisonFrn,
aps.vendor_name IdfFrn,
apinvl1.item_description IceFrn,
'XXX' DsgnBnSrvc,
apinvl1.base_amount MntHT,
zxl.TAX_RATE TauxTva,
zxl.tax_amt MntTva,
0 MntTTC,
apinvd2.rec_nrec_rate TauxPrataDed,
apinvd2.base_amount MntTvaRec,
apinv.PAYMENT_METHOD_CODE ModePai,
apc.CHECK_DATE DatePai
,apinvd2.*

 from 
  ap_invoices_all apinv
 ,AP_INVOICE_PAYMENTS_ALL appay
 ,AP_INVOICE_DISTRIBUTIONS_all apinvd1
 ,AP_INVOICE_DISTRIBUTIONS_all apinvd2
 ,ap_checks_all apc
 ,ap_suppliers aps
 ,ap_invoice_lines_all apinvl1
 ,ZX_LINES zxl
 where 
 1=1
 and apinvl1.LINE_TYPE_LOOKUP_CODE= 'ITEM'
 --and apinv.invoice_id in (47010,33008)
 --and apinv.invoice_id in (39019)
and apinv.invoice_id in (48011) 
 and apinv.vendor_id=aps.vendor_id
 and apinv.invoice_id=apinvl1.invoice_id
 and zxl.trx_id=apinv.invoice_id
 and zxl.trx_level_type = 'LINE'
 and zxl.trx_line_id = 1
 and zxl.CANCEL_FLAG ='N'
 and appay.invoice_id=apinv.invoice_id
 and appay.reversal_flag = 'N'
 and appay.check_id=apc.check_id
 and apinv.invoice_id = apinvd1.invoice_id
 and apinvl1.line_number=apinvd1.invoice_line_number
 and apinv.invoice_id = apinvd2.invoice_id(+)
 and apinvd1.invoice_distribution_id = apinvd2.charge_applicable_to_dist_id(+)
 and apinvd2.line_type_lookup_code (+) = 'REC_TAX'
 order by 1 asc
 ;
 po_change_api1_s
 ;
 select invoice_distribution_id,apinvdist.charge_applicable_to_dist_id,base_amount,amount,DISTRIBUTION_LINE_NUMBER, invoice_line_number, line_type_lookup_code,reversal_flag,cancelled_flag,apinvdist.* from   AP_INVOICE_DISTRIBUTIONS_all  apinvdist
 where invoice_id=39019
 --and line_type_lookup_code ='REC_TAX'
 --order by DISTRIBUTION_LINE_NUMBER, invoice_line_number, distribution_line_number
 order by 3,4
 ;
 ;
 select * from po_headers_interface
  ;
 select * from po_headers_all order by 4 desc;
 
 select * from po_releases_all order by 2 desc;
 
 select * from all_tables where table_name like 'WF%NOT%';
 
 select * from WF_NOTIFICATIONS order by 1 desc;
 
 PO_REQ_LINES_AUTOCREATE_V
 
 
 execute po_relgen_pkg.create_releases;
 
 select * from po_lines_interface ;
 
 select * from po_interface_errors;
 
 
 select * from XXSGMA.XXSGMA_PO_REP_BLANKET_ENTETE;
 
 select * from AP_INVOICE_PAYMENTS_ALL where invoice_id=43015;
 
 select distinct PAYMENT_METHOD_CODE from ap_invoices_all;
 
 select sum(zxl.tax_amt) from ZX_LINES zxl 
 where  
     trx_id=47010
 AND TRX_LEVEL_TYPE = 'LINE' 
 AND TRX_LINE_ID = '1'  
;
 
select 1,(select 1,2 from all_tables where rownum <2) xx from dual;

select * from po_distributions_all;

exec mo_global.set_policy_context('M',1);

exec mo_global.init('OFA');
exec fnd_global.apps_initialize(,,140)

select * from fnd_application where application_short_name like '%FA%';

select USERENV('LANG') from dual;

select * from FND_FLEX_VALUES_VL;

select fv.description,fv.flex_value,fv.parent_flex_value_low,fv. from 
FND_FLEX_VALUE_SETS 	jv,
FND_FLEX_VALUES_VL 	fv
where
1=1
and fv.FLEX_VALUE_SET_id = jv.FLEX_VALUE_SET_id 
and jv.FLEX_VALUE_SET_NAME = 'XXSGMA_FA_GROUPE_CATEGORIE'

FND_FLEX_VALUE_CHILDREN_V

;
    fnd_flex_values_vl              v,
    fnd_flex_value_norm_hierarchy   h,
    fnd_flex_value_sets             s
    
    
    ;
select * from fnd_flex_value_norm_hierarchy h,fnd_flex_value_sets s
where 
h.flex_value_set_id = s.flex_value_set_id
and s.flex_value_set_name='XXSGMA_FA_GROUPE_CATEGORIE'
;    