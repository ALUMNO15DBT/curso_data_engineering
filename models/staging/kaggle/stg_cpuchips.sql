{{ config(materialized="incremental", unique_key="chip_id") }}

with
    model as (
        select *
        from {{ ref("base_kaggle__chip_dataset") }}
        where
            type = 'CPU'
            and 
                vendor in ('Intel', 'AMD')

    ),

    cpu_chip_dataset_pick as (

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
            vendor

        from model
    )

select *
from cpu_chip_dataset_pick
