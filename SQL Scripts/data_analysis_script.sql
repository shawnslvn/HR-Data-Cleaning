-- DETERMINING HOW MANY EMPLOYEES FALL INTO EACH CATEGORY
-- LATE CAREER = 30 -- MID-CAREER = 46 -- EARLY CARREER = 24
SELECT age_group, COUNT(age_group) AS total
FROM hr_staging
GROUP BY age_group;

-- DETERMINING HOW MANY EMPLOYEES FALL INTO EACH CATEGORY
-- MALE = 44 -- FEMALE = 56
SELECT gender, COUNT(gender) as total
FROM hr_staging
GROUP BY gender;

-- DETERMINING HOW MANY EMPLOYEES FALL INTO EACH CATEGORY
-- PART-TIME = 33 -- FULL-TIME = 37 -- CONTRACT = 30
SELECT employment_status, COUNT(employment_status) AS total
FROM hr_staging
GROUP BY employment_status;

-- DETERMINING HOW MANY EMPLOYEES ARE UNDER EACH DEPARTMENT
-- CUST SERV = 5 -- FIN = 13 -- MARK = 21 -- OPER = 29 -- IT = 21 -- HR = 6 -- SALES = 5
SELECT department, COUNT(department)
FROM hr_staging
GROUP BY department;

-- DETERMINING MAX, MIN, AVG EMPLOYMENT AGE
SELECT MAX(age) AS oldest, MIN(age) AS youngest, ROUND(AVG(age),0) as average, 'Both'
FROM hr_staging
	UNION ALL
SELECT MAX(age) AS female_oldest, MIN(age) AS female_youngest, ROUND(AVG(age),0) as female_average, 'Female'
FROM hr_staging
WHERE gender = 'Female'
	UNION ALL
SELECT MAX(age) AS male_oldest, MIN(age) AS male_youngest, ROUND(AVG(age),0) as male_average, 'Male'
FROM hr_staging
WHERE gender = 'Male';

-- DETERMINING MAX, MIN, AVG SALARY
SELECT MAX(salary) AS highest,
	MIN(salary) AS lowest,
    ROUND(AVG(salary),0) as average
FROM hr_staging;

-- SALARY METRICS BY GENDER
SELECT gender, MIN(salary) AS lowest,
	ROUND(AVG(salary),0) AS average,
    MAX(salary) AS highest
FROM hr_staging
WHERE gender = 'female'
	UNION ALL
SELECT gender, MIN(salary) AS lowest,
	ROUND(AVG(salary),0) AS average,
    MAX(salary) AS highest
FROM hr_staging
WHERE gender = 'male';

-- SALARY METRICS BY AGE GROUP
SELECT age_group, MIN(salary) AS lowest,
	ROUND(AVG(salary),0) AS average,
    MAX(salary) AS highest
FROM hr_staging
WHERE age_group = 'Early Career'
	UNION ALL
SELECT age_group, MIN(salary) AS lowest,
	ROUND(AVG(salary),0) AS average,
    MAX(salary) AS highest
FROM hr_staging
WHERE age_group = 'Mid-Career'
	UNION ALL
SELECT age_group, MIN(salary) AS lowest,
	ROUND(AVG(salary),0) AS average,
    MAX(salary) AS highest
FROM hr_staging
WHERE age_group = 'Late Career';

-- GENERATE COMPANY EMAILS
WITH email_generation AS
(
SELECT LOWER(CONCAT(first_name, last_name)) AS email_start
FROM hr_staging
)
SELECT CONCAT(email_start, '@fakecompany.com') AS email
FROM email_generation;

-- DETERMINE # OF DIRECT REPORTS FOR EACH MANAGER
SELECT manager, COUNT(*) AS direct_reports
FROM hr_staging
GROUP BY manager;

-- OLDEST AND NEWEST EMPLOYEE
SELECT hr1.employee_id, hr1.hire_date, 'Oldest Hire' AS hire_type
FROM hr_staging AS hr1
WHERE hr1.hire_date = (SELECT MAX(hire_date) FROM hr_staging)
	UNION ALL
SELECT hr2.employee_id, hr2.hire_date, 'Newest Hire' AS hire_type
FROM hr_staging AS hr2
WHERE hr2.hire_date = (SELECT MIN(hire_date) FROM hr_staging);

-- DETERMINING RAISES FOR ALL DEPARTMENTS
-- HR = 3% -- Customer Service = 4% -- Finance = 5% -- Marketing = 2% -- Operations = 0% -- IT = 3% -- Sales = 5%
SELECT DISTINCT(department)
FROM hr_staging;

SELECT employee_id, full_name, salary,
	CASE
		WHEN department = 'Marketing' THEN ROUND((salary*1.02),0)
        WHEN department = 'HR' OR department = 'IT' THEN ROUND((salary*1.03),0)
        WHEN department = 'Customer Service' THEN ROUND((salary*1.04),0)
        WHEN department = 'Sales' OR department = 'Finance' THEN ROUND((salary*1.05),0)
        ELSE salary
	END AS new_salary,
    department
FROM hr_staging;

SELECT DISTINCT(age_group)
FROM hr_staging;











