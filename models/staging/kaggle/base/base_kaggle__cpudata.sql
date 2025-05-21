{{ config(materialized="view") }}

with
    raw_data as (select * from {{ source("kaggle", "cpudata") }}),

    socket_split as (

        select r.*, trim(s.value::string) as socket_cleaned
        from raw_data r, lateral flatten(input => split(r.socket, ',')) s

    ),

    cleaned_data as (

        select
            {{ dbt_utils.generate_surrogate_key(["NAME", "MPN", "socket_cleaned"]) }}
            as cpu_id,

            name,

            -- PRICE: elimina 'USD' y convierte a float con 2 decimales
            round(
                cast(replace(replace(price, 'USD', ''), '$', '') as float), 2
            ) as price,

            producer,
            mpn,
            ean,
            upc,

            -- BASE_CLOCK y TURBO_CLOCK: elimina 'GHz' y convierte a INT
            -- BASE_CLOCK a INT (quitando 'GHz')
            case
                when trim(replace(base_clock, 'GHz', '')) = ''
                then null
                else cast(replace(base_clock, 'GHz', '') as float)
            end as base_clock_ghz,

            -- TURBO_CLOCK a INT (quitando 'GHz')
            case
                when trim(replace(turbo_clock, 'GHz', '')) = ''
                then null
                else cast(replace(turbo_clock, 'GHz', '') as float)
            end as turbo_clock_ghz,

            -- UNLOCKED_MULTIPLIER: string a boolean
            case
                when lower(unlocked_multiplier) = 'true'
                then true
                when lower(unlocked_multiplier) = 'false'
                then false
                else null
            end as unlocked_multiplier,

            cast(cores as int) as cores,
            cast(threads as int) as threads,

            -- TDP: elimina 'W' y convierte a INT
            cast(replace(tdp, 'W', '') as int) as tdp,

            socket_cleaned as socket,

            -- INTEGRATED_GPU: si es "false", dejarlo como NULL
            case
                when lower(integrated_gpu) = 'false' then null else integrated_gpu
            end as integrated_gpu,

            product_page

        from socket_split
    )

select *
from cleaned_data
