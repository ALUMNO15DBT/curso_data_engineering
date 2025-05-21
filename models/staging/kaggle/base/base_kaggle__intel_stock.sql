{{
  config(
    materialized='view'
  )
}}

WITH stock_union AS (
    SELECT
        'Intel' AS vendor,
        CAST(DATE AS DATE) AS DATE,
        OPEN,
        HIGH,
        LOW,
        CLOSE,
        VOLUME
    FROM {{ source('kaggle', 'intel_stock') }}

    UNION ALL

    SELECT
        'Intel' AS vendor,
        '1980-01-01' AS DATE,
        '0.0' AS OPEN,
        '0.0' AS HIGH,
        '0.0' AS LOW,
        '0.0' AS CLOSE,
        '0' AS VOLUME
),

final_transformed AS (
    SELECT
        VENDOR,
        {{ dbt_utils.generate_surrogate_key(['DATE', 'VENDOR']) }} AS market_id,
        DATE AS date,
        CAST(OPEN AS FLOAT) AS open,
        CAST(HIGH AS FLOAT) AS high,
        CAST(LOW AS FLOAT) AS low,
        CAST(CLOSE AS FLOAT) AS close,
        CAST(VOLUME AS INT)  AS volume
FROM stock_union
)

SELECT * FROM final_transformed