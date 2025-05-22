{{ config(materialized='table') }}

with mercado_anual as (
  select
    m.VENDOR,
    d.YEAR,
    avg(m.CLOSE) as avg_close,
    sum(m.VOLUME) as total_volume
  from {{ ref('fct_markets') }} m
  join {{ ref('dim_date') }} d on m.DATE = d.DATE_DAY
  group by m.VENDOR, d.YEAR
),

variacion as (
  select
    *,
    lag(avg_close) over (partition by vendor order by year) as prev_avg_close
  from mercado_anual
)

select
  vendor,
  year,
  avg_close,
  total_volume,
  round((avg_close - prev_avg_close) / nullif(prev_avg_close, 0) * 100, 2) as pct_change_from_prev_year
from variacion
order by vendor, year
