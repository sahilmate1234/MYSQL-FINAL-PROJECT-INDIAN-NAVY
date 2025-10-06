# ⚓ Indian Navy SQL Database System
### 🚀 DBMS Final Project by *Sahil Mate*

---

## 🧭 Overview
The **Indian Navy SQL Database System** is a comprehensive relational database project designed to model and manage various real-world operations of the Indian Navy.  
It covers personnel management, ships and aircraft tracking, logistics, training programs, operations, medical records, and maintenance scheduling — all within a robust SQL-based framework.

This project demonstrates advanced **Database Management System (DBMS)** concepts including:
- Data normalization
- Primary & foreign key constraints
- Data integrity
- Relational joins
- Real-world SQL operations (DDL, DML, DQL)
- Advanced querying and data analysis

---

## 🧩 Project Objectives
- To design a **realistic defense-grade naval database** using MySQL.
- To implement **data relationships and constraints** across multiple entities.
- To perform **real-life analytical queries** for operational insights.
- To showcase full coverage of **DBMS commands** including CREATE, INSERT, UPDATE, DELETE, ALTER, DROP, and TRUNCATE.

---

## 🏗️ Database Structure

### 📘 Database Name
`indian_navy`

### 📊 Tables (13 Total)
| No. | Table Name | Description |
|-----|-------------|-------------|
| 1 | `Personnel` | Stores data of all naval officers and sailors. |
| 2 | `Ships` | Contains detailed information about naval ships. |
| 3 | `Bases` | Stores geographical and logistical info on naval bases. |
| 4 | `Aircraft` | Maintains details of all aircraft in the Navy. |
| 5 | `Squadrons` | Details of naval air squadrons and their roles. |
| 6 | `Weapons` | Catalog of all weapon systems used by the Navy. |
| 7 | `Operations` | Records of missions, exercises, and naval operations. |
| 8 | `Maintenance_Schedule` | Logs for ships, aircraft, and equipment maintenance. |
| 9 | `Training_Courses` | Information about training programs and academies. |
| 10 | `Personnel_Enlistment` | Tracks personnel training enrollment and performance. |
| 11 | `Medical_Records` | Health and medical data of naval personnel. |
| 12 | `Logistics_Supply` | Inventory management for fuel, ammo, rations, and spares. |
| 13 | `Communication_Logs` | Secure logs of naval communications. |

---

## 🧱 Key Features
✅ 13 relational tables with **real-world attributes and constraints**  
✅ 200+ **INSERT statements** with realistic sample data  
✅ Implementation of **Primary, Foreign Keys, and Integrity Constraints**  
✅ 100+ **Operational SQL Queries**:
- SELECT with WHERE, GROUP BY, HAVING, and JOINS  
- UPDATE, DELETE, and ALTER operations  
- DDL, DML, and DQL statements  
✅ Supports **real-time naval scenarios** like fleet exercises, base logistics, personnel management, and maintenance tracking.  

---

## 🛠️ Technologies Used
- **Database:** MySQL  
- **Query Language:** SQL  
- **Tools:** MySQL Workbench / phpMyAdmin / VS Code  
- **Documentation:** Markdown / PDF  

---

## 🔍 Sample Operations
```sql
-- Display all active ships
SELECT ship_name, ship_type, commission_date
FROM Ships
WHERE current_status = 'Active';

-- Find personnel trained in Anti-Submarine Warfare
SELECT p.full_name, t.course_name
FROM Personnel p
JOIN Personnel_Enlistment e ON p.personnel_id = e.personnel_id
JOIN Training_Courses t ON e.course_id = t.course_id
WHERE t.course_name LIKE '%Submarine%';

-- Show all ongoing maintenance schedules
SELECT asset_type, maintenance_type, status
FROM Maintenance_Schedule
WHERE status = 'In Progress';

🧠 Concepts Demonstrated

Database Design & Normalization

Primary & Foreign Key Relationships

Referential Integrity

Joins (INNER, LEFT, RIGHT)

Aggregate Functions & Clauses

Subqueries & Nested Queries

Data Definition Language (DDL)

Data Manipulation Language (DML)

Data Query Language (DQL)

Safe Updates & Cascading Constraints

📈 Real-Life Applications

Naval personnel and ship record management

Fleet and base coordination

Maintenance and operations scheduling

Logistics and inventory control

Training and medical administration

🏁 Project Output

Database File: PROJECT PHASE -1 SAHIL MATE INDIAN NAVY.sql

Total Tables: 13

Total Records: 200+

Queries: 100+ (DDL, DML, DQL, JOINs, Subqueries, Functions)

👨‍💻 Author

Sahil Mate
📚 DBMS Project | Indian Navy SQL Database
🏫 [Your Institution Name]
📧 [Your Email Address]

🏅 Acknowledgment

Special thanks to the Department of Computer Science and DBMS Faculty for guidance in developing this real-world SQL implementation.

📎 License

This project is created for academic and educational purposes only.
Unauthorized duplication or redistribution is prohibited.
