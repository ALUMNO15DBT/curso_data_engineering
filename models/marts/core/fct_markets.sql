{{ config(materialized="incremental", unique_key="market_id") }}

select *  from {{ ref("stg_markets") }}