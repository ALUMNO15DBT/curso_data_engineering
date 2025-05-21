{{ config(materialized='table') }}

select distinct foundry
from (
    select foundry from {{ ref('stg_cpuchips') }} where foundry is not null
    union all
    select foundry from {{ ref('stg_gpuchips') }} where foundry is not null
) as foundries
