import gcsfs
from sqlalchemy import create_engine, Column, Integer, LargeBinary, String, text
from sqlalchemy.orm import declarative_base, sessionmaker
import os
# Scott Newby - Steampunk - 2024.09.26
# Step 1 of a 2 step process to get raster data into PostgreSQL/Post_GIS
# this process loads GeoTIFF into postgresql as bytea (binary) as it is just image data
# a trigger fires after insert of the GeoTIFF transforming it into a raster 
# raster is a specific format for GIS processing

# Database connection details
db_url = 'postgresql+psycopg2://postgres:*******@localhost:5432/gis_conceptual'

# Google Cloud Storage bucket details
gcs_file_path = 'noaa-ncei-nclimgrid-daily/cog/2024/'

# Create database engine and session
engine = create_engine(db_url)
Session = sessionmaker(bind=engine)
session = Session()

# Define a SQLAlchemy model for the table to store the BLOB
Base = declarative_base()
Base.metadata.schema = 'ref_climate'
class GeoTIFFBlob(Base):
    __tablename__ = 'geotiff_blobs'
    id = Column(Integer, primary_key=True, autoincrement=True)
    file_name = Column(String)
    blob_data = Column(LargeBinary)

# Ensure the table exists
Base.metadata.create_all(engine)

#function to download and store the geotiff from NOAA
def download_and_store_geotiff(gcs_path, session):
    # Set up GCSFS to access Google Cloud Storage
    fs = gcsfs.GCSFileSystem()

    # find the max date of the geotiff in the system...
    retrievedt = ''
    with engine.connect() as conndt:
        stmt = text("""select replace(max(rast_date+1)::varchar,'-','') as maxrstdt from ref_climate.gpcp_rasters;""")
        dtresult = conndt.execute(stmt)
        for row in dtresult:
            # get the max raster date
            retrievedt = row[0]
            
        conndt.close()
    # List all GeoTIFF files in the bucket with the given prefix
    geotiff_files = fs.glob(f'gs://{gcs_file_path}nclimgrid-daily-{retrievedt}.tif')
    for file in geotiff_files:
        # Open the GeoTIFF file as binary data
        with fs.open(file, 'rb') as f:
            geotiff_blob = f.read()
            # Store the binary data in the PostgreSQL database
            geotiff_record = GeoTIFFBlob(blob_data=geotiff_blob, file_name=os.path.basename(file))
            session.add(geotiff_record)
            session.commit()
            print(f"Stored GeoTIFF from {os.path.basename(file)} in the database.")

def main():
    download_and_store_geotiff(gcs_file_path, session)

if __name__ == "__main__":
    main()
