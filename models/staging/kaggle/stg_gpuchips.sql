{{ config(materialized="incremental", unique_key="chip_id") }}

with
    model as (
        select *
        from {{ ref("base_kaggle__chip_dataset") }}
        where
            type = 'GPU'
            and (
                vendor in ('Intel', 'NVIDIA', 'AMD')
                or (vendor = 'ATI' and release_date > '2006-11-01')
            )
    ),

    gpu_chip_dataset_pick as (

        select
            chip_id,
            ordinal,
            product,
            release_date,
            process_size_nm,
            tdp_w,
            die_size_mmsquare,
            transistors_million,
            freq_mhz,
            foundry,
            vendor,
            fp16_gflops,
            fp32_gflops,
            fp64_gflops

        from model
    )

select *
from gpu_chip_dataset_pick
