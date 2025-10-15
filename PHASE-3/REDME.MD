# 🇮🇳 Indian Navy Database Management System  
### 📘 Project Phase 3 – Advanced SQL Queries  
**Author:** Sahil Mate  
**Institution:** [Your Institute Name]  
**Department:** Computer Science / Information Technology  
**Subject:** Database Management Systems (DBMS)  
**Instructor:** [Instructor Name]  

---

## 📋 Project Overview  
This project represents **Phase 3** of the *Indian Navy Database Management System*.  
It demonstrates advanced SQL skills by implementing:
- **User-Defined Functions (UDFs)**
- **Subqueries** (Scalar, Correlated, IN, EXISTS, NOT EXISTS)
- **Joins** (INNER, LEFT, RIGHT, FULL)
- **Built-in SQL Functions** (String, Date, Numeric, Aggregate)
- **Case Statements** and **Derived Tables**

The system models various operational, personnel, and logistic components of the Indian Navy.

---

## 🗂️ Database Name  
`indianarmy`

---

## 🧩 Major Tables (Examples)
The database includes over **15 interrelated tables** such as:
| Table Name | Description |
|-------------|--------------|
| `Personnel` | Records of naval officers and crew members |
| `Ships` | Details of ships, classes, and commanding officers |
| `Bases` | Information on naval bases, locations, and capacities |
| `Aircraft` | Aircraft inventory and operational status |
| `Squadrons` | Naval air squadrons and their officers |
| `Weapons` | Weapon systems and specifications |
| `Operations` | Naval operations and exercises |
| `Deployment_History` | Records of operational deployments |
| `Maintenance_Schedule` | Maintenance activities of assets |
| `Training_Courses` | Training programs and courses |
| `Supplies` | Logistics and inventory supplies |
| `Naval_Vessels` | All naval ships and auxiliary vessels |
| `Weapon_Systems` | Mounted or standalone weapon systems |
| `Naval_Projects` | Projects and R&D initiatives |
| `Missions` | Tactical missions under operations |

---

## ⚙️ SQL Concepts Used  

### 🔹 **Joins**
- INNER, LEFT, RIGHT, FULL (via UNION)
- Cross Joins and Self Joins

### 🔹 **Subqueries**
- Scalar Subqueries  
- Correlated Subqueries  
- `IN`, `EXISTS`, `NOT EXISTS` subqueries

### 🔹 **Functions**
- Built-in (e.g., `LOWER()`, `DATEDIFF()`, `AVG()`, `COUNT()`)
- User Defined Functions (UDFs) such as:
  - `CalculateServiceDuration()`
  - `GetAssetAge()`
  - `GetOperationDuration()`
  - `fn_WeaponAge()`
  - `fn_MissionAge()`

### 🔹 **Aggregate Functions**
- `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`
- `GROUP BY` and `HAVING` clauses

### 🔹 **Conditional & Formatting**
- `CASE` statements for categorization
- `CONCAT`, `UPPER`, `LOWER` for string formatting
- Date formatting using `DATE_FORMAT()`, `YEAR()`, `CURDATE()`

---

## 🧮 Sample Query Categories  

| Query Type | Example Description |
|-------------|--------------------|
| **UDF Usage** | Calculate years of service for all personnel |
| **Subquery (IN)** | Find ships stationed at Mumbai base |
| **Join** | Link squadrons with their commanding officers |
| **Aggregate** | Count ships per ship type |
| **String Function** | Display ship names in uppercase |
| **Date Function** | List aircraft commissioned before 2000 |
| **Correlated Subquery** | Find oldest personnel in each rank |
| **CASE Function** | Categorize supplies by stock quantity |

---

## 💡 Learning Outcomes
1. Ability to **design and query relational databases** for complex systems.  
2. Implementation of **advanced SQL techniques** for analytics and reporting.  
3. Understanding **database normalization, joins, and subqueries**.  
4. Practical knowledge of **UDFs and business logic encapsulation** in SQL.  
5. Experience in **real-world naval/defense data modeling**.

---

## 🧰 Tools & Technologies
| Tool | Description |
|------|--------------|
| **MySQL / MariaDB** | Database platform used |
| **MySQL Workbench / phpMyAdmin** | Query editor and schema visualizer |
| **VS Code / Notepad++** | Script writing and documentation |
| **ERD Tool (Optional)** | For database relationship visualization |

---

## 🚀 How to Run
1. Open **MySQL Workbench** or your preferred SQL IDE.  
2. Run:
   ```sql
   USE indianarmy;
SOURCE PROJECT PHASE -3 SAHIL MATE INDIAN NAVY.sql;

