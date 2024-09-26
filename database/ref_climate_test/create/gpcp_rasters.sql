-- Table: ref_climate.gpcp_rasters

-- DROP TABLE IF EXISTS ref_climate_test.gpcp_rasters;

CREATE TABLE IF NOT EXISTS ref_climate_test.gpcp_rasters
(
    rast_id bigserial NOT NULL,
    rast raster NOT NULL,
    rast_date date,
    CONSTRAINT gpcp_rasters_pkey PRIMARY KEY (rast_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS ref_climate_test.gpcp_rasters
    OWNER to postgres;