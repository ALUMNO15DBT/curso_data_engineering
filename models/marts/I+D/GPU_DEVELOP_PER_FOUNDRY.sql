{{ config(materialized='table') }}

select
  year(g.release_date) as anio,
  f.foundry,
  count(*) as total_gpus,
  avg(g.price_usd) as avg_price_usd,
  avg(g.memory_clock)as avg_memory_clock,
  avg(g.tdp_w) as avg_tdp,
  avg(g.boost_clock) as avg_boost_clock
from {{ ref('fct_gpus') }} g
join {{ ref('dim_factory') }} f on g.foundry = f.foundry
where g.release_date is not null
  and g.foundry is not null
group by anio, f.foundry
order by anio, f.foundry
