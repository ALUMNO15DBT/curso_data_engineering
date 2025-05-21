{{ config(materialized="incremental", unique_key="gpu_id") }}

with
    referencias_clean as (
        select chip_id, product from {{ ref("base_kaggle__chip_dataset") }}
    ),

    coincidencias as (
        select
            g.gpu_id,
            g.name,
            r.product,
            g.price_usd,
            g.producer,
            g.mpn,
            g.ean,
            g.length_mm,
            g.slots,
            g.eight_pin_connectors,
            g.six_pin_connectors,
            g.hdmi,
            g.displayport,
            g.dvi,
            g.vga,
            g.boost_clock,
            g.vram_gb,
            g.memory_clock,
            g.tdp_w,
            g.product_page,
            row_number() over (
                partition by g.name order by length(r.product) desc
            ) as rn
        from {{ ref("base_kaggle__gpudata") }} g
        join referencias_clean r on lower(g.name) like '%' || lower(r.product) || '%'
    ),

    filtrado as (select * from coincidencias where rn = 1)

select
    gpu_id,
    name,
    product,  -- viene de stg_gpuchips vía join
    price_usd,
    producer,
    mpn,
    ean,
    length_mm,
    slots,
    eight_pin_connectors,
    six_pin_connectors,
    hdmi,
    displayport,
    dvi,
    vga,
    boost_clock,
    vram_gb,
    memory_clock,
    tdp_w,
    product_page
from filtrado
