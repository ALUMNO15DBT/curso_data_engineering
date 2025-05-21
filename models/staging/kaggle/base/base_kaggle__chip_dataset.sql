{{ config(materialized='view') }}

WITH cleaned_data AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['ORDERS','PRODUCT']) }} AS chip_id,
        CAST(ORDERS AS INT) AS ordinal,
        PRODUCT,

        CASE 
            WHEN UPPER(TRIM(TYPES)) IN ('GPU', 'CPU') THEN UPPER(TRIM(TYPES))
            ELSE NULL
        END AS types,

        CASE 
            WHEN TRIM(RELEASE_DATE) = 'NaT' THEN NULL
            ELSE TO_DATE(RELEASE_DATE)
        END AS release_date,

        CAST(PROCESS_SIZE_NM AS INT) AS process_size_nm,
        CAST(TDP_W AS INT) AS tdp_w,
        CAST(DIE_SIZE_MMSQUARE AS INT) AS die_size_mmsquare,
        CAST(TRANSISTORS_MILLION AS INT) AS transistors_million,
        CAST(FREQ_MHZ AS INT) AS freq_mhz,

        FOUNDRY,
        VENDOR,

        CAST(FP16_GFLOPS AS FLOAT) AS fp16_gflops,
        CAST(FP32_GFLOPS AS FLOAT) AS fp32_gflops,
        CAST(FP64_GFLOPS AS FLOAT) AS fp64_gflops

    FROM {{ source('kaggle', 'chip_dataset') }}
)

SELECT * FROM cleaned_data
