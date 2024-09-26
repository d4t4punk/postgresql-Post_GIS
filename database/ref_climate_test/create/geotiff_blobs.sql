

CREATE TABLE IF NOT EXISTS ref_climate_test.geotiff_blobs
(
    id bigserial NOT NULL,
    blob_data bytea NOT NULL,
    file_name character varying(256) COLLATE pg_catalog."default",
    CONSTRAINT geotiff_blobs_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS ref_climate_test.geotiff_blobs
    OWNER to postgres;

    CREATE OR REPLACE TRIGGER trg_blob_to_raster
    AFTER INSERT
    ON ref_climate_test.geotiff_blobs
    FOR EACH ROW
    EXECUTE FUNCTION ref_climate_test.trg_fnct_blob_to_50x50_raster();