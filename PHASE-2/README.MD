# ⚓ Indian Navy SQL Database System – Phase 2  
### sqlProject by *Sahil Mate*

---

## 🧭 Project Overview
This project — **Indian Navy SQL Database (Phase 2)** — is a continuation and enhancement of the Phase 1 Indian Navy Database.  
It simulates the real-life management system of the **Indian Navy**, implementing advanced SQL concepts for handling personnel, ships, aircraft, bases, training, logistics, and operations.

The database integrates multiple relational entities using SQL commands and constraints to reflect authentic defense operations, data dependencies, and workflows.

---

## 🎯 Objectives
- Apply **advanced SQL operations**: `ALTER`, `UPDATE`, `DELETE`, `RENAME`, and `SELECT`.  
- Enhance **data relationships** between multiple entities using foreign keys.  
- Simulate **real-life defense scenarios** and naval data analytics.  
- Demonstrate **data integrity, normalization, and referential constraints**.  
- Execute **DDL, DML, and DQL** operations for complex naval systems.

---

## 🏗️ Database Details
### 📘 Database Name
`indian_navy_phase2`

### 📊 Major Tables
| No. | Table Name | Description |
|-----|-------------|-------------|
| 1 | `Personnel` | Stores personal, service, and posting details of naval officers and sailors. |
| 2 | `Ships` | Information about naval ships, commanding officers, and base assignments. |
| 3 | `Bases` | Details of naval bases, locations, commands, and capacities. |
| 4 | `Aircraft` | Data about aircraft types, squadrons, service status, and maintenance. |
| 5 | `Squadrons` | Manages squadron assignments, aircraft roles, and commanding officers. |
| 6 | `Weapons` | Inventory of naval weapons, their specifications, and stock. |
| 7 | `Operations` | Information about missions, operation types, dates, and success metrics. |
| 8 | `Maintenance_Schedule` | Logs all planned and completed maintenance activities. |
| 9 | `Training_Courses` | Tracks naval training programs, durations, and certifications. |
| 10 | `Personnel_Enlistment` | Maps personnel training participation and performance data. |
| 11 | `Medical_Records` | Stores health, fitness, and medical examination details. |
| 12 | `Logistics_Supply` | Tracks supply chain, inventory, and naval logistics. |
| 13 | `Communication_Logs` | Stores secure communication data between naval units. |

---

## 🧱 Key Features
✅ 13 Relational Tables with logical foreign key connections  
✅ 200+ Advanced SQL Commands (SELECT, UPDATE, DELETE, ALTER, RENAME)  
✅ 100+ Real-life queries simulating naval management scenarios  
✅ Covers full DBMS command scope:
- **DDL:** `CREATE`, `ALTER`, `DROP`, `RENAME`
- **DML:** `INSERT`, `UPDATE`, `DELETE`
- **DQL:** `SELECT`, `JOIN`, `GROUP BY`, `ORDER BY`  
✅ Supports realistic **data analytics** and **integrity enforcement**

---

## 🧠 SQL Concepts Demonstrated
- Data Definition (DDL) and Data Manipulation (DML)
- Referential Integrity with Foreign Keys  
- Table & Column Renaming Operations  
- Advanced Query Filtering and Joins  
- Aggregate Functions (`COUNT`, `SUM`, `AVG`)  
- Grouping, Ordering, and Subqueries  
- Realistic Update and Delete Constraints  
- Boolean Columns, Default Values, and Cascade Relationships  

---

## 🧩 Example SQL Operations

### 1️⃣ Select Query (Personnel)
```sql
SELECT name, post, base_posting_id
FROM Personnel
WHERE is_active = TRUE AND post LIKE '%Commander%';

2️⃣ Update Query (Ships)
UPDATE Ships
SET refit_due_year = 2026
WHERE status = 'Active' AND class LIKE '%Destroyer%';

3️⃣ Delete Query (Maintenance)
DELETE FROM Maintenance_Schedule
WHERE status = 'Completed' AND actual_end IS NOT NULL;

4️⃣ Alter Table Query (Weapons)
ALTER TABLE Weapons
ADD COLUMN last_maintenance DATE;

5️⃣ Rename Query (Aircraft)
ALTER TABLE Aircraft
RENAME COLUMN tail_number TO tail_no;


