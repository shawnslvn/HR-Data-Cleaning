# HR Data Cleaning
For this project I used AI to generate an HR Dataset that needed cleaning. Certain columns had typos or inconsistencies that needed to be corrected and formatted properly. New columns also needed to be created to allow for deeper analysis to be completed.

The first step in the project after getting the data uploaded to the Database was creating a staging table that could be edited without affecting the raw data. After that was to check for duplicates and if there were any delete those. In this case there were no duplicates. Next I wanted to of course keep the full name column however, stakeholders wanted the column to be split into a first and last name column as well. In order to accomplish this I used the SUBSTRING_INDEX command to accomplish this. Then created these colmumns to in the staging table. 

-- CREATE STAGING TABLE
CREATE TABLE hr_staging AS
SELECT *
FROM hr_dataset_raw;

-- CHECKING FOR DUPLICATES
SELECT full_name, COUNT(department)
FROM hr_staging
GROUP BY department, full_name
HAVING COUNT(*) > 1;

-- CREATING FIRST AND LAST NAME COLUMNS
SELECT
	SUBSTRING_INDEX(full_name, ' ', 1) AS first_name,
	SUBSTRING_INDEX(SUBSTRING_INDEX(full_name, ' ', 2),' ', -1) AS last_name
FROM hr_staging;

ALTER TABLE hr_staging
ADD COLUMN first_name varchar(255),
ADD COLUMN last_name varchar(255);

UPDATE hr_staging
SET first_name = SUBSTRING_INDEX(full_name, ' ', 1),
	last_name = SUBSTRING_INDEX(SUBSTRING_INDEX(full_name, ' ', 2),' ', -1);
    
SELECT full_name, first_name, last_name
FROM hr_staging;
