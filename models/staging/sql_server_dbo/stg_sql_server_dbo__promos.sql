{{
  config(
    materialized='table'
  )
}}

WITH promos_union AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}

    UNION ALL

    SELECT
        'Sin_promo' AS promo_id,
        0 AS discount,
        'active' AS status,
        NULL AS _fivetran_deleted,
        CURRENT_TIMESTAMP() AS _fivetran_synced
),

final_transformed AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id,
        promo_id AS promo_desc,
        discount,
        CASE 
            WHEN LOWER(status) = 'active' THEN TRUE
            ELSE FALSE
        END AS status_bool,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load,
        _fivetran_deleted
    FROM promos_union
)

SELECT * FROM final_transformed
