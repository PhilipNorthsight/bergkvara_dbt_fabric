-- models/mart/mart_salesinvoices.sql
-- Mart model for business-ready sales invoice data
-- Materialized as a table. References the staging model for sales invoices.

with salesinvoices as (
    select *
    from {{ ref('stg_salesinvoices_business_central') }}
)

select *
from salesinvoices
