{{ config(materialized='table') }}

with transform_shopping_centre as (

    select 
         Name
        ,Categories
        ,Address
        ,City
        ,State
        ,SAFE_CAST(Postcode as INT) as Postcode
        ,Phone
        ,Website
        ,Email
        ,SAFE_CAST(Latitude as FLOAT64) as Latitude
        ,SAFE_CAST(Longitude as FLOAT64) as Longitude
        ,ST_GeogPoint(SAFE_CAST(Longitude as FLOAT64),SAFE_CAST(Latitude as FLOAT64)) as Location 
    from liveability-demo.batchdata.shoppingcentres
)

select * from transform_shopping_centre