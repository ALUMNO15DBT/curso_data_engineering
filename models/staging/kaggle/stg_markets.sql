{{ config(
    materialized='incremental',
    unique_key = 'market_id'
    ) 
    }}

WITH amd AS (
    SELECT 
        market_id,
        'AMD' AS vendor,
        date,
        close,
        open,
        high,
        low,
        volume
    FROM {{ ref('base_kaggle__amd_stock') }}
),

intel AS (
    SELECT 
        market_id,
        'Intel' AS vendor,
        date,
        close,
        open,
        high,
        low,
        volume
    FROM {{ ref('base_kaggle__intel_stock') }}
),

nvidia AS (
    SELECT 
        market_id,
        'NVIDIA' AS vendor,
        date,
        close,
        open,
        high,
        low,
        volume
    FROM {{ ref('base_kaggle__nvidia_stocks') }}
)

SELECT * FROM amd
UNION ALL
SELECT * FROM intel
UNION ALL
SELECT * FROM nvidia

