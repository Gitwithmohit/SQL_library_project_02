-- Library Management System Project 2

-- Creating Branch Table
DROP TABLE IF EXISTS branch;
Create Table branch
	(
		branch_id VARCHAR(50) PRIMARY KEY,
		manager_id VARCHAR(50),
		branch_address VARCHAR(50),
		contact_no VARCHAR(50)
	);

-- Creating Employee Table
DROP TABLE IF EXISTS employee;
Create Table employee
	(
		emp_id VARCHAR(10) PRIMARY KEY,
		emp_name VARCHAR(25),
		position VARCHAR(15),
		salary INT,
		branch_id VARCHAR(25)
	);

ALTER TABLE employee
RENAME COLUMN position TO positions;

-- Creating books Table
DROP TABLE IF EXISTS books;
Create Table books
	(
		isbn VARCHAR(20) PRIMARY KEY,
		book_title VARCHAR(75),
		category VARCHAR(25),
		rental_price FLOAT,
		status VARCHAR(10),
		author VARCHAR(50),
		publisher VARCHAR(30)
	);

-- Creating members TABLE
DROP TABLE IF EXISTS members;
Create Table members
	(
		member_id VARCHAR(10) PRIMARY KEY,
		member_name VARCHAR(25),
		member_address VARCHAR(25),
		reg_date DATE
	);

-- Creating issued_status table
DROP TABLE IF EXISTS issued_status;
Create Table issued_status
	(issued_id VARCHAR(10) PRIMARY KEY,
	issued_member_id VARCHAR(10), --FK
	issued_book_name VARCHAR(60),
	issued_date DATE,
	issued_book_isbn VARCHAR(20), --FK
	issued_emp_id VARCHAR(10)  --FK
	);

-- Creating return_status table
DROP TABLE IF EXISTS return_status;
Create Table return_status
	(
		return_id VARCHAR(10) PRIMARY KEY,
		issued_id VARCHAR(10),
		return_book_name VARCHAR(75),
		return_date DATE,
		return_book_isbn VARCHAR(20)
	);

-- FOREIGN KEY

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employee
FOREIGN KEY (issued_emp_id)
REFERENCES employee(emp_id);

ALTER TABLE employee
ADD CONSTRAINT fk_branch_id
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_return_books
FOREIGN KEY (return_book_isbn)
REFERENCES books(isbn);

ALTER TABLE return_status
DROP CONSTRAINT fk_return_books;
