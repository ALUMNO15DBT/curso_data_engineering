{{ config(materialized='incremental', unique_key="GPU_ID") }}

select
    -- Campos de GPUSPECS
    specs.GPU_ID,
    specs.NAME,
    specs.CHIP,
    specs.PRICE_USD,
    specs.PRODUCER,
    specs.MPN,
    specs.EAN,
    specs.LENGTH_MM,
    specs.SLOTS,
    specs.EIGHT_PIN_CONNECTORS,
    specs.SIX_PIN_CONNECTORS,
    specs.HDMI,
    specs.DISPLAYPORT,
    specs.DVI,
    specs.VGA,
    specs.BOOST_CLOCK,
    specs.VRAM_GB,
    specs.MEMORY_CLOCK,
    specs.TDP_W,
    specs.PRODUCT_PAGE,
    -- Campos de GPUCHIPS
    chips.RELEASE_DATE,
    chips.PROCESS_SIZE_NM,
    chips.DIE_SIZE_MMSQUARE,
    chips.TRANSISTORS_MILLION,
    chips.FREQ_MHZ,
    chips.FOUNDRY,
    chips.VENDOR,
    chips.FP16_GFLOPS,
    chips.FP32_GFLOPS,
    chips.FP64_GFLOPS

from {{ ref('stg_gpuspecs') }} specs
join {{ ref('stg_gpuchips') }} chips
  on specs.CHIP = chips.CHIP
