{{ 
  config(
    materialized='view'
  )
}}

WITH market_union AS (
    SELECT * 
    FROM {{ source('kaggle', 'intel_stock') }}

    UNION ALL

     SELECT
        '1980-01-01' AS "DATE",
        '0.0' AS "OPEN",
        '0.0' AS "HIGH",
        '0.0' AS "LOW",
        '0.0' AS "CLOSE",
        '0' AS "VOLUME",
        '0' as  "DIVIDENDS"

),

final_transformed AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['DATE']) }} AS row_id,
        CAST("DATE" AS DATE) AS date,
        CAST("OPEN" AS FLOAT) AS open,
        CAST("HIGH" AS FLOAT) AS high,
        CAST("LOW" AS FLOAT) AS low,
        CAST("CLOSE" AS FLOAT) AS close,
        CAST("VOLUME" AS INT) AS volume
    FROM market_union
)

SELECT * FROM final_transformed