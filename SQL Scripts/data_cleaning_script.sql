SELECT *
FROM hr_staging;

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

-- LOOKING FOR TYPOS -- DEPARTMENT COLUMN
SELECT department
FROM hr_staging
GROUP by department
ORDER by department;

UPDATE hr_staging
SET department = 'IT'
WHERE department = 'aT' OR department = 'cT' OR department = 'Ij' OR department = 'Iw';

UPDATE hr_staging
SET department = 'Customer Service'
WHERE department LIKE 'Cu%' OR department LIKE 'vu%';

UPDATE hr_staging
SET department = 'Finance'
WHERE department LIKE 'Fin%';

UPDATE hr_staging
SET department = 'Sales'
WHERE department LIKE 'Sa%' OR department LIKE 'Sf%' OR department = 'males';

UPDATE hr_staging
SET department = 'Marketing'
WHERE department LIKE 'Mark%';

UPDATE hr_staging
SET department = 'Operations'
WHERE department LIKE 'Ope%';

-- LOOKING FOR TYPOS --  JOB_TITLE COLUMN
SELECT job_title
FROM hr_staging
GROUP BY job_title
ORDER BY job_title;

UPDATE hr_staging
SET job_title = 
CASE
	WHEN job_title LIKE 'Brand%' THEN 'Brand Strategist'
	WHEN job_title LIKE 'Bus%' THEN 'Business Analyst' 
	WHEN job_title LIKE 'Fin%' THEN 'Financial Analyst'
	WHEN job_title LIKE 'HR%' THEN 'HR Generalist'
	WHEN job_title LIKE 'IT%' THEN 'IT Support Specialist'
	WHEN job_title LIKE 'Legal%' THEN 'Legal Advisor'
	WHEN job_title LIKE 'N%' THEN 'Network Administrator'
	WHEN job_title LIKE 'Proj%' THEN 'Project Manager'
	WHEN job_title LIKE 'Sales%' THEN 'Sales Representative'
	WHEN job_title LIKE 'Software%' THEN ' Software Engineer'
	WHEN job_title LIKE 'Supply%' THEN 'Supply Chain Coordinator'
	ELSE job_title
END;

UPDATE hr_staging
SET job_title = TRIM(job_title);


-- FIXING MANAGERS TO CORRESPOND TO CORRECT DEPARTMENT
-- IT = DAVID WONG, CUSTOMER SERVICE = JOHN ADAMS, SALES = EMILY ROGERS, FINANCE = MICHAEL CHEN
-- MARKETING = ROBERT WHITE, HR = SARAH LEE, OPERATIONS = JESSICA PATEL
SELECT department, manager
FROM hr_staging
GROUP BY department,manager
ORDER BY manager;

UPDATE hr_staging
SET manager = 
CASE
	WHEN department = 'IT' THEN 'David Wong'
    WHEN department = 'Customer Service' THEN 'John Adams'
    WHEN department = 'Sales' THEN 'Emily Rogers'
    WHEN department = 'Finance' THEN 'Michael Chen'
    WHEN department = 'Marketing' THEN 'Robert White'
    WHEN department = 'HR' THEN 'Sarah Lee'
    WHEN department = 'Operations' THEN 'Jessica Patel'
END;


# CORRECTING JOB_TITLE TO CORRESPOND WITH CORRECT DEPARTMENT
SELECT DISTINCT(job_title)
FROM hr_staging;

SELECT department
FROM hr_staging
GROUP BY department;

UPDATE hr_staging
SET department = 
CASE
	WHEN job_title = 'Customer Support Agent' THEN 'Customer Service'
    WHEN job_title = 'Financial Analyst' THEN 'Finance'
    WHEN job_title = 'SEO Analyst' THEN 'Marketing'
    WHEN job_title = 'Brand Strategist' THEN 'Marketing'
    WHEN job_title = 'Operations Manager' THEN 'Operations'
    WHEN job_title = 'Software Engineer' THEN 'IT'
    WHEN job_title = 'Project Manager' THEN 'Operations'
    WHEN job_title = 'HR Generalist' THEN 'HR'
    WHEN job_title = 'IT Support Specialist' THEN 'IT'
    WHEN job_title = 'Product Manager' THEN 'Operations'
    WHEN job_title = 'Network Administrator' THEN 'IT'
    WHEN job_title = 'Supply Chain Coordinator' THEN 'Operations'
    WHEN job_title = 'Training Coordinator' THEN 'Operations'
    WHEN job_title = 'Data Analyst' THEN 'Operations'
    WHEN job_title = 'Graphic Designer' THEN 'Marketing'
    WHEN job_title = 'Sales Representative' THEN 'Sales'
    WHEN job_title = 'Business Analyst' THEN 'Sales'
    WHEN job_title = 'Marketing Specialist' THEN 'Marketing'
    WHEN job_title = 'Legal Advisor' THEN 'HR'
END;

SELECT *
FROM hr_staging;

-- ADDING AGE GROUP COLUMN
ALTER TABLE hr_staging
ADD COLUMN age_group varchar(255);

UPDATE hr_staging
SET age_group = 
CASE
	WHEN age BETWEEN 18 AND 30 THEN 'Early Career'
    WHEN age BETWEEN 31 AND 50 THEN 'Mid-Career'
    WHEN age >= 51 THEN 'Late Career'
END;

-- FORMATTING PHONE # COLUMN
UPDATE hr_staging
SET phone_number = 
CASE
	WHEN phone_number LIKE '___/___/____' THEN REPLACE(phone_number, '/', '')
    WHEN phone_number LIKE '___-___-____' THEN REPLACE(phone_number, '-','')
    WHEN phone_number LIKE '___.___.____' THEN REPLACE(phone_number, '.','')
    WHEN phone_number LIKE '(___) ___-____' THEN REPLACE(REPLACE(REPLACE(REPLACE(phone_number, '(', ''), ' ', ''), '-', ''), ')', '')
    ELSE phone_number
END;

SELECT phone_number, REPLACE(REPLACE(REPLACE(REPLACE(phone_number, '(', ''), ' ', ''), '-', ''), ')', '') AS updated_phone
FROM hr_staging;          -- TESTING TO MAKE SURE THIS NESTED REPLACE FUNCTION WORKS

SELECT phone_number
FROM hr_staging;

ALTER TABLE hr_staging		-- ADDING COLUMNS TO USE FOR CONCAT
ADD COLUMN L varchar(255),
ADD COLUMN M varchar(255),
ADD COLUMN R varchar(255);

UPDATE hr_staging			-- DATA THAT NEEDS TO BE IN THOSE COLUMNS TO USE CONCAT
SET L = LEFT(phone_number, 3),
	M = SUBSTRING(phone_number, 4, 3),
    R = RIGHT(phone_number, 4);
    
UPDATE hr_staging
SET phone_number = CONCAT(L,'-',M, '-',R);

ALTER TABLE hr_staging		-- REMOVING THOSE COLUMNS AS THEY ARE UNNECESSARY
DROP COLUMN L,
DROP COLUMN M,
DROP COLUMN R;

SELECT *
FROM hr_staging;