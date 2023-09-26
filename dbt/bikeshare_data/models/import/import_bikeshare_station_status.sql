WITH source_data AS (
    SELECT
        station_id,
        num_bikes_available,
        num_bikes_disabled,
        num_docks_available,
        num_docks_disabled,
        is_installed,
        is_renting,
        is_returning,
        last_reported
    FROM {{ source("source_data", "bikeshare_station_status") }}
)
SELECT * FROM source_data