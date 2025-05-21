{{ config(materialized="view") }}

with
    stock_union as (
        select
            'NVIDIA' as vendor,
            date,
            open,
            high,
            low,
            close,
            volume,
            current_timestamp as _fivetran_synced
        from {{ source("kaggle", "nvidia_stock") }}

        union all

        select
            'NVIDIA' as vendor,
            '1980-01-01' as date,
            '0.0' as open,
            '0.0' as high,
            '0.0' as low,
            '0.0' as close,
            '0' as volume,
            current_timestamp as _fivetran_synced
    ),

    final_transformed as (
        select
            {{ dbt_utils.generate_surrogate_key(["DATE", "vendor"]) }} as market_id,
            cast(date as date) as date,
            cast(open as float) as open,
            cast(high as float) as high,
            cast(low as float) as low,
            cast(close as float) as close,
            cast(volume as int) as volume,
            convert_timezone('UTC', _fivetran_synced) as date_load
        from stock_union
    )

select *
from final_transformed
