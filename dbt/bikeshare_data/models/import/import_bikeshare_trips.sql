
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

WITH source_data AS (
    SELECT
        trip_id,
        duration_sec,
        start_date,
        start_station_name,
        start_station_id,
        end_date,
        end_station_name,
        end_station_id,
        bike_number,
        zip_code,
        subscriber_type,
        start_station_latitude,
        start_station_longitude,
        end_station_latitude,
        end_station_longitude
    FROM {{ source("source_data", "bikeshare_trips") }}
)
SELECT * FROM source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
