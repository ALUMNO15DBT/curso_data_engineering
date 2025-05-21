{{ config(materialized="view") }}

with
    cleaned_gpu as (
        select

            name,
            cast(
                round(
                    try_cast(
                        nullif(
                            trim(replace(replace(price, 'USD', ''), '$', '')), ''
                        ) as float
                    ),
                    2
                ) as float
            ) as price_usd,
            producer,
            mpn,
            ean,
            nullif(trim(upc), '') as upc,
            try_cast(nullif(trim(replace(length, 'mm', '')), '') as int) as length_mm,
            try_cast(nullif(trim(slots), '') as decimal) as slots,
            try_cast(
                nullif(trim(eight_pin_connectors), '') as int
            ) as eight_pin_connectors,
            try_cast(nullif(trim(six_pin_connectors), '') as int) as six_pin_connectors,
            try_cast(nullif(trim(hdmi), '') as int) as hdmi,
            try_cast(nullif(trim(displayport), '') as int) as displayport,
            try_cast(nullif(trim(dvi), '') as int) as dvi,
            try_cast(nullif(trim(replace(vga, 'MPN', '')), '') as int) as vga,
            try_cast(
                nullif(trim(replace(boost_clock, 'MHz', '')), '') as int
            ) as boost_clock,
            try_cast(
                nullif(trim(replace(lower(vram), 'gb', '')), '') as int
            ) as vram_gb,
            try_cast(
                nullif(trim(replace(memory_clock, 'MHz', '')), '') as int
            ) as memory_clock,
            try_cast(nullif(trim(replace(lower(tdp), 'w', '')), '') as int) as tdp_w,
            product_page
        from {{ source("kaggle", "gpudata") }}
    )

select *
from cleaned_gpu
