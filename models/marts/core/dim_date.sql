{{ config(materialized="table") }}

with
    date_spine as (
        {{
            dbt_utils.date_spine(
                datepart="day",
                start_date="to_date('1970-01-01')",
                end_date="to_date('2026-01-01')"
            )
        }}

    ),

    dim_date as (
        select
            date_day,
            extract(year from date_day) as year,
            extract(month from date_day) as month,
            to_char(date_day, 'Day') as day_of_week, 
            case
                when extract(month from date_day) between 1 and 3
                then 1
                when extract(month from date_day) between 4 and 6
                then 2
                when extract(month from date_day) between 7 and 9
                then 3 
                when extract(month from date_day) between 10 and 12
                then 4
            end as trimestre
        from date_spine
    )

select *
from dim_date
