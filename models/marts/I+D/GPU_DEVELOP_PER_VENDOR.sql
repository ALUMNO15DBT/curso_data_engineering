{{ config(materialized='table') }}

select
  year(g.release_date) as anio,
  p.vendor,
  count(*) as total_gpus,
  avg(g.price_usd) as avg_price_usd,
  avg(g.tdp_w) as avg_tdp,
  avg(g.boost_clock) as avg_boost_clock
from {{ ref('fct_gpus') }} g
join {{ ref('dim_producer') }} p on g.vendor = p.vendor
where g.release_date is not null
group by anio, p.vendor
order by anio, p.vendor
