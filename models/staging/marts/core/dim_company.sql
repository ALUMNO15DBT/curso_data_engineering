{{ config(materialized='table') }}

select distinct
    vendor
from {{ ref('stg_markets') }}
where vendor is not null
