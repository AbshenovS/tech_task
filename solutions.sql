-- 1-Task
SELECT e.first_name || ' ' || e.last_name AS fullname, s.salary, t.title
FROM employees e
JOIN dept_employees de
ON e.emp_id = de.emp_id
JOIN departments d
ON de.dept_id = d.dept_id
JOIN salaries s
ON e.emp_id = s.emp_id
JOIN titles t
ON e.title_id = t.title_id
WHERE e.first_name = 'David' AND d.dept_name = 'Engineering'
;


-- 2-Task
SELECT d.dept_name, AVG(s.salary) FROM departments d
JOIN dept_employees de
ON d.dept_id = de.dept_id
JOIN employees e
ON de.emp_id = e.emp_id
JOIN salaries s
ON e.emp_id = s.emp_id
WHERE de.to_date IS NULL
GROUP BY d.dept_name
;


-- 3-Task
SELECT t.title, AVG(s.salary),
	   CASE WHEN AVG(s.salary) > (SELECT AVG(salary) FROM salaries s) THEN 'YES'
	   		ELSE 'NO'
	   END
FROM salaries s
JOIN employees e
ON s.emp_id = e.emp_id
JOIN titles t
ON e.title_id = t.title_id
GROUP BY t.title
;


-- 4-task
CREATE OR REPLACE FUNCTION dept_employees_json(title_name varchar)
RETURNS SETOF json
AS
$$
WITH cte AS (
    SELECT
        d.dept_name AS department_name,
        json_agg(e.first_name || ' ' || e.last_name) AS employees
    FROM
    	employees e
    	JOIN dept_employees de
    	ON e.emp_id = de.emp_id
        JOIN departments d
        ON d.dept_id = de.dept_id
        WHERE e.hire_date  > '2020-12-31' AND d.dept_name IN (
        	SELECT DISTINCT d.dept_name FROM titles t
			JOIN employees e
			ON e.title_id = t.title_id
			JOIN dept_employees de
			ON e.emp_id = de.emp_id
			JOIN departments d
			ON de.dept_id = d.dept_id
			WHERE t.title = title_name
        )
    GROUP BY d.dept_name
)
SELECT
    json_agg((row_to_json(cte.*)))
FROM
    cte;
$$
LANGUAGE SQL;


CREATE OR REPLACE VIEW data_by_titles AS
SELECT  t.title,
		ARRAY_AGG(DISTINCT d.dept_name) AS depertamets_of_title,
		dept_employees_json(t.title), AVG(s.salary)
FROM titles t
	JOIN employees e
	ON e.title_id = t.title_id
	JOIN salaries s
	ON e.emp_id = s.emp_id
	JOIN dept_employees de
	ON e.emp_id = de.emp_id
	JOIN departments d
	ON de.dept_id = d.dept_id
	GROUP BY t.title
;

SELECT * FROM data_by_titles;
