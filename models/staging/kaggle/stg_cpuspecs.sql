{{ config(materialized='incremental', unique_key='cpu_id') }}

with referencias_clean as (
    select chip_id, product
    from {{ ref('base_kaggle__chip_dataset') }}
),

coincidencias as (
    select
        c.cpu_id,
        c.name,
        r.product,
        c.price,
        c.producer,
        c.mpn,
        c.ean,
        c.upc,
        c.base_clock_ghz,
        c.turbo_clock_ghz,
        c.unlocked_multiplier,
        c.cores,
        c.threads,
        c.tdp,
        c.socket,
        c.integrated_gpu,
        c.product_page,
        row_number() over (
            partition by c.name
            order by length(r.product) desc
        ) as rn
    from {{ ref('base_kaggle__cpudata') }} c
    join referencias_clean r
      on lower(c.name) like '%' || lower(r.product) || '%'
),

filtrado as (
    select *
    from coincidencias
    where rn = 1
)

select
    cpu_id,
    name,
    product,
    price,
    producer,
    mpn,
    ean,
    upc,
    base_clock_ghz,
    turbo_clock_ghz,
    unlocked_multiplier,
    cores,
    threads,
    tdp,
    socket,
    integrated_gpu,
    product_page
from filtrado
