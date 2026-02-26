Leetcode

175. Combine Two Tables
SELECT p.firstName, p.lastName, a.city, a.state FROM Person p LEFT JOIN Address a ON p.personId = a.personId;#

181. Employees Earning More Than Their Managers
SELECT e1.name AS Employee FROM Employee e1 JOIN Employee e2 ON e1.managerId = e2.id WHERE e1.salary > e2.salary;