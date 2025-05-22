{{ config(materialized="incremental", unique_key="CPU_ID") }}

select
    -- Campos de CPUSPECS
    specs.cpu_id,
    specs.name,
    specs.price_usd,
    specs.producer,
    specs.mpn,
    specs.ean,
    specs.base_clock_ghz,
    specs.turbo_clock_ghz,
    specs.unlocked_multiplier,
    specs.cores,
    specs.threads,
    specs.tdp,
    specs.socket,
    specs.integrated_gpu,
    specs.product_page,

    -- Campos de CPUCHIPS
    chips.chip_id,
    chips.release_date,
    chips.process_size_nm,
    chips.die_size_mmsquare,
    chips.transistors_million,
    chips.freq_mhz,
    chips.foundry,
    chips.vendor

from {{ ref("stg_cpuspecs") }} specs
join {{ ref("stg_cpuchips") }} chips on specs.chip = chips.chip
