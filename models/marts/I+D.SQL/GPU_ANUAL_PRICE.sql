{{ config(materialized='table') }}

select
  year(g.release_date) as anio,
  g.vendor,
  count(*) as total_gpus,
  round(avg(g.price_usd), 2) as avg_price_usd,
  round(sum(g.price_usd), 2) as total_price_usd,
  round(avg(g.tdp_w), 2) as avg_tdp
from {{ ref('fct_gpus') }} g
where g.release_date is not null
  and g.price_usd is not null
group by anio, g.vendor
order by anio, g.vendor