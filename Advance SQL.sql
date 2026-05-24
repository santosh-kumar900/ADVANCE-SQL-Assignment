
Create database Advance_SQL;
use Advance_SQL;
/*
Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?
Answer 1: A common Talbe Expression (CTE) is a named temporary result set defined within the execution scope of a single SQL statement. 
It is created using the With caluse and can be operations. CETs can be thought of as a way to create a virtual table that can be used in
 subsequent queries.
 How CTEs imporve Readability
 * Top down logic: You define the data subsets first, then query them at the bottom.
 * No nested mess: They replace complex, deeply nested subquries with a clean structure.
 * Code reuse : You can reference the same CTE multiple times in one query without rewriting code.
 * Modular design: They break massive, intimidating query into smaller, logical blocks.
 * Self documenting: Descriptive CTE names act like variable, explaining what the data represents.


Q2. Why are some views updatable while others are read-only? Explain with an example.
Answer 2: A view is updatable only if the database system can map changes directly back to a single, 
unique row in a single underlying base table. If the relationship between the view's rows and the source table's rows is not strictly 1:1, 
the view becomes read-only because the database engine cannot determine exactly which raw records to modi

Why the Distinction Exists
Updatable Views: Act as a transparent window. They select columns directly from a single table without changing the grain of the data.
Read-Only Views: Act as summarized reports. They lose the 1:1 relationship with the base table by using clauses like DISTINCT, GROUP BY, 
mathematical calculations, or complex JOIN operations
*/
Drop table EmployeeSales;
Create table EmployeeSales(
Employee_id Int,
Region Varchar(10),
Salese_Amount int);

Insert into EmployeeSales(Employee_id, Region, Salese_Amount) values
(101, 'North', 5000),
(101, 'South', 3000),
(102, 'North', 4000);


/*1. The Updatable View (Direct 1:1 Mapping)
This view filters data but preserves every row exactly as it is in the table. */
CREATE VIEW NorthRegionSales AS
SELECT Employee_id, Salese_Amount 
FROM EmployeeSales
WHERE Region = 'North';

/* Why it is updatable: 
If you run UPDATE NorthRegionSales SET SalesAmount = 5500 WHERE EmployeeID = 101;, the engine looks at the view,
traces it back to the first row of EmployeeSales, and updates 5000 to 5500 without any ambiguity.
*/

/* 2. The Read-Only View (Aggregated Data)
This view condenses multiple records into a summary using an aggregate function. */
CREATE VIEW TotalSalesPerEmployee AS
SELECT Employee_id, SUM(Salese_Amount) AS TotalSales
FROM EmployeeSales
GROUP BY Employee_id;

/* Why it is read-only: The view outputs EmployeeID: 101, TotalSales: 8000. If you try to run UPDATE 
TotalSalesPerEmployee SET TotalSales = 9000 WHERE EmployeeID = 101;, the database engine will reject it.
 It does not know whether to add the extra 1,000 to the North row, the South row, or split it between both.
*/

/* Q3. What advantages do stored procedures offer compared to writing raw SQL queries repeatedly?
Answer 3: Stored procedures offer a significant advantage because they compile and store SQL code directly on the database server, 
rather than sending and processing raw text from an application over and over. This architectural difference provides immediate 
benefits across performance, security, and maintenance.

Key AdvantagesBetter Performance:
 Databases compile and optimize stored procedures into an execution plan once. Subsequent executions reuse this plan, saving parsing time.
 Reduced Network Traffic: Applications send a short execution command (e.g., EXEC GetMonthlyReport 2026) instead of transferring hundreds 
 of lines of raw SQL text over the network.
 Enhanced Security: They prevent SQL injection attacks by forcing the use of strongly-typed input parameters. 
 They also allow administrators to give users access to specific data through the procedure without granting them direct access to the underlying tables.
 Centralized Maintenance: If a business rule or database schema changes, you update the logic once in the stored procedure.
 You do not need to hunt down, rewrite, and redeploy code across multiple application servers.
 Business Logic Encapsulation: Complex multi-step operations, error handling, and transaction logic are bundled together, 
 ensuring data is processed consistently no matter what application calls it.
*/
/* Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.
Answer 4. The primary purpose of a trigger is to automatically execute a pre-defined set of SQL statements in response to a specific event, 
such as an INSERT, UPDATE, or DELETE statement on a table. They enforce data integrity and business rules automatically
 at the database level, ensuring nothing is missed even if an application bypasses standard code paths.
 Key PurposesAutomated Auditing: They track data changes by capturing who modified a record, what the old values were, and when the change occurred.
 Complex Data Validation: They enforce integrity rules that are too complex for standard CHECK constraints, 
 such as comparing input data against other tables.
 Automated Data Syncing: They can automatically update summary tables, calculate derived values, or mirror data into secondary
 tables whenever main records change.
 Preventing Invalid Changes: They can evaluate an action before it commits and roll back the transaction if it violates business policies.
 Essential Use Case: Creating an Immutable Audit Trail
 A trigger is essential when you must guarantee an unalterable, comprehensive audit log of sensitive data changes 
 (like financial records or user permissions) that cannot be bypassed by any  user or application script.
 
 If an application developer or a database administrator modifies data directly via a raw SQL script instead of using the application interface,
 application-level logging fails. A database trigger catches the change regardless of where it originates.


/*
Q5. Explain the need for data modelling and normalization when designing a database.
Anwer 5:  Data modeling and normalization are essential because they transform chaotic real-world information into an organized,
 efficient, and error-free database structure. Without these two steps, databases become slow, prone to data corruption, 
 and difficult to update.
 1. The Need for Data Modeling (The Blueprint)
 Data modeling is the process of creating a visual map of your data, its attributes, and how different pieces of information relate
 to one another.
 Bridges Business and Tech: It converts complex business requirements into clear diagrams (like Entity-Relationship Diagrams) 
 that both stakeholders and developers understand.
 Prevents Scope Creep: Mapping data before writing code ensures you do not miss critical requirements, saving massive rewrite costs later.
 Sets Clear Relationships: It defines exactly how entities interact—such as whether a customer can have multiple orders (one-to-many) 
 or if an author can write multiple books (many-to-many).
 
 2. The Need for Normalization (The Cleanup)
 Normalization is the systematic process of organizing columns and tables to eliminate data redundancy (duplication) and prevent data 
 anomalies (errors). It involves breaking down large, flat tables into smaller, focused tables.
 The Big Problems Normalization Solves:
 Insertion Anomaly: Being unable to add new data because it relies on other missing data. (e.g., You cannot add a new course to a university 
 system because no students have enrolled in it yet).
 Update Anomaly: Updating a value in one place but forgetting to update its duplicates elsewhere, resulting in conflicting records. 
 (e.g., Changing a customer's address in one order record but leaving their old address in another).
 Deletion Anomaly: Accidentally deleting critical background information when removing a record. (e.g., Deleting a student's profile
 and unintentionally destroying the only record of a professor's department).
*/
use advance_sql;

Create Table Products(
	ProductID INT Primary Key,
    ProductName Varchar(100),
    Category Varchar(50),
    Price Decimal(10,2)
    );
    
Insert into Products Values
(1, 'Keyboard', 'Electronics', 1200),
(2, 'Mouse', 'Electronics', 800),
(3, 'Chair', 'Funiture', 2500),
(4, 'Desk', 'Funiture', 5500);


Create Table Sales(
SalesID INT Primary Key,
ProductID INT,
Quantity INT,
SalesDate Date,
Foreign key (ProductID) references products(ProductID)
);

Insert Into Sales Values 
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'), 
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11');



/* Q6. Write a CTE to calculate the total revenue for each product
 (Revenues = Price × Quantity), and return only products where  revenue > 3000. */
 
 WITH total_revenue AS (
	SELECT P.*, s.Quantity, (p.Price*s.Quantity) AS Revenue
    From Products p
    Join Sales s
    ON p.ProductID = s.ProductID
    Having Revenue > 3000)
    SELECT * FROM total_revenue;

/* Q7. Create a view named vw_CategorySummary that shows:
 Category, TotalProducts, AveragePrice. */
 
 CREATE VIEW vw_CategorySummary AS
 SELECT Category, count(ProductName) AS TotalProducts, avg(Price) As AveragePrice
 From products
 Group by Category;

/*Q8. Create an updatable view containing ProductID, ProductName, and Price.
 Then update the price of ProductID = 1 using the view. */
 
 CREATE OR REPLACE VIEW Updatable_view  AS
 SELECT  ProductID, ProductName, Price
 From Products;
 
 Select * from Updatable_view;
 Update Updatable_view
 SET Price = 1500
 Where ProductID = 1;
 
 
 
 /* Q9. Create a stored procedure that accepts a category name and returns all products belonging to that
category. */

DELIMITER $$

CREATE PROCEDURE GetProductsByCategory (IN cat_name VARCHAR(50))
BEGIN 
	SELECT * FROM products
    WHERE category = cat_name;
END $$
DELIMITER ;

Call GetProductsByCategory('Electronics');



/*
Q10. Create an AFTER DELETE trigger on Products the table that archives deleted product rows into a new
table ProductArchive. The archive should store ProductID, ProductName, Category, Price, and DeletedAt
timestamp.
*/

Create Table ProductArchive (
	ProductID Int,
    ProductName varchar(50),
    Category varchar(50),
    Price decimal(10,2),
    DeletedAt timestamp Default);
    
    
DELIMITER $$

Create trigger After_Product_Delete
AFTER Delete ON Products
For Each Row
begin
	insert into ProductArchive(ProductID, ProductName, Category, Price, DeletedAt)
    values (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price, NOw());
END $$

DELIMITER ;


