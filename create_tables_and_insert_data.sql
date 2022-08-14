-- Commands to create tables in the schema adata_task
CREATE TABLE titles (
	title_id SERIAL PRIMARY KEY,
	title VARCHAR(20) NOT NULL
);


CREATE TABLE grades (
	grade_id serial PRIMARY KEY,
	grade VARCHAR(10) NOT NULL,
	level SMALLINT NOT NULL DEFAULT 1
);


CREATE TABLE employees (
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	birthday_date DATE NOT NULL,
	gender VARCHAR(8),
	hire_date DATE NOT NULL,
	title_id INTEGER NOT NULL,
	grade_id INTEGER NOT NULL,
	FOREIGN KEY (title_id) REFERENCES titles(title_id),
	FOREIGN KEY (grade_id) REFERENCES grades(grade_id)
);


CREATE TABLE departments (
	dept_id SERIAL PRIMARY KEY,
	dept_name VARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE dept_managers (
	dept_id INTEGER NOT NULL,
	emp_id INTEGER PRIMARY KEY,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE,
	FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);


CREATE TABLE dept_employees (
	emp_id INTEGER NOT NULL,
	dept_id INTEGER NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	PRIMARY KEY (emp_id, from_date),
	FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE,
	FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);


CREATE TABLE salaries (
	emp_id INTEGER PRIMARY KEY,
	salary INTEGER NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);


-- Insert mock data
INSERT INTO titles(title) VALUES('Software Engineer');
INSERT INTO titles(title) VALUES('Manager');
INSERT INTO titles(title) VALUES('QA');
INSERT INTO titles(title) VALUES('Data Engieer');
INSERT INTO titles(title) VALUES('Analyst');
INSERT INTO titles(title) VALUES('UX designer');


INSERT INTO grades(grade) VALUES('Junior');
INSERT INTO grades(grade, "level") VALUES('Junior', 2);
INSERT INTO grades(grade, "level") VALUES('Junior', 3);
INSERT INTO grades(grade) VALUES('Middle');
INSERT INTO grades(grade, "level") VALUES('Middle', 2);
INSERT INTO grades(grade, "level") VALUES('Middle', 3);
INSERT INTO grades(grade) VALUES('Senior');
INSERT INTO grades(grade, "level") VALUES('Senior', 2);
INSERT INTO grades(grade, "level") VALUES('Senior', 3);


INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('David', 'Lee', '1989-02-14', 'male', '2019-03-07', 1, 5);
INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('Harry', 'Kane', '1990-05-08', 'male', '2020-05-17', 1, 1);
INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('Moo', 'Salah', '1989-12-15', 'male', '2018-07-01', 1, 4);
INSERT INTO employees(first_name, last_name, birthday_date, hire_date, title_id, grade_id)
	VALUES('Rahim', 'Sterlinh', '1995-12-16', '2022-08-27', 1, 5);
INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('David', 'Freedman', '1999-10-21', 'male', '2020-08-09', 2, 2);
INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('David', 'Dave', '1997-05-22', 'male', '2020-07-19', 2, 3);
INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('Serena', 'Williams', '1995-04-09', 'female', '2019-03-29', 2, 5);
INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('Liza', 'Harry', '2000-11-29', 'female', '2021-03-07', 3, 3);
INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('David', 'Musk', '2001-03-31', 'male', '2020-08-13', 3, 4);
INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('Arnold', 'Bernard', '1990-01-02', 'male', '2022-01-17', 4, 2);
INSERT INTO employees(first_name, last_name, birthday_date, gender, hire_date, title_id, grade_id)
	VALUES('Germiona', 'Ron', '2002-11-29', 'female', '2022-03-06', 4, 6);
INSERT INTO employees(first_name, last_name, birthday_date, hire_date, title_id, grade_id)
	VALUES('Tom', 'Felton', '2001-02-14', '2022-03-08', 6, 1);


INSERT INTO departments(dept_name) VALUES('Engineering');
INSERT INTO departments(dept_name) VALUES('RnD');
INSERT INTO departments(dept_name) VALUES('Logistics');


INSERT INTO dept_managers(dept_id, emp_id, from_date, to_date) VALUES(1, 1, '2019-08-05', '2022-08-26');
INSERT INTO dept_managers(dept_id, emp_id, from_date) VALUES(1, 4, '2022-08-27');
INSERT INTO dept_managers(dept_id, emp_id, from_date) VALUES(2, 2, '2021-12-11');
INSERT INTO dept_managers(dept_id, emp_id, from_date) VALUES(3, 11, '2022-05-13');


INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(1, 1, '2019-03-07');
INSERT INTO dept_employees(emp_id, dept_id, from_date, to_date) VALUES(2, 1, '2020-05-17', '2021-01-01');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(2, 2, '2021-01-02');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(3, 1, '2018-07-11');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(4, 2, '2021-08-27');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(5, 3, '2020-08-09');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(6, 1, '2020-07-19');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(7, 3, '2019-03-29');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(8, 2, '2021-03-07');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(9, 2, '2020-08-19');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(10, 1, '2022-01-17');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(11, 3, '2022-03-06');
INSERT INTO dept_employees(emp_id, dept_id, from_date) VALUES(12, 2, '2022-03-08');


INSERT INTO salaries(emp_id, salary, from_date) VALUES(1, 220000, '2019-03-07');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(2, 85000, '2021-01-02');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(3, 155000, '2018-07-11');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(4, 200000, '2021-08-27');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(5, 170000, '2020-08-09');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(6, 95000, '2020-07-19');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(7, 195000, '2019-03-29');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(8, 178000, '2021-03-07');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(9, 180000, '2020-08-19');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(10, 110000, '2022-01-17');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(11, 250000, '2022-03-06');
INSERT INTO salaries(emp_id, salary, from_date) VALUES(12, 90000, '2022-03-08');


SELECT * FROM titles t;
SELECT * FROM grades g;
SELECT * FROM employees e;
SELECT * FROM departments d;
SELECT * FROM dept_managers dm;
SELECT * FROM dept_employees de;
SELECT * FROM salaries s;

