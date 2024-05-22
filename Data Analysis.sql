-- Gender breakdown of employees in the company
SELECT gender, count(*) AS count FROM hr
WHERE age >= 18 AND termdate = '0000-00-00' GROUP BY gender;

-- Race/ethnicity breakdown of employees in the company
SELECT race, count(*) AS count FROM hr
WHERE age >= 18 AND termdate = '0000-00-00' GROUP BY race ORDER BY count(*) DESC;

-- Age distribution of employees in the company
SELECT min(age) AS youngest, max(age) AS oldest FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT CASE
	WHEN age >= 21 AND age <= 30 THEN '21-30'
    WHEN age >= 31 AND age <= 40 THEN '31-40'
    WHEN age >= 41 AND age <= 50 THEN '41-50'
    WHEN age >= 51 AND age <= 60 THEN '51-60'
    ELSE '60+'
END AS age_group, count(*) AS count FROM hr WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group ORDER BY age_group;

SELECT CASE
	WHEN age >= 21 AND age <= 30 THEN '21-30'
    WHEN age >= 31 AND age <= 40 THEN '31-40'
    WHEN age >= 41 AND age <= 50 THEN '41-50'
    WHEN age >= 51 AND age <= 60 THEN '51-60'
    ELSE '60+'
END AS age_group, gender, count(*) AS count FROM hr WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender ORDER BY age_group, gender;

-- Employees at HQ vs remote locations
SELECT location, count(*) AS count FROM hr
WHERE age >= 18 AND termdate = '0000-00-00' GROUP BY location;

-- Average length of employment for terminated employees
SELECT round(avg(datediff(termdate, hire_date)/365), 2) AS avg_employment_length FROM hr
WHERE age >= 18 AND termdate < curdate() AND termdate != '0000-00-00';

-- Gender distribution variation across departments
SELECT department, gender, count(*) AS count FROM hr WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender ORDER BY department, gender;

-- Distribution of job titles across the company
SELECT jobtitle, count(*) AS count FROM hr WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle ORDER BY jobtitle;

-- Department having highest turnover (rate at which employees leave the company)
SELECT department, total_count, terminated_count, terminated_count/total_count AS termination_rate
FROM (
	SELECT department, count(*) AS total_count,
    SUM(CASE WHEN termdate != '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
	FROM hr WHERE age >= 18 GROUP BY department
    ) AS subquery ORDER BY termination_rate DESC;

-- Distribution of employees across locations by state
SELECT location_state, count(*) AS count FROM hr
WHERE age >= 18 AND termdate = '0000-00-00' GROUP BY location_state ORDER BY count DESC;

-- Change in employee count over time based on hire and termination dates
SELECT year, hires, terminations, hires-terminations AS net_change, round(((hires-terminations)/hires)*100, 2) AS net_change_percent
FROM (
	SELECT YEAR(hire_date) AS year, count(*) AS hires,
    SUM(CASE WHEN termdate != '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
    FROM hr WHERE age >= 18 GROUP BY year
    ) AS subquery ORDER BY year ASC;

-- Tenure distribution of each department
SELECT department, round(avg(datediff(termdate, hire_date)/365), 2) AS avg_tenure
FROM hr WHERE termdate <= curdate() AND termdate != '0000-00-00' AND age >= 18 GROUP BY department;