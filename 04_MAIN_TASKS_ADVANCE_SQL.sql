SELECT * from books;
SELECT * from branch;
SELECT * from employee;
SELECT * from members;
SELECT * from issued_status;
SELECT * from return_status;

--Advanced SQL Operations

/*Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue.
*/


-- issued_status == members == books == return_status
--  filter books which is return
-- overdue > 30 days

SELECT 
  ist.issued_member_id, 
  m.member_name, 
  b.book_title, 
  ist.issued_date, 
  rs.return_date, 
  CURRENT_DATE - ist.issued_date as over_due_days 
from 
  issued_status as ist 
  JOIN members as m on m.member_id = ist.issued_member_id 
  JOIN books as b ON b.isbn = ist.issued_book_isbn 
  LEFT JOIN return_status as rs ON rs.issued_id = ist.issued_id 
WHERE 
  rs.return_date is NULL 
  AND (CURRENT_DATE - ist.issued_date) > 500
 ORDER BY 6;


/* Task 14: Branch Performance Report
Create a query that generates a performance report for each branch,showing the 
number of books issued, the number of books returned, and the total revenue generated from book rentals.
*/

CREATE TABLE branch_reports AS 
SELECT 
  b.branch_id, 
  b.manager_id, 
  COUNT(ist.issued_id) as number_book_issued, 
  COUNT(rs.return_id) as number_of_book_return, 
  SUM(bk.rental_price) as total_revenue 
FROM 
  issued_status as ist 
  JOIN employee as e ON e.emp_id = ist.issued_emp_id 
  JOIN branch as b ON e.branch_id = b.branch_id 
  LEFT JOIN return_status as rs ON rs.issued_id = ist.issued_id 
  JOIN books as bk ON ist.issued_book_isbn = bk.isbn 
GROUP BY 
  1, 2;

SELECT * FROM branch_reports;


/*Task 15: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
containing members who have issued at least one book in the last 2 months.
*/

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= DATE '2024-08-24' - INTERVAL '6 month'
                    );

SELECT * FROM active_members;

/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.
*/

SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as total_book_issued
FROM issued_status as ist
JOIN
employee as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2
ORDER BY 6 DESC
LIMIT 3;

/*Task 20: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. 
The table should include: The number of overdue books.The total fines, with each day's fine calculated at $0.50. 
The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines
*/
Select isd.issued_member_id , COUNT(isd.issued_id) , SUM(0.50 * GREATEST(CURRENT_DATE - isd.issued_date - 30, 0)) AS total_fines
FROM issued_status as isd
LEFT JOIN
return_status as rs
	ON isd.issued_id = rs.issued_id
	JOIN books as bk
	ON bk.isbn = isd.issued_book_isbn
WHERE rs.return_date IS NULL
AND isd.issued_date <= (DATE '2024-08-24' - INTERVAL '30 days')
GROUP BY 1
ORDER BY 3 DESC;