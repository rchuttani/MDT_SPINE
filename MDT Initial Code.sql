/*-------------------------------------------------------------------------------------------------*/
/*---------------------------------Creating DRG/Proc/ICD Codes Table-------------------------------*/
/*-------------------------------------------------------------------------------------------------*/
create table presales.HS_MDT_DRG_Code
(Codes varchar(),Code_Type varchar(),Updated_Bucket varchar());

create table presales.HS_MDT_PROC_Code
(Codes varchar(),Code_Type varchar(),Updated_Bucket varchar());

create table presales.HS_MDT_ICD_Code
(Codes varchar(),Code_Type varchar(),Updated_Bucket varchar());

/*---------------------------------------------------------------------*/
select * from presales.HS_MDT_DRG_Code;
select * from presales.HS_MDT_PROC_Code;
select * from presales.HS_MDT_ICD_Code;

/*-------------------------------------------------------------------------------------------------*/
/*-----------------------------------------Based on DRG Codes--------------------------------------*/
/*-------------------------------------------------------------------------------------------------*/

create table presales.HS_MDT_DRG_Code_Pat as
select CLAIM_NUMBER
      ,encrypted_key_1
      ,encrypted_key_2
      ,DRG_CODE
      ,to_Date(coalesce(STATEMENT_FROM,MIN_SERVICE_FROM,RECEIVED_DATE)) as svc_dt
from select * from rwd_db.rwd.Claims_submits_header
where upper(DRG_CODE) in (select distinct Codes from presales.HS_MDT_DRG_Code)
and to_Date(coalesce(STATEMENT_FROM,MIN_SERVICE_FROM,RECEIVED_DATE)) >= '2016-01-01'
and to_Date(coalesce(STATEMENT_FROM,MIN_SERVICE_FROM,RECEIVED_DATE)) <= '2016-12-31'
;

/*----------------------------Excluding Invalid Records------------------------*/
create table presales.HS_MDT_DRG_Code_Pat_1 as
select * 
from presales.HS_MDT_DRG_Code_Pat
where claim_number IS NOT NULL 
AND   Upper(claim_number) <> 'NULL' 
AND   encrypted_key_1 IS NOT NULL 
AND   Upper(encrypted_key_1) <> 'NULL' 
AND   Upper(encrypted_key_1) NOT LIKE 'XXX -%' 
AND   encrypted_key_1 <> ''
AND   encrypted_key_2 IS NOT NULL 
AND   Upper(encrypted_key_2) <> 'NULL' 
AND   Upper(encrypted_key_2) NOT LIKE 'XXX -%' 
AND   encrypted_key_2 <> ''
;


/*-------------------------------------------------------------------------------------------------*/
/*-----------------------------------------Based on PROC Codes-------------------------------------*/
/*-------------------------------------------------------------------------------------------------*/

create table presales.HS_MDT_Proc_Code_Pat as
select CLAIM_NUMBER
      ,encrypted_key_1
      ,encrypted_key_2
      ,PROCEDURE
      ,to_Date(coalesce(SERVICE_FROM,STATEMENT_FROM)) as svc_dt
from rwd_db.sandbox.Claims_submits_procedure
where upper(PROCEDURE) in (select distinct Codes from presales.HS_MDT_Proc_Code)
and to_Date(coalesce(SERVICE_FROM,STATEMENT_FROM)) >= '2016-01-01'
and to_Date(coalesce(SERVICE_FROM,STATEMENT_FROM)) <= '2016-12-31'
;
/*----------------------------Excluding Invalid Records------------------------*/
create table presales.HS_MDT_PROC_Code_Pat_1 as
select * 
from presales.HS_MDT_PROC_Code_Pat
where claim_number IS NOT NULL 
AND   Upper(claim_number) <> 'NULL' 
AND   encrypted_key_1 IS NOT NULL 
AND   Upper(encrypted_key_1) <> 'NULL' 
AND   Upper(encrypted_key_1) NOT LIKE 'XXX -%' 
AND   encrypted_key_1 <> ''
AND   encrypted_key_2 IS NOT NULL 
AND   Upper(encrypted_key_2) <> 'NULL' 
AND   Upper(encrypted_key_2) NOT LIKE 'XXX -%' 
AND   encrypted_key_2 <> ''
;
/*-------------------------------------------------------------------------------------------------*/
/*------------------------------------Based on Diagnosis Codes-------------------------------------*/
/*-------------------------------------------------------------------------------------------------*/

create table presales.HS_MDT_Diag_Code_Pat as
select CLAIM_NUMBER
      ,encrypted_key_1
      ,encrypted_key_2
      ,DIAGNOSIS
      ,to_Date(coalesce(STATEMENT_FROM,MIN_SERVICE_FROM)) as svc_dt
from rwd_db.sandbox.Claims_submits_diagnosis
where upper(DIAGNOSIS) in (select distinct Codes from presales.HS_MDT_ICD_Code)
and to_Date(coalesce(STATEMENT_FROM,MIN_SERVICE_FROM)) >= '2016-01-01'
and to_Date(coalesce(STATEMENT_FROM,MIN_SERVICE_FROM)) <= '2016-12-31'
;
/*----------------------------Excluding Invalid Records------------------------*/
create table presales.HS_MDT_DIAG_Code_Pat_1 as
select * 
from presales.HS_MDT_DIAG_Code_Pat
where claim_number IS NOT NULL 
AND   Upper(claim_number) <> 'NULL' 
AND   encrypted_key_1 IS NOT NULL 
AND   Upper(encrypted_key_1) <> 'NULL' 
AND   Upper(encrypted_key_1) NOT LIKE 'XXX -%' 
AND   encrypted_key_1 <> ''
AND   encrypted_key_2 IS NOT NULL 
AND   Upper(encrypted_key_2) <> 'NULL' 
AND   Upper(encrypted_key_2) NOT LIKE 'XXX -%' 
AND   encrypted_key_2 <> ''
;

/*-------------------------------------------------------------------------------------------------*/
/*---------------------------------------------Counts----------------------------------------------*/
/*-------------------------------------------------------------------------------------------------*/

select DRG_CODE
      ,count(distinct concat(encrypted_key_1,encrypted_key_2)) as pat_vol
      ,count(distinct claim_number) as clm_vol
      ,count(distinct concat(encrypted_key_1,encrypted_key_2),svc_dt) as pat_date_vol
from presales.HS_MDT_DRG_Code_Pat_1
group by DRG_CODE
order by DRG_CODE
;

select PROCEDURE
      ,count(distinct concat(encrypted_key_1,encrypted_key_2)) as pat_vol
      ,count(distinct claim_number) as clm_vol
      ,count(distinct concat(encrypted_key_1,encrypted_key_2),svc_dt) as pat_date_vol
from presales.HS_MDT_PROC_Code_Pat_1
group by PROCEDURE
order by PROCEDURE
;

select DIAGNOSIS
      ,count(distinct concat(encrypted_key_1,encrypted_key_2)) as pat_vol
      ,count(distinct claim_number) as clm_vol
      ,count(distinct concat(encrypted_key_1,encrypted_key_2),svc_dt) as pat_date_vol
from presales.HS_MDT_DIAG_Code_Pat_1
group by DIAGNOSIS
order by DIAGNOSIS
;

