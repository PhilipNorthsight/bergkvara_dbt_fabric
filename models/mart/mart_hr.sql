-- models/mart/mart_hr.sql
-- HR mart model combining employment, employment type, and person data with age analytics
-- This replicates the Power Query HR model logic with exact column naming

with base_employment as (
    select distinct
        id,
        person_id,
        start_date,
        is_active_today
    from {{ ref('stg_employment_hrplus') }}
    where is_active_today = 1
),

employment_with_type as (
    select
        base_employment.id,
        base_employment.person_id,
        base_employment.start_date,
        base_employment.is_active_today,
        employment_type_current.employment_type_id as [Employment Type ID],
        employment_type_current.employment_type_description as [Employment Type Desc]
    from base_employment
    left join {{ ref('stg_employment_type_current_hrplus') }} as employment_type_current
        on base_employment.person_id = employment_type_current.person_id
    where employment_type_current.employment_type_id is not null
),

employment_with_person as (
    select
        employment_with_type.id,
        employment_with_type.person_id,
        employment_with_type.start_date,
        employment_with_type.is_active_today,
        employment_with_type.[Employment Type ID],
        employment_with_type.[Employment Type Desc],
        person.birth_date as [Birth Date],
        person.full_name as [Full Name],
        person.gender as [Gender]
    from employment_with_type
    left join {{ ref('stg_person_hrplus') }} as person
        on employment_with_type.person_id = person.id
),

final as (
    select distinct
        id,
        person_id,
        start_date,
        is_active_today,
        [Employment Type ID],
        [Employment Type Desc],
        [Birth Date],
        [Full Name],
        [Gender],
        case
            when [Birth Date] is not null then
                datediff(year, [Birth Date], getdate()) -
                case
                    when dateadd(year, datediff(year, [Birth Date], getdate()), [Birth Date]) > getdate()
                    then 1
                    else 0
                end
            else null
        end as [Age],
        case
            when [Birth Date] is null then 'Unknown'
            when datediff(year, [Birth Date], getdate()) -
                case
                    when dateadd(year, datediff(year, [Birth Date], getdate()), [Birth Date]) > getdate()
                    then 1
                    else 0
                end < 18 then 'Under 18'
            when datediff(year, [Birth Date], getdate()) -
                case
                    when dateadd(year, datediff(year, [Birth Date], getdate()), [Birth Date]) > getdate()
                    then 1
                    else 0
                end between 18 and 24 then '18-24'
            when datediff(year, [Birth Date], getdate()) -
                case
                    when dateadd(year, datediff(year, [Birth Date], getdate()), [Birth Date]) > getdate()
                    then 1
                    else 0
                end between 25 and 34 then '25-34'
            when datediff(year, [Birth Date], getdate()) -
                case
                    when dateadd(year, datediff(year, [Birth Date], getdate()), [Birth Date]) > getdate()
                    then 1
                    else 0
                end between 35 and 44 then '35-44'
            when datediff(year, [Birth Date], getdate()) -
                case
                    when dateadd(year, datediff(year, [Birth Date], getdate()), [Birth Date]) > getdate()
                    then 1
                    else 0
                end between 45 and 54 then '45-54'
            when datediff(year, [Birth Date], getdate()) -
                case
                    when dateadd(year, datediff(year, [Birth Date], getdate()), [Birth Date]) > getdate()
                    then 1
                    else 0
                end between 55 and 64 then '55-64'
            when datediff(year, [Birth Date], getdate()) -
                case
                    when dateadd(year, datediff(year, [Birth Date], getdate()), [Birth Date]) > getdate()
                    then 1
                    else 0
                end >= 65 then '65+'
            else 'Unknown'
        end as [Age Bucket]
    from employment_with_person
)

select * from final
