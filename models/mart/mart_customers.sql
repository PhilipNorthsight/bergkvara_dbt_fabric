-- models/mart/mart_customers.sql
-- Mart model for customers with customer type information

with customers as (
    select *
    from {{ ref('stg_customers_proplan') }}
),
customer_types as (
    select *
    from {{ ref('stg_customertypes_proplan') }}
),
deduped_customers as (
    select *
    from (
        select
            customers.*,
            row_number() over (
                partition by customers."number"
                order by customers.id
            ) as customer_rank
        from customers
        where customers.company_id = 1
    ) ranked_customers
    where customer_rank = 1
)

select
    deduped_customers.*,
    customer_types.name as customer_type_name
from deduped_customers
left join customer_types
    on deduped_customers.customertype_id = customer_types.id
