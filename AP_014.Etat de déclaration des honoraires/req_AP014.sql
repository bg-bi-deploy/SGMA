select
pov.vendor_name RAISONSOC,
hp.jgzz_fiscal_code NIDFISC,
pov.attribute2 NAFFCNSS,
pov.attribute3 NIDTP,
'XXX' ADRESSSGS,
'XXX' VILLE,
pov.attribute6 PROFESSION,
'marocaine' NATIONALITE,
apinv.INVOICE_AMOUNT HONORAIRES,
'XXX' COMMISS,
'XXX' RABAIS,
'XXX' MNTRETENU,
apinv.invoice_num NUMFACT
,apinv.vendor_id
 FROM 
 AP.ap_invoices_all apinv  
 ,PO_VENDORS pov
 ,hz_parties hp
 where 
 1=1
 and apinv.vendor_id=pov.vendor_id
 and apinv.invoice_id=63010
 and hp.party_id=pov.party_id
 --and pov.vendor_name like '%Jamal%'
 ;
 --id fiscal = 9991618777
 
 
 select * from po_vendor_sites_all where vendor_id=11002;
 
 SELECT * FROM hz_party_sites where party_id=29046;
 
 SELECT party_id,x.num_1099 ,x.* FROM  ap_suppliers  x
 where vendor_name  like '%Maitre%';
 --29046
 
 select * from ap_supplier_sites_all where vendor_id=11002;
 
 SELECT x.jgzz_fiscal_code ,x.* FROM  hz_parties x
 where party_id=29046
 ;
 
 SELECT x.jgzz_fiscal_code,x.* FROM hz_organization_profiles x where organization_name like '%Jamal%'

 ;  
 --Bailleur de l'agence 100 - fiscal id=D612548 ,party_id=24046
 
 SELECT * FROM    PO_VENDORS where vendor_name like '%Jamal%'
 
 SELECT * FROM  from
