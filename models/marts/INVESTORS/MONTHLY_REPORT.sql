{{ config(materialized="table") }}

with
    mercado_mes as (
        select
            m.vendor,
            d.year,
            d.month,
            avg(m.close) as avg_close,
            sum(m.volume) as total_volume
        from {{ ref("fct_markets") }} m
        join {{ ref("dim_date") }} d on m.date = d.date_day
        group by m.vendor, d.year, d.month
    ),

    variacion as (
        select
            *,
            lag(avg_close) over (
                partition by vendor order by year, month
            ) as prev_avg_close
        from mercado_mes
    )

select
    vendor,
    year,
    month,
    avg_close,
    total_volume,
    round(
        (avg_close - prev_avg_close) / nullif(prev_avg_close, 0) * 100, 2
    ) as pct_change_from_prev_month
from variacion
order by vendor, year, month
