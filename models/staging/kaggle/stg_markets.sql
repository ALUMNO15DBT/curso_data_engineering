{{ config(materialized="incremental", unique_key="market_id") }}

with
    amd as (
        select market_id, 'AMD' as vendor, date, close, open, high, low, volume
        from {{ ref("base_kaggle__amd_stock") }}
    ),

    intel as (
        select market_id, 'Intel' as vendor, date, close, open, high, low, volume
        from {{ ref("base_kaggle__intel_stock") }}
    ),

    nvidia as (
        select market_id, 'NVIDIA' as vendor, date, close, open, high, low, volume
        from {{ ref("base_kaggle__nvidia_stocks") }}
    )

select *
from amd
union all
select *
from intel
union all
select *
from nvidia
