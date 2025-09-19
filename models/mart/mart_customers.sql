-- models/mart/mart_customers.sql
-- Mart model for customers with customer type information

with customers as (
    select *
    from {{ ref('stg_customers_proplan') }}
),
customer_types as (
    select *
    from {{ ref('stg_customertypes_proplan') }}
)

select
    customers.*,
    customer_types.name as customer_type_name
from customers
left join customer_types
    on customers.customertype_id = customer_types.id
