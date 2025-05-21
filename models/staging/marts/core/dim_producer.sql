{{ config(materialized='table') }}

select distinct vendor
from (
    select vendor from {{ ref('stg_cpuchips') }} where foundry is not null
    union all
    select vendor from {{ ref('stg_gpuchips') }} where foundry is not null
) as vendors

