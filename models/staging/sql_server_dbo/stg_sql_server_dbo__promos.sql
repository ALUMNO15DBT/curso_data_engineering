{{
  config(
    materialized='table', 
  )
}}

WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
),

src_promos_cast AS (
    SELECT
          {{ dbt.hash('promo_id') }} AS promo_id,
          discount,
          CASE 
              WHEN LOWER(status) = 'active' THEN TRUE
              ELSE FALSE
          END AS status_bool,
          CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load_utc
    FROM src_promos
)

SELECT * FROM src_promos_cast