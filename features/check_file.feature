Feature: Check if a file exists on Google Cloud Storage
  As a user, I want to verify if a file exists in a public cloud storage for a given year and date.

  Scenario Outline: Check if the file exists for a specific year and date in Google Cloud Storage
    Given a public cloud file URL "https://storage.googleapis.com/noaa-ncei-nclimgrid-daily/cog/<year>/nclimgrid-daily-<date>.tif"
    When I check if the file exists on the cloud
    Then the file should exist on the cloud

  Examples:
    | year | date       |
    | 2024 | 20240903   |
    | 2023 | 20230901   |

Feature: After downloading a file from Google Cloud Storage, load into database
  As a user, once a file is available, it can be downloaded and added to the database

  Scenario Outline: Once a file is available from online storage, it can be uploaded to the database
    Given an image <file> 
    When it is uploaded to the database
    Then the data exists in the database
    Then the data exists as a raster in the database
    Then the raster date is available in the database

  Examples:
    | file |
    | C:\Users\NewbyScott\OneDrive - Steampunk\Documents\Code\NOAA-Daily-Raster-Python\features\data\images\cog_2024_nclimgrid-daily-20240920.tif |
    | C:\Users\NewbyScott\OneDrive - Steampunk\Documents\Code\NOAA-Daily-Raster-Python\features\data\images\cog_2024_nclimgrid-daily-20240921.tif |

Feature: After an image is available in the database, ensure the precipitation and temperature values are available for a given latitude and longitude
  As a user, once an image is in the database, precipitation and temperature attributes can be found for a given latitude and longitude

  Scenario Outline: Once an image is uploaded and converted to raster, derive attributes of precipitation and temperature from the raster
    Given an image
    When uploaded to the database
    Then precipitation can be derived for a geographic point
    Then maximum temperature can be derived for a geographic point
    Then minimum temperature can be derived for a geographic point
    Then average temperature can be derived for a geographic point