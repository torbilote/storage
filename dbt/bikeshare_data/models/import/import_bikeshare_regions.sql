
-- Use the `ref` function to select from other models

WITH source_data AS (
    SELECT
        region_id,
        name
    FROM {{ source("source_data", "bikeshare_regions") }}
)
SELECT * FROM source_data
