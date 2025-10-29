-- Mart model for personnel statistics
-- Provides a foundation for analytics on personnel statistics data with basic transformations

with base as (
    select *
    from {{ ref('stg_personnel_statistics_hrplus') }}
),

final as (
    select *
    from base
)

select * from final
