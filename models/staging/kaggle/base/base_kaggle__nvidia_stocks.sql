{{
  config(
    materialized='view'
  )
}}

WITH stock_union AS (
    SELECT
        DATE,
        OPEN,
        HIGH,
        LOW,
        CLOSE,
        VOLUME,
        CURRENT_TIMESTAMP AS _fivetran_synced
    FROM {{ source('kaggle', 'nvidia_stock') }}

    UNION ALL

    SELECT
        '1980-01-01' AS DATE,
        '0.0' AS OPEN,
        '0.0' AS HIGH,
        '0.0' AS LOW,
        '0.0' AS CLOSE,
        '0' AS VOLUME,
        CURRENT_TIMESTAMP AS _fivetran_synced
),

final_transformed AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['DATE']) }} AS row_id,
        CAST(DATE AS DATE) AS date,
        CAST(OPEN AS FLOAT) AS open,
        CAST(HIGH AS FLOAT) AS high,
        CAST(LOW AS FLOAT) AS low,
        CAST(CLOSE AS FLOAT) AS close,
        CAST(VOLUME AS INT) AS volume,
        CONVERT_TIMEZONE('UTC', _fivetran_synced) AS date_load
    FROM stock_union
)

SELECT * FROM final_transformed