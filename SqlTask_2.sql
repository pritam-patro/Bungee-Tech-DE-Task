/* The Question
Table: Employee
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| departmentId | int     |
+--------------+---------+

id is the primary key column for this table.
departmentId is a foreign key of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.

Table: Salary
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| employeeid   | int     |
| salary       | varchar |
+--------------+---------+

Table: Department
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+

id is the primary key column for this table.
Each row of this table indicates the ID of a department and its name.
Q1 :: Employees with same last name and different departments.
output format :: (employee1_name,department1_name, employee2_name, department2_name)
Q2 ::  Top 3 salaries department wise
       output format ::  (department, employee_name, salary) 
Q3 ::  Salaries that are lower than average salary of department.
		output format  :: (department, employee_name, salary)
*/

/* Making the tables */

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    departmentId INT
);

INSERT INTO Employee (id, name, departmentId)
VALUES 
(1, 'Aarav Sharma', 1),
(2, 'Isha Verma', 2),
(3, 'Nisha Gupta', 3),
(4, 'Rohan Singh', 2),
(5, 'Priya Kumar', 1),
(6, 'Kabir Mehta', 3),
(7, 'Aditi Joshi', 4),
(8, 'Riya Nair', 5),
(9, 'Aditya Patel', 1),
(10, 'Arjun Deshmukh', 2),
(11, 'Rakesh Roy', 4),
(12, 'Sneha Pillai', 5),
(13, 'Meera Iyer', 3),
(14, 'Kavya Das', 1),
(15, 'Vikram Rao', 2);


CREATE TABLE Salary (
    employeeid INT,
    salary VARCHAR(20)
);

INSERT INTO Salary (employeeid, salary)
VALUES 
(1, '5000'),
(2, '6000'),
(3, '7000'),
(4, '8000'),
(5, '9000'),
(6, '10000'),
(7, '11000'),
(8, '12000'),
(9, '4000'),
(10, '3000'),
(11, '9500'),
(12, '8500'),
(13, '6500'),
(14, '5500'),
(15, '7500');

CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO Department (id, name)
VALUES 
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering'),
(4, 'Marketing'),
(5, 'Sales');


/* Q1 */
SELECT 
    e1.name AS employee1_name, 
    d1.name AS department1_name, 
    e2.name AS employee2_name, 
    d2.name AS department2_name
FROM Employee e1
JOIN Employee e2 ON e1.id != e2.id
    AND SUBSTRING_INDEX(e1.name, ' ', -1) = SUBSTRING_INDEX(e2.name, ' ', -1)
    AND e1.departmentId != e2.departmentId
JOIN Department d1 ON e1.departmentId = d1.id
JOIN Department d2 ON e2.departmentId = d2.id;


/* Q2 */
WITH RankedSalaries AS (
    SELECT 
        d.name AS department, 
        e.name AS employee_name, 
        CAST(s.salary AS FLOAT) AS salary,
        ROW_NUMBER() OVER (PARTITION BY d.id ORDER BY CAST(s.salary AS FLOAT) DESC) AS rank
    FROM Employee e
    JOIN Salary s ON e.id = s.employeeid
    JOIN Department d ON e.departmentId = d.id
)
SELECT department, employee_name, salary
FROM RankedSalaries
WHERE rank <= 3;

/* Q3 */
WITH DepartmentAverageSalary AS (
    SELECT 
        e.departmentId, 
        AVG(CAST(s.salary AS FLOAT)) AS avg_salary
    FROM Employee e
    JOIN Salary s ON e.id = s.employeeid
    GROUP BY e.departmentId
)
SELECT 
    d.name AS department, 
    e.name AS employee_name, 
    CAST(s.salary AS FLOAT) AS salary
FROM Employee e
JOIN Salary s ON e.id = s.employeeid
JOIN Department d ON e.departmentId = d.id
JOIN DepartmentAverageSalary das ON e.departmentId = das.departmentId
WHERE CAST(s.salary AS FLOAT) < das.avg_salary;
