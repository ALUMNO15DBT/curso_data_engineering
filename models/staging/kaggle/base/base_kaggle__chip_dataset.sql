{{ config(materialized="view") }}

with
    chip_dataset_source as (
        select
            cast(orders as int) as ordinal,
            case
                when product ilike 'AMD %'
                then substr(product, length('AMD ') + 1)
                when product ilike 'Intel %'
                then substr(product, length('Intel ') + 1)
                when product ilike 'NVIDIA %'
                then substr(product, length('NVIDIA ') + 1)
                else product
            end as chip,

            case
                when upper(trim(types)) in ('GPU', 'CPU')
                then upper(trim(types))
                else null
            end as type,

            case
                when trim(release_date) = 'NaT' then null else to_date(release_date)
            end as release_date,

            cast(process_size_nm as int) as process_size_nm,
            cast(tdp_w as int) as tdp_w,
            cast(die_size_mmsquare as int) as die_size_mmsquare,
            cast(transistors_million as int) as transistors_million,
            cast(freq_mhz as int) as freq_mhz,

            foundry,
            vendor,

            cast(fp16_gflops as float) as fp16_gflops,
            cast(fp32_gflops as float) as fp32_gflops,
            cast(fp64_gflops as float) as fp64_gflops

        from {{ source("kaggle", "chip_dataset") }}
    ),

    chip_dataset_newid as (
        select
            {{ dbt_utils.generate_surrogate_key(["ordinal", "chip"]) }} as chip_id,
            ordinal,
            chip,
            type,
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
            
            from chip_dataset_source
    )

select *
from chip_dataset_newid
