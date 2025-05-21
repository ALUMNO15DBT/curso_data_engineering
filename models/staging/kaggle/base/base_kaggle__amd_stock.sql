{{ config(materialized="view") }}

with
    market_union as (
        select 'AMD' as vendor, date, open, high, low, close, volume
        from {{ source("kaggle", "amd_stock") }}

        union all

        select
            'AMD' as vendor,
            '1980-01-01' as date,
            '0.0' as open,
            '0.0' as high,
            '0.0' as low,
            '0.0' as close,
            '0' as volume
    ),

    final_transformed as (
        select
            vendor,
            {{ dbt_utils.generate_surrogate_key(["DATE", "VENDOR"]) }} as market_id,
            cast(date as date) as date,
            cast(open as float) as open,
            cast(high as float) as high,
            cast(low as float) as low,
            cast(close as float) as close,
            cast(volume as int) as volume
        from market_union
    )

select *
from final_transformed
