WITH source_data AS (
    SELECT
        station_id,
        name,
        short_name,
        lat,
        lon,
        region_id,
        rental_methods,
        capacity
    FROM {{ source("source_data", "bikeshare_station_info") }}
)
SELECT * FROM source_data