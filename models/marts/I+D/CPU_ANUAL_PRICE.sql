{{ config(materialized='table') }}

select
  year(c.release_date) as anio,
  c.vendor,
  count(*) as total_cpus,
  round(avg(c.price_usd), 2) as avg_price_usd,
  round(sum(c.price_usd), 2) as total_price_usd
from {{ ref('fct_cpus') }} c
where c.release_date is not null
  and c.price_usd is not null
  and c.product_page is not null
group by anio, c.vendor
order by anio, c.vendor
