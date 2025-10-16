🇮🇳 Indian Navy Database Management System
Project Phase 1 – SQL Implementation
📘 Overview

This project represents the Phase 1 of the Indian Navy Database Management System, designed to manage and organize comprehensive data related to naval personnel, ships, aircraft, bases, training, logistics, and operations.
It serves as a foundational database model for efficient data storage, retrieval, and analysis using MySQL.

🧩 Key Objectives

Design a relational database for the Indian Navy.

Include minimum 10+ tables with relevant attributes.

Demonstrate SQL operations:

CREATE, INSERT, SELECT, TRUNCATE, and DROP.

Maintain data consistency, integrity, and referential relationships through primary and foreign keys.

🗃️ Database Details

Database Name: indian_navy

Major Tables:
Table No.	Table Name	Description
1	Personnel	Stores details of all naval personnel including rank, service number, and contact info.
2	Ships	Contains data of naval ships (class, type, commission date, status).
3	Bases	Information on naval bases, air stations, and dockyards.
4	Aircraft	Details of naval aircraft, including type, base, and maintenance status.
5	Squadrons	Information about various naval air squadrons and their commanding officers.
6	Weapons	Inventory and specifications of weapon systems.
7	Operations	Logs of naval operations, exercises, and humanitarian missions.
8	Maintenance_Schedule	Tracks maintenance and refit activities for ships and aircraft.
9	Training_Courses	Stores information about training programs for officers and sailors.
10	Personnel_Enlistment	Maps personnel to training courses and their performance outcomes.
11	Medical_Records	Health checkup details of personnel.
12	Logistics_Supply	Manages logistics, inventory, and supply chain details.
13	Communication_Logs	Tracks inter-unit communications and secure message transmissions.
⚙️ SQL Functionalities Used
1️⃣ CREATE TABLE

Used to define schema for all 13 tables with data types, constraints, and primary/foreign keys.

2️⃣ INSERT INTO

Populates each table with realistic and representative sample data for demonstration.

3️⃣ SELECT

Retrieves and displays data from tables using queries like:

SELECT * FROM Personnel;

4️⃣ TRUNCATE

Removes all rows while retaining the table structure:

TRUNCATE TABLE Ships;

5️⃣ DROP

Deletes entire tables after testing:

DROP TABLE Bases;

🧠 Concept Highlights

Normalization: Ensures minimal redundancy and better efficiency.

Primary & Foreign Keys: Maintain relational integrity across interconnected tables.

Domain Coverage: Includes personnel, operations, logistics, and training—reflecting real naval functions.

Scalability: The schema can be extended for analytics, dashboards, or operational monitoring.

🧪 Tools & Technologies

Database: MySQL / MariaDB

Query Language: SQL

Editor: MySQL Workbench / phpMyAdmin / VS Code (with SQL extension)

📂 File Included

PROJECT PHASE -1 SAHIL MATE INDIAN NAVY.sql

Contains all SQL scripts for creating, inserting, selecting, truncating, and dropping tables.

📈 Future Scope (For Phase 2 & Beyond)

Implement foreign key relationships more deeply.

Develop views, joins, and stored procedures for analysis.

Integrate with a frontend interface for data visualization.

Add user authentication and security roles.

👨‍💻 Author

Name: Sahil Mate
Project: Database – Indian Navy
Phase: 1
Institution: (Add your college/university name here)
Mentor/Instructor: (Add instructor name if applicable)
