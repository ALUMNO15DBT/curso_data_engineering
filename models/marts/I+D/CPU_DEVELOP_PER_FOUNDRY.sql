{{ config(materialized='table') }}

select
  year(c.release_date) as anio,
  f.foundry,
  count(*) as total_cpus,
  avg(c.cores) as avg_cores,
  avg(c.threads) as avg_threads,
  avg(c.base_clock_ghz) as avg_base_clock,
  avg(c.turbo_clock_ghz) as avg_turbo_clock
from {{ ref('fct_cpus') }} c
join {{ ref('dim_factory') }} f on c.foundry = f.foundry
where c.release_date is not null
  and c.foundry is not null
group by anio, f.foundry
order by anio, f.foundry
