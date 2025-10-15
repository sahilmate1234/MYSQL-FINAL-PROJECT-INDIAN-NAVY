# 🇮🇳 Indian Navy Database Management System  
### 📘 Project Phase 5 – Final Implementation  
**Author:** Sahil Mate  
**Subject:** Database Management Systems (DBMS)  
**Institution:** [Your College Name]  
**Instructor:** [Instructor Name]  

---

## 📋 Project Overview
This is **Phase 5 (Final Phase)** of the *Indian Navy Database Management System*.  
It demonstrates complete SQL implementation — including DDL, DML, DQL, joins, subqueries, constraints, functions, views, stored procedures, transactions, and triggers — to model real-world naval operations in a relational database.

The system manages data for:
- Personnel and Ranks  
- Ships and Deployments  
- Bases and Maintenance  
- Missions, Operations, and Assets  
- Weapons, Inventory, and Logistics  

---

## 🗂️ Database Used
```sql
USE indian_navy;

🧩 Key Sections Implemented
🔹 1. DDL (Data Definition Language)
Defines and modifies the database schema.
Includes creation, alteration, and deletion of tables.

Highlights:

Created tables: Ranks, Deployments, Ship_Deployments, Maintenance_Records

Added new columns, constraints, and relationships

Implemented CHECK, FOREIGN KEY, and ON DELETE/UPDATE CASCADE

Normalized data by linking Personnel → Ranks

✅ Ensures data integrity and normalization.

🔹 2. DML (Data Manipulation Language)
Used for inserting, updating, and deleting data.

Examples:

Inserted ranks, deployments, and personnel

Updated rank promotions and deployment dates

Recorded maintenance activities

Deleted retired personnel and cancelled deployments

Updated inventory levels

✅ Demonstrates real-time data updates in operational scenarios.

🔹 3. DQL (Data Query Language)
Queries to retrieve and analyze naval data.

Examples:

Ordered personnel by commission date

Listed all active ships and commanding officers

Counted personnel at each base

Displayed weapons with inventory under 50

Found upcoming deployments

✅ Used GROUP BY, ORDER BY, HAVING, and DISTINCT clauses.

🔹 4. Clauses & Operators
Advanced queries using conditions and operators.
Includes:

WHERE, BETWEEN, LIKE, IN, NOT IN, ANY, ALL, IS NULL, LIMIT

Logical and comparison operators

✅ Demonstrates complex filtering and logical operations.

🔹 5. Constraints & Cascades
Ensures data accuracy and referential integrity.

Examples:

PRIMARY KEY, UNIQUE, CHECK, DEFAULT, FOREIGN KEY

ON DELETE CASCADE and ON UPDATE CASCADE

Demonstrated dropping and modifying constraints

✅ Reinforces data consistency and safe cascading relationships.

🔹 6. Joins
Combines data across multiple tables.

Join Types Used:

INNER JOIN – Personnel ↔ Ranks

LEFT JOIN – Ships ↔ Commanding Officers

RIGHT JOIN – Ranks with Personnel

FULL OUTER JOIN (via UNION) – Personnel ↔ Bases

SELF JOIN – Reporting hierarchy simulation

Multi-table JOINs for operations and deployments

✅ Provides comprehensive relational data insights.

🔹 7. Subqueries
Nested queries for advanced data retrieval.

Examples:

Personnel posted at specific bases

Ships commanded by recently commissioned officers

Correlated and nested subqueries

EXISTS, ANY, and ALL subqueries

Updates and filtering using subqueries

✅ Demonstrates powerful data relationships and filtering logic.

🔹 8. SQL Functions
Used for aggregation, string manipulation, and date handling.

Examples:

Aggregate: SUM, AVG, COUNT, MIN, MAX

String: UCASE, LCASE, CONCAT, LENGTH

Date: NOW, DATEDIFF

Numeric: ROUND

✅ Enhances reporting and analysis capability.

🔹 9. Views & CTE (Common Table Expressions)
Simplifies complex queries and improves readability.

Created Views:

V_Senior_Officers – Captains and above

V_Active_Ships_With_CO – Ships and commanding officers

CTEs:

Simple and recursive CTEs for hierarchy and summaries

Multi-level queries for officer-base mapping

✅ Enables modular and reusable query structures.

🔹 10. Stored Procedures
Reusable logic for common database operations.

Examples:

sp_GetPersonnelDetails() – Fetch personnel info

sp_CountShipsByType() – Count ships by type

sp_PromotePersonnel() – Promote personnel

sp_DecommissionShip() – Decommission ship and remove from deployments

sp_AddMaintenance() – Log ship maintenance

✅ Demonstrates parameterized and conditional SQL logic.

🔹 11. Window Functions
Used for analytics and ranking within partitions.

Examples:

RANK(), DENSE_RANK(), ROW_NUMBER()

LAG() / LEAD() for ship history comparison

SUM() OVER(PARTITION BY …) to count personnel per rank

✅ Delivers insightful analytics without losing row-level data.

🔹 12. Transactions
Implements atomic operations for reliability.

Examples:

COMMIT / ROLLBACK for safe updates

SAVEPOINT for partial rollbacks

Multi-table transactions for personnel transfer or base retirement

✅ Ensures data integrity and rollback safety.

🔹 13. Triggers
Automates database responses to events.

Examples:

BEFORE INSERT → Convert ship names to uppercase

AFTER UPDATE → Log promotions into Promotion_History

BEFORE DELETE → Prevent deleting ships on deployment

AFTER INSERT → Notify when senior officers are added

BEFORE UPDATE → Block editing ship commission dates

✅ Adds automation, validation, and auditing.

⚙️ SQL Concepts Summary
Category	Features Implemented
DDL	CREATE, ALTER, DROP, CONSTRAINTS
DML	INSERT, UPDATE, DELETE
DQL	SELECT, JOINS, SUBQUERIES
Constraints	PRIMARY, FOREIGN, UNIQUE, CHECK, DEFAULT
Procedural SQL	Stored Procedures, Triggers
Analytical SQL	Window Functions
Transactions	COMMIT, ROLLBACK, SAVEPOINT
Security & Integrity	Cascading Constraints, Validations

🧰 Tools Used
Tool	Purpose
MySQL / MariaDB	Database Engine
MySQL Workbench	Query Execution
VS Code / Notepad++	SQL Script Editing
ERD Tool	Schema Visualization

🚀 How to Run
Open MySQL Workbench or equivalent SQL environment.

Execute:

sql
Copy code
USE indian_navy;
Run the SQL file:

sql
Copy code
SOURCE PROJECT PHASE -5 SAHIL MATE INDIAN NAVY.sql;
Validate outputs:

sql
Copy code
SHOW PROCEDURE STATUS;
SHOW TRIGGERS;
SELECT * FROM V_Senior_Officers;
💡 Learning Outcomes
✅ Mastered advanced SQL concepts (DDL–DCL)
✅ Implemented procedural programming using triggers and procedures
✅ Practiced secure and atomic data transactions
✅ Designed normalized and scalable schema
✅ Simulated real-world military database operations

🏁 Conclusion
This final phase represents a complete and production-grade database system for the Indian Navy.
It covers all SQL operations, ensures data integrity, and demonstrates real-world database engineering skills.


