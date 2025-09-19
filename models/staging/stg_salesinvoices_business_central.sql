-- models/staging/stg_salesinvoices_business_central.sql
-- Staging model for sales invoices from Business Central
-- Materialized as a view. Source: lh_silver_business_central.dbo.silver_salesinvoices

select *
from lh_gold_business_central.dbo.silver_salesinvoices
