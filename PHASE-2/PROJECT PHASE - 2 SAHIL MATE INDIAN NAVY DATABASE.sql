USE indian_navy;
-- =================================================================
-- Table 1: Personnel
-- Description: Stores information about all naval personnel.
-- =================================================================
CREATE TABLE Personnel (
    personnel_id INT PRIMARY KEY AUTO_INCREMENT,
    service_number VARCHAR(20) UNIQUE NOT NULL,
    post VARCHAR(50),
    full_name VARCHAR(100),
    date_of_birth DATE,
    date_of_commission DATE,
    blood_group VARCHAR(5),
    contact_number VARCHAR(15),
    email_address VARCHAR(100),
    current_posting_id INT
);

-- Insert records for Personnel
INSERT INTO Personnel (service_number, post, full_name, date_of_birth, date_of_commission, blood_group, contact_number, email_address, current_posting_id) VALUES
('IN001', 'Admiral', 'R. Hari Kumar', '1962-04-12', '1983-01-01', 'O+', '9876543210', 'rhk.chief@navy.mil', 1),
('IN002', 'Vice Admiral', 'S.N. Ghormade', '1964-06-20', '1985-07-01', 'A+', '9876543211', 'sng.vcns@navy.mil', 2),
('IN003', 'Captain', 'Vikram Singh', '1975-08-15', '1998-06-12', 'B+', '9123456780', 'vikram.s@navy.mil', 5),
('IN004', 'Commander', 'Priya Sharma', '1980-11-25', '2002-01-20', 'AB+', '9123456781', 'priya.s@navy.mil', 6),
('IN005', 'Lieutenant Commander', 'Arjun Mehta', '1985-03-10', '2007-07-15', 'O-', '9123456782', 'arjun.m@navy.mil', 7),
('IN006', 'Lieutenant', 'Anjali Rao', '1990-09-05', '2012-06-22', 'A-', '9123456783', 'anjali.r@navy.mil', 8),
('IN007', 'Sub-Lieutenant', 'Rohan Gupta', '1993-02-18', '2015-01-10', 'B-', '9123456784', 'rohan.g@navy.mil', 9),
('IN008', 'Master Chief Petty Officer I', 'Suresh Kumar', '1970-05-30', '1990-03-15', 'O+', '9123456785', 'suresh.k@navy.mil', 10),
('IN009', 'Master Chief Petty Officer II', 'Manoj Patel', '1972-07-22', '1992-09-18', 'A+', '9123456786', 'manoj.p@navy.mil', 11),
('IN010', 'Chief Petty Officer', 'Deepak Verma', '1978-12-01', '1999-06-05', 'B+', '9123456787', 'deepak.v@navy.mil', 12),
('IN011', 'Petty Officer', 'Sunita Devi', '1982-04-14', '2003-02-28', 'AB-', '9123456788', 'sunita.d@navy.mil', 13),
('IN012', 'Leading Seaman', 'Amit Kumar', '1995-01-20', '2016-07-30', 'O+', '9123456789', 'amit.k@navy.mil', 14),
('IN013', 'Seaman I', 'Rajesh Singh', '1998-06-11', '2018-12-15', 'A+', '9123456790', 'rajesh.s@navy.mil', 15),
('IN014', 'Seaman II', 'Pooja Yadav', '1999-08-23', '2020-06-10', 'B+', '9123456791', 'pooja.y@navy.mil', 16),
('IN015', 'Captain', 'Alok Jain', '1976-04-19', '1999-06-12', 'O-', '9123456792', 'alok.j@navy.mil', 3),
('IN016', 'Commander', 'Neha Desai', '1981-01-15', '2003-01-20', 'A-', '9123456793', 'neha.d@navy.mil', 4),
('IN017', 'Lieutenant', 'Karan Malhotra', '1991-05-12', '2013-06-22', 'B-', '9123456794', 'karan.m@navy.mil', 17),
('IN018', 'Sub-Lieutenant', 'Sanya Agarwal', '1994-10-02', '2016-01-10', 'AB+', '9123456795', 'sanya.a@navy.mil', 18),
('IN019', 'Chief Petty Officer', 'Ravi Shankar', '1979-03-17', '2000-06-05', 'O+', '9123456796', 'ravi.s@navy.mil', 19),
('IN020', 'Petty Officer', 'Geeta Kumari', '1983-11-09', '2004-02-28', 'A+', '9123456797', 'geeta.k@navy.mil', 20);

USE indian_navy;

-- =============================================
-- 1. SELECT all records from Personnel table
-- =============================================
SELECT * FROM Personnel;

-- =============================================
-- 2. SELECT specific columns: full_name, post, contact_number
-- =============================================
SELECT full_name, post, contact_number FROM Personnel;

-- =============================================
-- 3. SELECT with WHERE clause (all Captains)
-- =============================================
SELECT * FROM Personnel WHERE post = 'Captain';

-- =============================================
-- 4. SELECT using AND/OR operators (Captains with O- blood group)
-- =============================================
SELECT * FROM Personnel
WHERE post = 'Captain' AND blood_group = 'O-';

-- =============================================
-- 5. SELECT using LIKE operator (names starting with 'S')
-- =============================================
SELECT * FROM Personnel
WHERE full_name LIKE 'S%';

-- =============================================
-- 6. SELECT using ORDER BY (sorted by date_of_commission descending)
-- =============================================
SELECT * FROM Personnel
ORDER BY date_of_commission DESC;

-- =============================================
-- 7. SELECT using GROUP BY (count personnel by blood group)
-- =============================================
SELECT blood_group, COUNT(*) AS total_personnel
FROM Personnel
GROUP BY blood_group;

-- =============================================
-- 8. SELECT using aggregate function (oldest personnel)
-- =============================================
SELECT full_name, date_of_birth
FROM Personnel
ORDER BY date_of_birth ASC
LIMIT 1;

-- =============================================
-- 9. SELECT with aliasing columns
-- =============================================
SELECT full_name AS Name, post AS post, contact_number AS Phone
FROM Personnel;

-- =============================================
-- 10. UPDATE a record (change contact number for IN001)
-- =============================================
UPDATE Personnel
SET contact_number = '9999999999'
WHERE service_number = 'IN001';

-- =============================================
-- 11. DELETE a record (remove Seaman II)
-- =============================================
DELETE FROM Personnel
WHERE post = 'Seaman II' AND full_name = 'Pooja Yadav';

-- =============================================
-- 12. ALTER table to add a new column: rank_level
-- =============================================
ALTER TABLE Personnel
ADD COLUMN rank_level VARCHAR(20);

-- =============================================
-- 13. ALTER table to modify column: contact_number to 20 chars
-- =============================================
ALTER TABLE Personnel
MODIFY contact_number VARCHAR(20);

-- =============================================
-- 14. ALTER table to drop a column: email_address
-- =============================================
ALTER TABLE Personnel
DROP COLUMN email_address;

-- =============================================
-- 15. INSERT a new record
-- =============================================
INSERT INTO Personnel (service_number, post, full_name, date_of_birth, date_of_commission, blood_group, contact_number, current_posting_id)
VALUES ('IN021', 'Lieutenant', 'Aakash Verma', '1992-07-21', '2014-06-22', 'B+', '9123456800', 21);

-- =============================================
-- 16. SELECT using BETWEEN operator (personnel born between 1980 and 1990)
-- =============================================
SELECT * FROM Personnel
WHERE date_of_birth BETWEEN '1980-01-01' AND '1990-12-31';

-- =============================================
-- 17. SELECT using IN operator (list specific service_numbers)
-- =============================================
SELECT * FROM Personnel
WHERE service_number IN ('IN003', 'IN007', 'IN015');

-- =============================================
-- 18. UPDATE with CASE statement (set rank_level based on post)
-- =============================================
UPDATE Personnel
SET rank_level = CASE
    WHEN post IN ('Admiral', 'Vice Admiral') THEN 'High'
    WHEN post IN ('Captain', 'Commander') THEN 'Medium'
    ELSE 'Low'
END;

-- =============================================
-- 19. SELECT with IS NULL / IS NOT NULL (find personnel without rank_level)
-- =============================================
SELECT * FROM Personnel
WHERE rank_level IS NULL;

-- =============================================
-- 20. ADD foreign key with ON DELETE CASCADE (example for current_posting_id)
-- =============================================
ALTER TABLE Personnel
ADD CONSTRAINT fk_posting
FOREIGN KEY (current_posting_id)
REFERENCES Posting(posting_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- =================================================================
-- Table 2: Ships
-- Description: Stores details of all naval ships.
-- =================================================================
CREATE TABLE Ships (
    ship_id INT PRIMARY KEY AUTO_INCREMENT,
    pennant_number VARCHAR(10) UNIQUE NOT NULL,
    ship_name VARCHAR(100),
    ship_class VARCHAR(100),
    ship_type VARCHAR(50),
    commission_date DATE,
    decommission_date DATE,
    home_port_id INT,
    current_status VARCHAR(50), -- e.g., Active, In-Refit, Decommissioned
    commanding_officer_id INT
);

-- Insert records for Ships
INSERT INTO Ships (pennant_number, ship_name, ship_class, ship_type, commission_date, home_port_id, current_status, commanding_officer_id) VALUES
('D66', 'INS Vikramaditya', 'Kiev-class', 'Aircraft Carrier', '2013-11-16', 1, 'Active', 3),
('D63', 'INS Kolkata', 'Kolkata-class', 'Destroyer', '2014-08-16', 2, 'Active', 4),
('D64', 'INS Kochi', 'Kolkata-class', 'Destroyer', '2015-09-30', 2, 'Active', 15),
('D65', 'INS Chennai', 'Kolkata-class', 'Destroyer', '2016-11-21', 2, 'Active', 16),
('F47', 'INS Shivalik', 'Shivalik-class', 'Frigate', '2010-04-29', 3, 'Active', 5),
('F48', 'INS Satpura', 'Shivalik-class', 'Frigate', '2011-08-20', 3, 'Active', 6),
('F49', 'INS Sahyadri', 'Shivalik-class', 'Frigate', '2012-07-21', 3, 'Active', 7),
('P62', 'INS Saryu', 'Saryu-class', 'Patrol Vessel', '2013-01-21', 4, 'Active', 8),
('P57', 'INS Sunayna', 'Saryu-class', 'Patrol Vessel', '2013-10-15', 4, 'Active', 9),
('K43', 'INS Kavaratti', 'Kamorta-class', 'Corvette', '2020-10-22', 3, 'Active', 10),
('L41', 'INS Jalashwa', 'Austin-class', 'Amphibious Transport Dock', '2007-06-22', 3, 'Active', 11),
('S21', 'INS Kalvari', 'Kalvari-class', 'Submarine', '2017-12-14', 2, 'Active', 12),
('S22', 'INS Khanderi', 'Kalvari-class', 'Submarine', '2019-09-28', 2, 'Active', 13),
('S23', 'INS Karanj', 'Kalvari-class', 'Submarine', '2021-03-10', 2, 'Active', 14),
('A57', 'INS Deepak', 'Deepak-class', 'Fleet Tanker', '2011-01-21', 2, 'Active', 17),
('R33', 'INS Vikrant', 'Vikrant-class', 'Aircraft Carrier', '2022-09-02', 1, 'Active', 18),
('D55', 'INS Ranvijay', 'Rajput-class', 'Destroyer', '1988-01-15', 3, 'Active', 19),
('F40', 'INS Talwar', 'Talwar-class', 'Frigate', '2003-06-18', 2, 'Active', 20),
('P45', 'INS Kirpan', 'Khukri-class', 'Corvette', '1991-01-12', 3, 'Decommissioned', NULL),
('S55', 'INS Sindhughosh', 'Sindhughosh-class', 'Submarine', '1986-04-30', 2, 'Active', 21);

-- ==============================
-- 1. SELECT all ships
-- ==============================
SELECT * FROM Ships;

-- ==============================
-- 2. SELECT ship_name and ship_type with alias
-- ==============================
SELECT ship_name AS 'Name', ship_type AS 'Type' FROM Ships;

-- ==============================
-- 3. SELECT active ships only
-- ==============================
SELECT * FROM Ships
WHERE current_status = 'Active';

-- ==============================
-- 4. SELECT ships commissioned after 2015
-- ==============================
SELECT * FROM Ships
WHERE commission_date > '2015-01-01';

-- ==============================
-- 5. SELECT ships with type Destroyer or Frigate
-- ==============================
SELECT * FROM Ships
WHERE ship_type IN ('Destroyer','Frigate');

-- ==============================
-- 6. SELECT ships ordered by commission_date descending
-- ==============================
SELECT * FROM Ships
ORDER BY commission_date DESC;

-- ==============================
-- 7. SELECT count of ships per type
-- ==============================
SELECT ship_type, COUNT(*) AS total_ships
FROM Ships
GROUP BY ship_type;

-- ==============================
-- 8. SELECT ships with commanding officer assigned
-- ==============================
SELECT * FROM Ships
WHERE commanding_officer_id IS NOT NULL;

-- ==============================
-- 9. SELECT ships whose name starts with 'INS K'
-- ==============================
SELECT * FROM Ships
WHERE ship_name LIKE 'INS K%';

-- ==============================
-- 10. JOIN Ships with Bases to get home port name
-- ==============================
SELECT s.ship_name, b.base_name AS home_port
FROM Ships s
LEFT JOIN Bases b ON s.home_port_id = b.base_id;

-- ==============================
-- 11. JOIN Ships with Personnel for commanding officer
-- ==============================
SELECT s.ship_name, p.full_name AS commanding_officer
FROM Ships s
LEFT JOIN Personnel p ON s.commanding_officer_id = p.personnel_id;

-- ==============================
-- 12. INSERT a new Ship
-- ==============================
INSERT INTO Ships (pennant_number, ship_name, ship_class, ship_type, commission_date, home_port_id, current_status, commanding_officer_id)
VALUES ('F50', 'INS Tarangini', 'Sailing Vessel', 'Training', '1997-11-01', 3, 'Active', 22);

-- ==============================
-- 13. UPDATE status of a ship
-- ==============================
UPDATE Ships
SET current_status = 'Decommissioned'
WHERE ship_name = 'INS Kirpan';

-- ==============================
-- 14. DELETE a ship record
-- ==============================
DELETE FROM Ships
WHERE ship_name = 'INS Tarangini';

-- ==============================
-- 15. ALTER table to add displacement column
-- ==============================
ALTER TABLE Ships
ADD displacement_tons INT;

-- ==============================
-- 16. ALTER table to modify ship_type length
-- ==============================
ALTER TABLE Ships
MODIFY ship_type VARCHAR(100);

-- ==============================
-- 17. UPDATE ship commanding officer using subquery
-- ==============================
UPDATE Ships
SET commanding_officer_id = (SELECT personnel_id FROM Personnel WHERE full_name='Cmdr. John Doe')
WHERE ship_name='INS Shivalik';

-- ==============================
-- 18. SELECT ships with home port in Mumbai
-- ==============================
SELECT s.ship_name, b.base_name
FROM Ships s
JOIN Bases b ON s.home_port_id = b.base_id
WHERE b.location_city='Mumbai';

-- ==============================
-- 19. SELECT number of ships per base using GROUP BY
-- ==============================
SELECT b.base_name, COUNT(s.ship_id) AS ship_count
FROM Ships s
JOIN Bases b ON s.home_port_id = b.base_id
GROUP BY b.base_name;

-- ==============================
-- 20. CASCADE DELETE: if base removed, ships home_port set NULL
-- ==============================
ALTER TABLE Ships
ADD CONSTRAINT fk_home_port
FOREIGN KEY (home_port_id) REFERENCES Bases(base_id)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- =================================================================
-- Table 3: Bases
-- Description: Stores information about naval bases.
-- =================================================================
CREATE TABLE Bases (
    base_id INT PRIMARY KEY AUTO_INCREMENT,
    base_name VARCHAR(100),
    location_city VARCHAR(50),
    location_state VARCHAR(50),
    command VARCHAR(50), -- e.g., Western, Eastern, Southern
    base_type VARCHAR(50), -- e.g., Naval Base, Air Station, Dockyard
    establishment_date DATE,
    capacity INT,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

-- Insert records for Bases
INSERT INTO Bases (base_name, location_city, location_state, command, base_type, establishment_date, capacity, latitude, longitude) VALUES
('Naval Dockyard Mumbai', 'Mumbai', 'Maharashtra', 'Western', 'Dockyard', '1735-01-01', 50000, 18.9220, 72.8335),
('Naval Base Karwar (INS Kadamba)', 'Karwar', 'Karnataka', 'Western', 'Naval Base', '2005-05-31', 30000, 14.8093, 74.1241),
('Naval Dockyard Visakhapatnam', 'Visakhapatnam', 'Andhra Pradesh', 'Eastern', 'Dockyard', '1949-01-01', 45000, 17.6983, 83.2185),
('Southern Naval Command Headquarters', 'Kochi', 'Kerala', 'Southern', 'Headquarters', '1971-01-01', 25000, 9.9676, 76.2584),
('INS Dega', 'Visakhapatnam', 'Andhra Pradesh', 'Eastern', 'Air Station', '1991-10-21', 5000, 17.7214, 83.2245),
('INS Rajali', 'Arakkonam', 'Tamil Nadu', 'Eastern', 'Air Station', '1992-03-11', 4000, 13.0700, 79.6800),
('INS Hansa', 'Dabolim', 'Goa', 'Western', 'Air Station', '1961-09-05', 6000, 15.3802, 73.8311),
('Naval Ship Repair Yard, Kochi', 'Kochi', 'Kerala', 'Southern', 'Ship Repair Yard', '1988-05-28', 10000, 9.9650, 76.2500),
('INS Chilka', 'Chilika', 'Odisha', 'Southern', 'Training Establishment', '1980-10-21', 15000, 19.7000, 85.3000),
('Indian Naval Academy', 'Ezhimala', 'Kerala', 'Southern', 'Training Academy', '2009-01-08', 4000, 12.0167, 75.2167),
('INS Dwarka', 'Okha', 'Gujarat', 'Western', 'Forward Operating Base', '1963-01-01', 3000, 22.4719, 69.0771),
('INS Netaji Subhas', 'Kolkata', 'West Bengal', 'Eastern', 'Forward Operating Base', '1974-07-05', 2500, 22.5394, 88.3347),
('INS Sardar Patel', 'Porbandar', 'Gujarat', 'Western', 'Naval Base', '2015-05-09', 5000, 21.6413, 69.6083),
('Naval Air Enclave, Port Blair', 'Port Blair', 'Andaman & Nicobar', 'Andaman & Nicobar', 'Air Enclave', '1984-01-01', 2000, 11.6411, 92.7156),
('INS Baaz', 'Campbell Bay', 'Andaman & Nicobar', 'Andaman & Nicobar', 'Air Station', '2012-07-31', 1000, 6.9833, 93.9167),
('INS Vajrakosh', 'Karwar', 'Karnataka', 'Western', 'Missile Base', '2015-09-09', 2000, 14.8100, 74.1250),
('Naval Armament Depot, Aluva', 'Aluva', 'Kerala', 'Southern', 'Armament Depot', '1940-01-01', 3000, 10.1086, 76.3518),
('Material Organisation, Mumbai', 'Mumbai', 'Maharashtra', 'Western', 'Logistics Base', '1954-01-01', 8000, 18.9500, 72.8300),
('INS Adyar', 'Chennai', 'Tamil Nadu', 'Eastern', 'Logistics & Support Base', '1945-01-01', 2000, 13.0471, 80.2588),
('INS Gomantak', 'Vasco da Gama', 'Goa', 'Western', 'Naval Base', '1964-03-07', 4000, 15.3900, 73.8100);


-- =================================================================
-- Table 4: Aircraft
-- Description: Stores details of all naval aircraft.
-- =================================================================
CREATE TABLE Aircraft (
    aircraft_id INT PRIMARY KEY AUTO_INCREMENT,
    tail_number VARCHAR(20) UNIQUE NOT NULL,
    aircraft_type VARCHAR(50), -- e.g., Fighter, ASW, Transport
    model_name VARCHAR(100), -- e.g., MiG-29K, P-8I Neptune
    squadron_id INT,
    commission_date DATE,
    airframe_hours INT,
    current_status VARCHAR(50), -- e.g., Operational, Maintenance, Stored
    base_id INT,
    last_serviced_date DATE
);

-- Insert records for Aircraft
INSERT INTO Aircraft (tail_number, aircraft_type, model_name, squadron_id, commission_date, airframe_hours, current_status, base_id, last_serviced_date) VALUES
('INAS303-01', 'Fighter', 'MiG-29K', 1, '2013-05-11', 1500, 'Operational', 7, '2025-06-15'),
('INAS303-02', 'Fighter', 'MiG-29K', 1, '2013-05-11', 1450, 'Operational', 7, '2025-07-01'),
('INAS312-01', 'ASW/MR', 'P-8I Neptune', 2, '2013-05-15', 5000, 'Operational', 6, '2025-05-20'),
('INAS312-02', 'ASW/MR', 'P-8I Neptune', 2, '2013-05-15', 4800, 'Maintenance', 6, '2025-04-30'),
('INAS322-01', 'Helicopter', 'ALH Dhruv', 3, '2013-11-12', 2200, 'Operational', 4, '2025-07-10'),
('INAS322-02', 'Helicopter', 'ALH Dhruv', 3, '2013-11-12', 2150, 'Operational', 4, '2025-07-12'),
('INAS330-01', 'ASW Helicopter', 'Westland Sea King', 4, '1988-01-01', 8500, 'Operational', 1, '2025-06-05'),
('INAS330-02', 'ASW Helicopter', 'Westland Sea King', 4, '1988-01-01', 8600, 'Stored', 1, '2024-11-20'),
('INAS552-01', 'Trainer', 'HAL Kiran', 5, '1990-01-01', 12000, 'Operational', 4, '2025-05-01'),
('INAS552-02', 'Trainer', 'HAL Kiran', 5, '1990-01-01', 12500, 'Operational', 4, '2025-05-15'),
('INAS316-01', 'ASW/MR', 'P-8I Neptune', 6, '2022-03-29', 800, 'Operational', 7, '2025-06-25'),
('INAS316-02', 'ASW/MR', 'P-8I Neptune', 6, '2022-03-29', 750, 'Operational', 7, '2025-06-28'),
('INAS300-01', 'Fighter', 'Sea Harrier', 7, '1983-12-16', 15000, 'Decommissioned', 7, '2016-05-11'),
('INAS336-01', 'Helicopter', 'Kamov Ka-31', 8, '2003-01-01', 4000, 'Operational', 1, '2025-07-01'),
('INAS336-02', 'Helicopter', 'Kamov Ka-31', 8, '2003-01-01', 3900, 'Operational', 1, '2025-07-05'),
('INAS342-01', 'UAV', 'IAI Heron', 9, '2006-01-01', 6000, 'Operational', 4, '2025-06-18'),
('INAS342-02', 'UAV', 'IAI Heron', 9, '2006-01-01', 5800, 'Operational', 4, '2025-06-20'),
('INAS318-01', 'MR', 'Dornier 228', 10, '1999-01-01', 9000, 'Operational', 14, '2025-05-22'),
('INAS318-02', 'MR', 'Dornier 228', 10, '1999-01-01', 9100, 'Maintenance', 14, '2025-04-10'),
('INAS323-01', 'Helicopter', 'ALH Mk-III', 11, '2021-04-19', 500, 'Operational', 7, '2025-07-20');

-- =================================================================
-- Table 5: Squadrons
-- Description: Stores information about naval air squadrons.
-- =================================================================
CREATE TABLE Squadrons (
    squadron_id INT PRIMARY KEY AUTO_INCREMENT,
    squadron_name VARCHAR(100), -- e.g., The Black Panthers
    squadron_number VARCHAR(10), -- e.g., INAS 303
    aircraft_type_specialization VARCHAR(50),
    base_id INT,
    establishment_date DATE,
    commanding_officer_id INT,
    motto VARCHAR(255),
    role VARCHAR(100), -- e.g., Air Superiority, Anti-Submarine Warfare
    total_aircraft INT
);

-- Insert records for Squadrons
INSERT INTO Squadrons (squadron_name, squadron_number, aircraft_type_specialization, base_id, establishment_date, commanding_officer_id, motto, role, total_aircraft) VALUES
('The Black Panthers', 'INAS 303', 'MiG-29K', 7, '2013-05-11', 22, 'Victory by Pounce', 'Air Superiority', 16),
('The Albatross', 'INAS 312', 'P-8I Neptune', 6, '1976-11-15', 23, 'The Ocean Watchers', 'Anti-Submarine Warfare', 12),
('The Rotors', 'INAS 322', 'ALH Dhruv', 4, '2013-11-12', 24, 'Search and Save', 'Utility & SAR', 10),
('The Harpoons', 'INAS 330', 'Westland Sea King', 1, '1971-04-17', 25, 'Any Sea, Any Time', 'Anti-Submarine Warfare', 8),
('The Hawks', 'INAS 552', 'HAL Kiran', 4, '1989-09-07', 26, 'Skill with Precision', 'Jet Training', 12),
('The Condors', 'INAS 316', 'P-8I Neptune', 7, '2022-03-29', 27, 'Guardians of the Deep', 'Anti-Submarine Warfare', 4),
('The White Tigers', 'INAS 300', 'Sea Harrier', 7, '1960-07-07', 28, 'Strike from the Sea', 'Fighter/Reconnaissance', 0),
('The Flying Camels', 'INAS 336', 'Kamov Ka-31', 1, '2003-01-01', 29, 'Eyes in the Sky', 'Airborne Early Warning', 6),
('The Prying Eyes', 'INAS 342', 'IAI Heron', 4, '2006-01-06', 30, 'Vigilance Unlimited', 'Maritime Surveillance', 8),
('The Stallions', 'INAS 318', 'Dornier 228', 14, '1984-03-09', 31, 'Swift, Silent, Sure', 'Maritime Reconnaissance', 10),
('The Fledglings', 'INAS 551', 'Hawk 132', 5, '2014-01-01', 32, 'Train to Win', 'Advanced Jet Training', 14),
('The Cobras', 'INAS 321', 'HAL Chetak', 4, '1969-03-15', 33, 'Strike and Support', 'Utility & SAR', 10),
('The Angels', 'INAS 321F', 'HAL Chetak', 4, '1992-01-01', 34, 'Flight for Life', 'SAR Flight', 6),
('The Dragons', 'INAS 315', 'Il-38 SD', 7, '1977-10-01', 35, 'Hunters of the Sea', 'ASW/MR', 5),
('The Seaeagles', 'INAS 310', 'Dornier 228', 5, '1961-03-21', 36, 'Eternal Vigil', 'Maritime Reconnaissance', 8),
('The Falcons', 'INAS 311', 'HAL Chetak', 5, '1976-01-01', 37, 'Ready to Respond', 'Utility & Liaison', 6),
('The Griffins', 'INAS 343', 'IAI Searcher Mk II', 4, '2006-01-01', 38, 'Unseen, Unheard, Unmatched', 'UAV Reconnaissance', 8),
('The Rhinos', 'INAS 333', 'Kamov Ka-28', 7, '1983-01-01', 39, 'Submarine Hunters', 'Anti-Submarine Warfare', 10),
('The Shield', 'INAS 313', 'Dornier 228', 12, '2019-01-01', 40, 'Defenders of the Coast', 'Coastal Surveillance', 6),
('The Guardians', 'INAS 323', 'ALH Mk-III', 5, '2021-04-19', 41, 'First to Respond', 'Coastal Security', 4);

-- =================================================================
-- Table 6: Weapons
-- Description: Stores information about weapon systems.
-- =================================================================
CREATE TABLE Weapons (
    weapon_id INT PRIMARY KEY AUTO_INCREMENT,
    weapon_name VARCHAR(100),
    weapon_type VARCHAR(50), -- e.g., Missile, Torpedo, Gun
    manufacturer VARCHAR(100),
    country_of_origin VARCHAR(50),
    range_km INT,
    guidance_system VARCHAR(100),
    warhead_type VARCHAR(50),
    inventory_count INT,
    entry_into_service_year INT
);

-- Insert records for Weapons
INSERT INTO Weapons (weapon_name, weapon_type, manufacturer, country_of_origin, range_km, guidance_system, warhead_type, inventory_count, entry_into_service_year) VALUES
('BrahMos', 'Supersonic Cruise Missile', 'BrahMos Aerospace', 'India/Russia', 400, 'INS/GPS/Active Radar', 'Conventional', 200, 2007),
('Barak 8', 'Long-range SAM', 'IAI/DRDO', 'Israel/India', 100, 'Active Radar Seeker', 'HE Fragmentation', 500, 2016),
('Varunastra', 'Heavyweight Torpedo', 'DRDO', 'India', 40, 'Active/Passive Acoustic Homing', 'HE', 150, 2016),
('AK-630', 'CIWS Gun', 'Tulamashzavod', 'Russia', 4, 'Radar/Optical', 'HE-FRAG', 300, 1976),
('Otobreda 76 mm', 'Naval Gun', 'Oto Melara', 'Italy', 16, 'Radar/Optical', 'HE', 250, 1962),
('RBU-6000', 'Anti-Submarine Rocket Launcher', 'Degtyarev plant', 'Russia', 6, 'Unguided', 'Depth Charge', 400, 1961),
('Klub-N', 'Anti-Ship Cruise Missile', 'Novator Design Bureau', 'Russia', 220, 'INS/ARH', 'Conventional', 100, 2001),
('TAL Shyena', 'Lightweight Torpedo', 'DRDO', 'India', 7, 'Active/Passive Acoustic', 'HE', 200, 2012),
('Dhanush', 'Ballistic Missile', 'DRDO', 'India', 350, 'INS/GPS', 'Nuclear/Conventional', 20, 2012),
('Nirbhay', 'Subsonic Cruise Missile', 'DRDO', 'India', 1000, 'INS/GPS/Terminal Seeker', 'Conventional/Nuclear', 30, 2020),
('SMART', 'Supersonic Missile Assisted Release of Torpedo', 'DRDO', 'India', 643, 'INS/GPS', 'Lightweight Torpedo', 10, 2021),
('Harpoon Block II', 'Anti-Ship Missile', 'Boeing', 'USA', 240, 'GPS/INS/Radar', 'Conventional', 80, 2012),
('Sea Eagle', 'Anti-Ship Missile', 'MBDA', 'UK', 110, 'Active Radar Homing', 'Conventional', 50, 1985),
('Exocet SM39', 'Anti-Ship Missile', 'MBDA', 'France', 180, 'INS/Active Radar', 'Conventional', 60, 1988),
('C-302', 'Anti-Ship Missile', 'CASIC', 'China', 120, 'Radar/Infrared', 'Conventional', 40, 1999),
('SA-N-7 Gadfly', 'Medium-range SAM', 'Almaz-Antey', 'Russia', 25, 'Semi-Active Radar', 'HE', 150, 1980),
('AK-176', 'Naval Gun', 'Arsenal Design Bureau', 'Russia', 15, 'Radar/Optical', 'HE', 100, 1976),
('Mines', 'Naval Mine', 'Various', 'Various', 0, 'Acoustic/Magnetic/Pressure', 'HE', 1000, 1950),
('Depth Charges', 'Anti-Submarine Weapon', 'Various', 'Various', 1, 'Hydrostatic', 'HE', 2000, 1940),
('K-15 Sagarika', 'SLBM', 'DRDO', 'India', 750, 'INS/GPS', 'Nuclear', 12, 2018);


-- =================================================================
-- Table 7: Operations
-- Description: Records details of naval operations and deployments.
-- =================================================================
CREATE TABLE Operations (
    operation_id INT PRIMARY KEY AUTO_INCREMENT,
    operation_name VARCHAR(100),
    operation_type VARCHAR(50), -- e.g., Anti-Piracy, HADR, Fleet Exercise
    start_date DATE,
    end_date DATE,
    area_of_operation VARCHAR(255),
    lead_command VARCHAR(50),
    status VARCHAR(50), -- e.g., Ongoing, Completed, Planned
    objective TEXT,
    outcome TEXT
);

-- Insert records for Operations
INSERT INTO Operations (operation_name, operation_type, start_date, end_date, area_of_operation, lead_command, status, objective, outcome) VALUES
('Op Sankalp', 'Maritime Security', '2019-06-19', NULL, 'Gulf of Oman, Persian Gulf', 'Western', 'Ongoing', 'To ensure safe passage of Indian-flagged vessels.', 'Continuous presence maintained, several vessels escorted safely.'),
('Op Samudra Setu', 'Non-combatant Evacuation', '2020-05-05', '2020-07-08', 'Indian Ocean Region', 'Southern', 'Completed', 'Repatriation of Indian citizens from foreign countries during COVID-19.', 'Successfully repatriated 3,992 Indian citizens.'),
('Malabar 2023', 'Fleet Exercise', '2023-08-11', '2023-08-21', 'Off the coast of Sydney, Australia', 'Eastern', 'Completed', 'To enhance interoperability with Quad navies (US, Japan, Australia).', 'Improved tactical coordination and procedures.'),
('TROPEX 21', 'Fleet Exercise', '2021-01-01', '2021-02-23', 'Indian Ocean Region', 'All Commands', 'Completed', 'Theatre Level Operational Readiness Exercise to test combat readiness.', 'Validated operational concepts and combat readiness of the fleet.'),
('Op Madad', 'HADR', '2018-08-16', '2018-08-28', 'Kerala', 'Southern', 'Completed', 'Humanitarian Assistance and Disaster Relief during Kerala floods.', 'Rescued thousands of stranded people and distributed relief material.'),
('Op Rahat', 'Non-combatant Evacuation', '2015-04-01', '2015-04-11', 'Yemen', 'Western', 'Completed', 'Evacuation of Indian and foreign nationals from Yemen.', 'Evacuated over 4,640 Indian citizens and 960 foreign nationals.'),
('Anti-Piracy Patrols', 'Anti-Piracy', '2008-10-23', NULL, 'Gulf of Aden', 'Western', 'Ongoing', 'To combat piracy and ensure security of sea lanes of communication.', 'Successfully thwarted numerous piracy attempts and secured shipping routes.'),
('SIMBEX 2023', 'Fleet Exercise', '2023-09-21', '2023-09-28', 'South China Sea', 'Eastern', 'Completed', 'Bilateral exercise with the Republic of Singapore Navy.', 'Enhanced mutual understanding and interoperability.'),
('Op Nistar', 'HADR', '2018-06-12', '2018-06-16', 'Socotra, Yemen', 'Western', 'Completed', 'Evacuation of Indian nationals stranded after Cyclone Mekunu.', 'Successfully evacuated 38 Indian nationals.'),
('Varuna 2023', 'Fleet Exercise', '2023-01-16', '2023-01-20', 'Arabian Sea', 'Western', 'Completed', 'Bilateral exercise with the French Navy.', 'Strengthened maritime cooperation and joint capabilities.'),
('Op Talash', 'Search and Rescue', '2019-06-03', '2019-07-20', 'Arabian Sea', 'Western', 'Completed', 'Search for missing AN-32 aircraft.', 'Extensive search conducted, but wreckage not found.'),
('Op Vanilla', 'HADR', '2020-01-28', '2020-02-03', 'Madagascar', 'Southern', 'Completed', 'Assistance to Madagascar after Cyclone Diane.', 'Provided essential supplies, medical aid, and assistance.'),
('SLINEX 2023', 'Fleet Exercise', '2023-04-03', '2023-04-08', 'Colombo, Sri Lanka', 'Southern', 'Completed', 'Bilateral exercise with the Sri Lanka Navy.', 'Fostered closer maritime ties and operational synergy.'),
('Mission Sagar', 'Humanitarian Mission', '2020-05-10', '2020-06-28', 'IOR littorals', 'Southern', 'Completed', 'Provide COVID-19 related assistance to friendly foreign countries.', 'Delivered food aid and medical supplies to Maldives, Mauritius, etc.'),
('PASSEX with US Navy', 'Fleet Exercise', '2023-07-22', '2023-07-22', 'Indian Ocean', 'Eastern', 'Completed', 'Passage Exercise with USS Ronald Reagan Carrier Strike Group.', 'Practiced communication and maneuvering drills.'),
('Op Castor', 'Salvage Operation', '2004-12-26', '2005-01-20', 'Sri Lanka, Maldives', 'Eastern', 'Completed', 'Post-Tsunami relief and salvage operations.', 'Cleared harbors and provided extensive relief aid.'),
('Konkan 2023', 'Fleet Exercise', '2023-03-20', '2023-03-22', 'Arabian Sea', 'Western', 'Completed', 'Bilateral exercise with the Royal Navy (UK).', 'Enhanced maritime security cooperation.'),
('Op Sukoon', 'Non-combatant Evacuation', '2006-07-19', '2006-08-01', 'Lebanon', 'Western', 'Completed', 'Evacuation during the 2006 Lebanon War.', 'Evacuated over 2,280 people, including Indian, Sri Lankan, and Nepali citizens.'),
('AUSINDEX 2023', 'Fleet Exercise', '2023-08-22', '2023-08-25', 'Sydney, Australia', 'Eastern', 'Completed', 'Bilateral exercise with the Royal Australian Navy.', 'Focused on anti-submarine warfare and integrated operations.'),
('JIMEX 23', 'Fleet Exercise', '2023-07-05', '2023-07-10', 'Visakhapatnam', 'Eastern', 'Completed', 'Bilateral exercise with the Japan Maritime Self-Defense Force.', 'Strengthened defense cooperation and interoperability.');

-- =================================================================
-- Table 8: Maintenance_Schedule
-- =================================================================
CREATE TABLE Maintenance_Schedule (
    maint_id INT PRIMARY KEY AUTO_INCREMENT,
    asset_id INT NOT NULL, -- Can be ship_id, aircraft_id, etc.
    asset_type VARCHAR(50) NOT NULL, -- 'Ship', 'Aircraft', 'Submarine'
    maintenance_type VARCHAR(100), -- 'Refit', 'Routine Check', 'Major Overhaul'
    scheduled_start_date DATE,
    scheduled_end_date DATE,
    actual_start_date DATE,
    actual_end_date DATE,
    status VARCHAR(50), -- 'Scheduled', 'In Progress', 'Completed', 'Delayed'
    performing_unit_id INT -- e.g., base_id of the dockyard
);

-- Insert records for Maintenance_Schedule
INSERT INTO Maintenance_Schedule (asset_id, asset_type, maintenance_type, scheduled_start_date, scheduled_end_date, actual_start_date, actual_end_date, status, performing_unit_id) VALUES
(1, 'Ship', 'Mid-Life Refit', '2024-01-15', '2025-08-15', '2024-01-20', NULL, 'In Progress', 1),
(2, 'Ship', 'Short Refit', '2025-09-01', '2025-12-01', NULL, NULL, 'Scheduled', 1),
(3, 'Aircraft', 'Phase A Check', '2025-04-30', '2025-05-30', '2025-04-30', '2025-05-28', 'Completed', 6),
(12, 'Ship', 'Normal Refit', '2023-11-01', '2024-05-01', '2023-11-05', '2024-05-10', 'Completed', 2),
(5, 'Aircraft', 'Major Overhaul', '2026-01-10', '2026-07-10', NULL, NULL, 'Scheduled', 7),
(8, 'Ship', 'Routine Maintenance', '2025-08-01', '2025-08-15', '2025-08-01', '2025-08-14', 'Completed', 4),
(1, 'Aircraft', 'Engine Replacement', '2024-10-01', '2024-10-30', '2024-10-05', '2024-11-02', 'Completed', 7),
(15, 'Ship', 'Dry Docking', '2025-02-01', '2025-04-01', '2025-02-01', NULL, 'In Progress', 2),
(7, 'Aircraft', 'Avionics Upgrade', '2023-09-15', '2023-10-15', '2023-09-15', '2023-10-20', 'Completed', 6),
(11, 'Ship', 'Assisted Maintenance Period', '2025-11-10', '2025-12-10', NULL, NULL, 'Scheduled', 3),
(20, 'Aircraft', 'Routine Check', '2025-07-20', '2025-07-22', '2025-07-20', '2025-07-21', 'Completed', 7),
(4, 'Ship', 'Guarantee Refit', '2017-12-01', '2018-03-01', '2017-12-01', '2018-03-05', 'Completed', 2),
(13, 'Ship', 'Medium Refit', '2026-03-01', '2027-01-01', NULL, NULL, 'Scheduled', 2),
(2, 'Aircraft', 'Phase B Check', '2025-08-01', '2025-09-15', NULL, NULL, 'Scheduled', 6),
(6, 'Ship', 'Self Maintenance Period', '2025-10-05', '2025-10-20', NULL, NULL, 'Scheduled', 3),
(10, 'Ship', 'Weapon Systems Upgrade', '2024-05-01', '2024-08-01', '2024-05-02', '2024-08-05', 'Completed', 3),
(18, 'Aircraft', 'Structural Inspection', '2025-09-01', '2025-09-30', NULL, NULL, 'Scheduled', 14),
(14, 'Ship', 'Sonar Dome Replacement', '2025-07-01', '2025-08-15', '2025-07-01', NULL, 'In Progress', 2),
(19, 'Aircraft', 'Phase C Check', '2024-11-15', '2025-01-15', '2024-11-15', '2025-01-20', 'Completed', 14),
(17, 'Ship', 'Routine Dry Docking', '2023-08-01', '2023-09-15', '2023-08-01', '2023-09-18', 'Completed', 2);

-- =================================================================
-- Table 9: Training_Courses
-- =================================================================
CREATE TABLE Training_Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(150),
    course_code VARCHAR(20),
    training_establishment_id INT, -- links to Bases table (e.g., INA, INS Chilka)
    duration_weeks INT,
    category VARCHAR(50), -- 'Officer', 'Sailor', 'Specialization'
    description TEXT,
    prerequisites VARCHAR(255),
    certification_awarded VARCHAR(100),
    course_capacity INT
);

-- Insert records for Training_Courses
INSERT INTO Training_Courses (course_name, course_code, training_establishment_id, duration_weeks, category, description, prerequisites, certification_awarded, course_capacity) VALUES
('Naval Orientation Course', 'NOC', 10, 22, 'Officer', 'Basic training for officer cadets.', 'NDA/NA/INAC Entry', 'Commissioned as Sub-Lieutenant', 700),
('Seaman I Course', 'SMC-I', 9, 24, 'Sailor', 'Ab-initio training for sailors.', 'Matriculation', 'Seaman II', 2500),
('Anti-Submarine Warfare Specialization', 'ASW-SPEC', 4, 36, 'Specialization', 'Advanced course in ASW tactics and equipment.', 'Lieutenant Rank, Sea Time', 'ASW Specialist Badge', 30),
('Marine Commando Course (Basic)', 'MARCOS-B', 4, 10, 'Specialization', 'Basic training for MARCOS.', 'Volunteer Officer/Sailor, Physical/Medical Standards', 'MARCOS Probationer', 60),
('Hydrography Long Course', 'HYDRO-L', 7, 42, 'Specialization', 'Comprehensive course in hydrographic survey.', 'Sub-Lieutenant/Lieutenant', 'Cat A Hydrographer', 20),
('Submarine Qualifying Course', 'SMQ', 3, 52, 'Specialization', 'Training for service on submarines.', 'Volunteer Officer/Sailor, Medical Fitness', 'Dolphin Badge', 50),
('Naval Air Operations Course', 'NAOC', 4, 22, 'Officer', 'Training for Air Traffic Control and Fighter Control.', 'Sub-Lieutenant', 'Air Operations Officer', 25),
('Damage Control & Fire Fighting', 'DCFF', 1, 4, 'All', 'Basic and advanced DCFF drills.', 'All personnel', 'DCFF Certificate', 100),
('Gunnery Long Course', 'GUN-L', 4, 38, 'Specialization', 'Advanced course in naval gunnery and missile warfare.', 'Lieutenant Rank', 'Gunnery Specialist', 25),
('Navigation & Direction Long Course', 'ND-L', 4, 40, 'Specialization', 'Advanced course in naval navigation and operations.', 'Lieutenant Rank', 'Navigation Specialist', 30),
('Leadership Capsule Course', 'LCC', 10, 2, 'Sailor', 'Short course to develop leadership skills in senior sailors.', 'Petty Officer', 'Certificate of Completion', 80),
('Cyber Security Fundamentals', 'CSF', 4, 8, 'Specialization', 'Course on network security and cyber warfare.', 'Any Rank, Aptitude Test', 'Cyber Security Operator', 40),
('Diving Officer Course', 'DIV-O', 4, 24, 'Officer', 'Training to become a ships diver and clearance diving officer.', 'Sub-Lieutenant, Medical Fitness', 'Diving Officer', 15),
('Petty Officer Qualifying Course', 'POQ', 9, 12, 'Sailor', 'Professional training for promotion to Petty Officer.', 'Leading Seaman', 'Petty Officer Rank', 200),
('Logistics Management Course', 'LOG-M', 18, 26, 'Officer', 'Training in naval logistics and supply chain management.', 'Sub-Lieutenant', 'Logistics Officer', 40),
('Pilot Training - Fixed Wing', 'PLT-FW', 7, 72, 'Officer', 'Basic and advanced flying training on fixed-wing aircraft.', 'Pilot Aptitude Battery Test', 'Naval Pilot Wings', 10),
('Pilot Training - Rotary Wing', 'PLT-RW', 6, 60, 'Officer', 'Basic and advanced flying training on helicopters.', 'Pilot Aptitude Battery Test', 'Naval Pilot Wings', 15),
('Chief Petty Officer Qualifying Course', 'CPOQ', 9, 10, 'Sailor', 'Professional training for promotion to CPO.', 'Petty Officer', 'Chief Petty Officer Rank', 150),
('Marine Engineering Specialization Course', 'MESC', 1, 104, 'Officer', 'B.Tech in Marine Engineering for technical officers.', '10+2 (PCM)', 'B.Tech Degree', 120),
('Medical Assistant Course', 'MAC', 1, 52, 'Sailor', 'Training for sailors in the medical branch.', '10+2 (Biology)', 'Medical Assistant Grade I', 50);

-- =================================================================
-- Table 10: Personnel_Enlistment
-- =================================================================
CREATE TABLE Personnel_Enlistment (
    enlistment_id INT PRIMARY KEY AUTO_INCREMENT,
    personnel_id INT,
    course_id INT,
    enrollment_date DATE,
    graduation_date DATE,
    performance_grade VARCHAR(2), -- e.g., A+, B, C-
    final_score DECIMAL(5,2),
    rank_at_graduation VARCHAR(50),
    remarks TEXT,
    is_top_performer BOOLEAN,
    FOREIGN KEY (personnel_id) REFERENCES Personnel(personnel_id),
    FOREIGN KEY (course_id) REFERENCES Training_Courses(course_id)
);

-- Insert records for Personnel_Enlistment
INSERT INTO Personnel_Enlistment (personnel_id, course_id, enrollment_date, graduation_date, performance_grade, final_score, rank_at_graduation, remarks, is_top_performer) VALUES
(7, 1, '2013-07-15', '2015-01-10', 'A', 88.50, 'Sub-Lieutenant', 'Good performance in academics.', 0),
(12, 2, '2015-02-01', '2016-07-30', 'A+', 92.10, 'Seaman II', 'Excellent in drills and physicals.', 1),
(5, 3, '2010-01-04', '2010-09-10', 'A', 89.00, 'Lieutenant Commander', 'Specialized in sonar operations.', 0),
(8, 18, '1991-08-01', '1992-06-15', 'B+', 84.50, 'Chief Petty Officer', 'Strong leadership potential noted.', 0),
(6, 1, '2010-07-10', '2012-06-22', 'A+', 94.20, 'Sub-Lieutenant', 'Awarded President''s Gold Medal.', 1),
(13, 2, '2017-06-20', '2018-12-15', 'B', 78.90, 'Seaman II', 'Average performance.', 0),
(4, 9, '2005-01-10', '2005-10-20', 'A', 91.50, 'Commander', 'Topped the course.', 1),
(10, 14, '2001-01-15', '2001-04-05', 'A', 87.80, 'Petty Officer', 'Good technical skills.', 0),
(17, 1, '2011-07-12', '2013-06-22', 'B+', 83.40, 'Sub-Lieutenant', 'Consistent performer.', 0),
(14, 2, '2019-01-05', '2020-06-10', 'B+', 82.00, 'Seaman II', 'Showed great improvement.', 0),
(3, 10, '2001-01-08', '2001-10-18', 'A', 90.25, 'Captain', 'Excellent navigational skills.', 0),
(11, 14, '2005-02-01', '2005-04-28', 'A', 86.90, 'Petty Officer', 'Excelled in practicals.', 0),
(18, 1, '2014-07-15', '2016-01-10', 'A', 89.80, 'Sub-Lieutenant', 'Commended for project work.', 0),
(19, 18, '2001-08-01', '2002-06-15', 'A', 88.00, 'Chief Petty Officer', 'Highly motivated individual.', 0),
(9, 14, '1994-01-10', '1994-04-01', 'B', 79.50, 'Petty Officer', 'Met all course requirements.', 0),
(16, 9, '2006-01-09', '2006-10-19', 'A+', 93.00, 'Commander', 'Awarded best all-round officer.', 1),
(20, 14, '2006-02-01', '2006-04-28', 'B+', 84.00, 'Petty Officer', 'Good team player.', 0),
(1, 10, '1985-01-15', '1985-10-25', 'A', 91.00, 'Admiral', 'Demonstrated exceptional leadership.', 0),
(2, 9, '1987-08-10', '1988-05-20', 'A', 90.50, 'Vice Admiral', 'Top of his batch in gunnery.', 0),
(15, 10, '2002-01-14', '2002-10-24', 'B+', 85.50, 'Captain', 'Solid understanding of tactics.', 0);

-- =================================================================
-- Table 11: Medical_Records
-- =================================================================
CREATE TABLE Medical_Records (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    personnel_id INT,
    checkup_date DATE,
    medical_category VARCHAR(10), -- e.g., S1A1, S2A2
    height_cm INT,
    weight_kg INT,
    vision_l VARCHAR(10),
    vision_r VARCHAR(10),
    allergies TEXT,
    remarks TEXT,
    doctor_id INT,
    FOREIGN KEY (personnel_id) REFERENCES Personnel(personnel_id)
);

-- Insert records for Medical_Records
INSERT INTO Medical_Records (personnel_id, checkup_date, medical_category, height_cm, weight_kg, vision_l, vision_r, allergies, remarks, doctor_id) VALUES
(1, '2025-01-10', 'S1A1', 178, 78, '6/6', '6/6', 'None', 'Fit for service.', 101),
(2, '2025-02-15', 'S1A1', 180, 82, '6/6', '6/6', 'None', 'Fit for sea duty.', 101),
(3, '2025-03-20', 'S1A1', 175, 75, '6/6', '6/9', 'Pollen', 'Corrective lenses required for distance.', 102),
(4, '2025-04-05', 'S1A1', 168, 62, '6/6', '6/6', 'None', 'Excellent health.', 102),
(5, '2025-05-12', 'S2A1', 182, 85, '6/6', '6/6', 'None', 'Minor knee issue, fit for shore duty.', 103),
(6, '2025-06-18', 'S1A1', 170, 60, '6/6', '6/6', 'None', 'Fit for all duties.', 103),
(7, '2025-07-01', 'S1A1', 176, 72, '6/6', '6/6', 'None', 'Cleared annual medical.', 104),
(8, '2024-12-05', 'S1A2', 172, 78, '6/9', '6/9', 'Dust', 'Slight hearing loss in right ear.', 105),
(9, '2025-01-22', 'S1A1', 174, 76, '6/6', '6/6', 'None', 'Fit.', 105),
(10, '2025-02-28', 'S1A1', 170, 74, '6/6', '6/6', 'None', 'Fit.', 106),
(11, '2025-03-14', 'S1A1', 165, 58, '6/6', '6/6', 'Penicillin', 'Allergy noted. Fit for duty.', 106),
(12, '2025-04-19', 'S1A1', 179, 75, '6/6', '6/6', 'None', 'Cleared.', 107),
(13, '2025-05-25', 'S1A1', 181, 77, '6/6', '6/6', 'None', 'Cleared.', 107),
(14, '2025-06-30', 'S1A1', 167, 61, '6/6', '6/6', 'None', 'Cleared.', 108),
(15, '2025-07-05', 'S1A1', 177, 79, '6/6', '6/6', 'None', 'Fit.', 102),
(16, '2024-11-15', 'S2A2', 169, 64, '6/12', '6/9', 'None', 'High blood pressure, under observation.', 102),
(17, '2025-01-08', 'S1A1', 183, 88, '6/6', '6/6', 'None', 'Fit for flying duties.', 103),
(18, '2025-02-11', 'S1A1', 171, 63, '6/6', '6/6', 'None', 'Fit.', 104),
(19, '2025-03-19', 'S1A1', 173, 80, '6/9', '6/6', 'None', 'Fit.', 105),
(20, '2025-04-23', 'S1A1', 166, 59, '6/6', '6/6', 'None', 'Fit.', 106);

-- =================================================================
-- Table 12: Logistics_Supply
-- =================================================================
CREATE TABLE Logistics_Supply (
    supply_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100),
    nato_stock_number VARCHAR(20),
    item_category VARCHAR(50), -- 'Fuel', 'Ammunition', 'Spares', 'Rations'
    quantity INT,
    unit_of_measure VARCHAR(20), -- 'Litres', 'Rounds', 'Units', 'Kgs'
    storage_location_id INT, -- links to Bases table
    supplier VARCHAR(100),
    last_order_date DATE,
    expiry_date DATE
);

-- Insert records for Logistics_Supply
INSERT INTO Logistics_Supply (item_name, nato_stock_number, item_category, quantity, unit_of_measure, storage_location_id, supplier, last_order_date, expiry_date) VALUES
('HSD Fuel', '9140-12-345-6789', 'Fuel', 5000000, 'Litres', 1, 'IOCL', '2025-07-15', NULL),
('7.62mm Rounds', '1305-99-962-1361', 'Ammunition', 1000000, 'Rounds', 17, 'Ordnance Factory Board', '2025-05-20', '2035-05-20'),
('Gas Turbine Engine Spare Blade', '2840-12-389-5501', 'Spares', 50, 'Units', 18, 'HAL', '2025-06-01', NULL),
('Ready-to-Eat Meals (Veg)', '8970-14-555-1234', 'Rations', 50000, 'Units', 18, 'DRDO', '2025-07-01', '2026-07-01'),
('Barak 8 Missile Canister', '1440-12-390-1122', 'Ammunition', 20, 'Units', 16, 'IAI/DRDO', '2025-03-10', '2040-03-10'),
('ATF Fuel', '9130-12-123-4567', 'Fuel', 2000000, 'Litres', 7, 'BPCL', '2025-07-10', NULL),
('76mm HE Shells', '1315-12-145-9876', 'Ammunition', 5000, 'Rounds', 17, 'Oto Melara', '2025-04-15', '2045-04-15'),
('Sonar Transducer Array', '5845-12-367-8901', 'Spares', 5, 'Units', 8, 'Thales', '2025-02-20', NULL),
('Fresh Vegetables', '8915-00-123-4567', 'Rations', 10000, 'Kgs', 1, 'Local Supplier', '2025-07-28', '2025-08-04'),
('Heavyweight Torpedo Battery', '6135-12-378-4321', 'Spares', 30, 'Units', 16, 'DRDO', '2025-06-25', '2030-06-25'),
('Submarine Diesel Fuel', '9140-12-345-9999', 'Fuel', 1000000, 'Litres', 2, 'IOCL', '2025-07-05', NULL),
('RBU-6000 Rockets', '1325-12-155-5555', 'Ammunition', 2000, 'Rounds', 17, 'Degtyarev Plant', '2025-01-30', '2040-01-30'),
('Radar Magnetron', '5840-12-355-7788', 'Spares', 20, 'Units', 3, 'BEL', '2025-05-05', NULL),
('Flour', '8920-00-234-5678', 'Rations', 20000, 'Kgs', 18, 'FCI', '2025-06-18', '2026-06-18'),
('Fire Fighting Foam', '4210-12-321-9876', 'Consumables', 50000, 'Litres', 1, 'Local Supplier', '2025-04-01', '2030-04-01'),
('MiG-29K Landing Gear Assembly', '1630-12-399-1234', 'Spares', 4, 'Units', 7, 'RAC MiG', '2025-03-22', NULL),
('Medical Kits - Type A', '6545-12-333-4444', 'Medical', 1000, 'Units', 1, 'Local Supplier', '2025-07-01', '2027-07-01'),
('Distilled Water', '6810-00-456-7890', 'Consumables', 100000, 'Litres', 2, 'Local Supplier', '2025-07-20', NULL),
('Engine Lubricating Oil', '9150-12-311-2233', 'Consumables', 80000, 'Litres', 1, 'Castrol', '2025-06-11', '2028-06-11'),
('Navigation Charts - Arabian Sea', '7644-12-301-5678', 'Consumables', 500, 'Units', 1, 'National Hydrographic Office', '2025-01-01', NULL);

-- =================================================================
-- Table 13: Communication_Logs
-- =================================================================
CREATE TABLE Communication_Logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    source_unit_id INT,
    source_unit_type VARCHAR(50), -- 'Ship', 'Base', 'Aircraft'
    destination_unit_id INT,
    destination_unit_type VARCHAR(50),
    log_timestamp DATETIME,
    frequency_mhz DECIMAL(10, 4),
    mode VARCHAR(20), -- 'Voice', 'Data', 'HF', 'VHF', 'SATCOM'
    classification VARCHAR(20), -- 'Unclassified', 'Restricted', 'Secret'
    summary TEXT
);

-- Insert records for Communication_Logs
INSERT INTO Communication_Logs (source_unit_id, source_unit_type, destination_unit_id, destination_unit_type, log_timestamp, frequency_mhz, mode, classification, summary) VALUES
(2, 'Ship', 1, 'Base', '2025-07-30 10:00:00', 243.0000, 'VHF', 'Restricted', 'Reporting hourly position and status.'),
(1, 'Aircraft', 7, 'Base', '2025-07-30 11:30:00', 121.5000, 'Voice', 'Unclassified', 'Routine air traffic control communication.'),
(5, 'Ship', 2, 'Base', '2025-07-30 12:05:00', 4500.0000, 'SATCOM', 'Secret', 'Operational update for Op Sankalp.'),
(12, 'Ship', 2, 'Base', '2025-07-29 20:00:00', 12.3450, 'HF', 'Restricted', 'Weather report for area of operation.'),
(3, 'Aircraft', 1, 'Ship', '2025-07-29 15:10:00', 305.5000, 'Data', 'Secret', 'Transmitting surveillance data.'),
(10, 'Base', 2, 'Ship', '2025-07-28 09:00:00', 4600.0000, 'SATCOM', 'Restricted', 'Logistics and supply coordination message.'),
(4, 'Squadron', 7, 'Base', '2025-07-28 14:00:00', 255.4000, 'Voice', 'Unclassified', 'Request for maintenance support.'),
(1, 'Ship', 3, 'Ship', '2025-07-27 18:30:00', 156.8000, 'VHF', 'Unclassified', 'Coordination for passing exercise (PASSEX).'),
(11, 'Ship', 3, 'Base', '2025-07-27 10:00:00', 14.1230, 'HF', 'Restricted', 'Weekly report submission.'),
(6, 'Aircraft', 6, 'Base', '2025-07-26 22:00:00', 4800.0000, 'Data', 'Secret', 'Transmitting ISR data from patrol.'),
(8, 'Ship', 4, 'Base', '2025-07-26 16:45:00', 243.0000, 'Voice', 'Unclassified', 'Requesting port clearance.'),
(14, 'Ship', 2, 'Base', '2025-07-25 08:00:00', 4550.0000, 'SATCOM', 'Secret', 'Submarine patrol report.'),
(2, 'Aircraft', 6, 'Base', '2025-07-25 13:20:00', 123.1000, 'Voice', 'Unclassified', 'Request for weather update.'),
(7, 'Ship', 3, 'Base', '2025-07-24 19:00:00', 10.9870, 'HF', 'Restricted', 'Personnel transfer request.'),
(1, 'Base', 1, 'Ship', '2025-07-24 11:00:00', 4700.0000, 'Data', 'Secret', 'Operational orders transmitted.'),
(16, 'Ship', 1, 'Base', '2025-07-23 07:30:00', 156.8000, 'VHF', 'Unclassified', 'Morning status report.'),
(5, 'Aircraft', 4, 'Base', '2025-07-23 17:00:00', 255.4000, 'Voice', 'Unclassified', 'Reporting completion of training sortie.'),
(9, 'Ship', 4, 'Base', '2025-07-22 14:15:00', 4525.0000, 'SATCOM', 'Restricted', 'Medical assistance request.'),
(1, 'Operations', 1, 'Ship', '2025-07-22 09:00:00', 4750.0000, 'Data', 'Secret', 'Tasking order for anti-piracy patrol.'),
(3, 'Ship', 2, 'Base', '2025-07-21 21:00:00', 13.4560, 'HF', 'Restricted', 'End of day report.');

-- =================================================================
-- Table 14: Intelligence_Reports
-- =================================================================
CREATE TABLE Intelligence_Reports (
    report_id INT PRIMARY KEY AUTO_INCREMENT,
    report_title VARCHAR(255),
    report_date DATE,
    source_agency VARCHAR(100),
    classification VARCHAR(50), -- 'Confidential', 'Secret', 'Top Secret'
    region_of_interest VARCHAR(100),
    summary TEXT,
    analyst_id INT, -- links to Personnel
    reliability_code CHAR(1), -- A-F (A=Completely reliable, F=Cannot be judged)
    credibility_code CHAR(1) -- 1-6 (1=Confirmed by other sources, 6=Cannot be judged)
);

-- Insert records for Intelligence_Reports
INSERT INTO Intelligence_Reports (report_title, report_date, source_agency, classification, region_of_interest, summary, analyst_id, reliability_code, credibility_code) VALUES
('Increased Pirate Activity in Somali Basin', '2025-07-28', 'Naval Intelligence', 'Secret', 'Gulf of Aden', 'Satellite imagery and HUMINT suggest a new pirate action group is operational.', 42, 'B', '2'),
('Foreign Submarine Detected near A&N Islands', '2025-07-25', 'Signal Intelligence', 'Top Secret', 'Bay of Bengal', 'Acoustic signature of a non-allied SSN detected.', 43, 'A', '1'),
('Analysis of New Anti-Ship Missile Test', '2025-07-20', 'Technical Intelligence', 'Secret', 'South China Sea', 'Analysis of a recent missile test by a regional power indicates improved range and ECCM capabilities.', 44, 'B', '2'),
('Vessel Trafficking in Palk Strait', '2025-07-18', 'Coastal Surveillance', 'Confidential', 'Palk Strait', 'Increase in unregistered fishing trawlers operating at night, possible smuggling.', 45, 'C', '3'),
('Political Instability in Littoral State', '2025-07-15', 'Defence Intelligence Agency', 'Secret', 'Indian Ocean Region', 'Assessment of potential impact of political instability on maritime security.', 42, 'D', '2'),
('Cyber Threat Actor Profile', '2025-07-10', 'Cyber Command', 'Top Secret', 'Global', 'Profile of a state-sponsored hacking group targeting naval communication systems.', 46, 'A', '2'),
('Arms Smuggling Route Identified', '2025-07-05', 'Human Intelligence', 'Secret', 'Arabian Sea', 'Credible source reports a new route for small arms smuggling via dhows.', 43, 'B', '3'),
('Satellite Imagery of Port Expansion', '2025-06-30', 'Imagery Intelligence', 'Secret', 'Gwadar', 'Recent imagery shows significant progress on new naval berths and support infrastructure.', 44, 'A', '1'),
('Assessment of Regional Naval Exercise', '2025-06-25', 'Naval Intelligence', 'Confidential', 'Western Pacific', 'Analysis of a recent bilateral naval exercise and its implications.', 45, 'C', '2'),
('Unusual UAV Activity', '2025-06-20', 'UAV Surveillance', 'Secret', 'Sir Creek', 'Repeated sorties of an unidentified UAV model detected along the maritime boundary.', 46, 'B', '1'),
('Threat of IEDs on Merchant Vessels', '2025-06-15', 'Open Source Intelligence', 'Confidential', 'Strait of Hormuz', 'Online chatter suggests a non-state actor is planning to use limpet mines.', 42, 'D', '4'),
('Foreign Research Vessel Activity', '2025-06-10', 'Naval Intelligence', 'Secret', 'Ninety East Ridge', 'A foreign research vessel is operating unusually close to undersea communication cables.', 43, 'C', '2'),
('Narcotics Trafficking Patterns', '2025-06-05', 'NCB/Naval Intel', 'Secret', 'Makran Coast', 'Joint report on changing patterns of narcotics trafficking from the Makran coast.', 44, 'B', '2'),
('Submarine Pen Construction', '2025-05-30', 'Imagery Intelligence', 'Top Secret', 'Coco Islands', 'High-resolution imagery confirms ongoing construction of submarine pens.', 45, 'A', '1'),
('Electronic Warfare Capability Assessment', '2025-05-25', 'Electronic Intelligence', 'Top Secret', 'Regional Power X', 'Assessment of the EW capabilities of a potential adversary''s naval fleet.', 46, 'B', '2'),
('Impact of Climate Change on Naval Ops', '2025-05-20', 'Strategic Analysis Wing', 'Confidential', 'Indian Ocean Region', 'Long-term assessment of rising sea levels on coastal bases.', 42, 'E', '3'),
('Illegal Fishing Fleet Operations', '2025-05-15', 'Fisheries Dept/Naval Intel', 'Confidential', 'Exclusive Economic Zone', 'Report on a large foreign fishing fleet operating illegally within India''s EEZ.', 43, 'A', '1'),
('Mine-laying Capabilities of Adversary', '2025-05-10', 'Naval Intelligence', 'Secret', 'North Arabian Sea', 'Updated assessment of a regional navy''s capacity for offensive mining operations.', 44, 'C', '2'),
('Social Media Disinformation Campaign', '2025-05-05', 'Cyber Command', 'Secret', 'Online', 'Identification of a coordinated campaign to spread disinformation about naval operations.', 45, 'B', '2'),
('Analysis of Foreign Naval Doctrine', '2025-05-01', 'Defence Intelligence Agency', 'Secret', 'Global', 'Translation and analysis of a newly published naval doctrine from a foreign power.', 46, 'A', '2');

-- =================================================================
-- Table 15: Budgets
-- =================================================================
CREATE TABLE Budgets (
    budget_id INT PRIMARY KEY AUTO_INCREMENT,
    fiscal_year VARCHAR(10), -- e.g., '2025-2026'
    command_id INT, -- Can be Base ID, Command HQ, etc.
    command_type VARCHAR(50), -- 'Base', 'Command', 'Project'
    allocated_capital DECIMAL(15, 2),
    allocated_revenue DECIMAL(15, 2),
    expenditure_capital DECIMAL(15, 2),
    expenditure_revenue DECIMAL(15, 2),
    budget_status VARCHAR(50), -- 'Approved', 'Pending', 'Exhausted'
    approving_authority VARCHAR(100)
);

-- Insert records for Budgets
INSERT INTO Budgets (fiscal_year, command_id, command_type, allocated_capital, allocated_revenue, expenditure_capital, expenditure_revenue, budget_status, approving_authority) VALUES
('2025-2026', 1, 'Base', 500000000.00, 2000000000.00, 120000000.00, 850000000.00, 'Approved', 'MoD'),
('2025-2026', 2, 'Base', 800000000.00, 1500000000.00, 250000000.00, 700000000.00, 'Approved', 'MoD'),
('2025-2026', 3, 'Base', 600000000.00, 1800000000.00, 180000000.00, 950000000.00, 'Approved', 'MoD'),
('2024-2025', 1, 'Base', 480000000.00, 1900000000.00, 475000000.00, 1890000000.00, 'Exhausted', 'MoD'),
('2025-2026', 101, 'Project P-17A', 12000000000.00, 50000000.00, 3000000000.00, 25000000.00, 'Approved', 'Cabinet Committee on Security'),
('2025-2026', 102, 'Project P-75I', 15000000000.00, 80000000.00, 1000000000.00, 30000000.00, 'Approved', 'Cabinet Committee on Security'),
('2025-2026', 4, 'Base', 400000000.00, 1200000000.00, 100000000.00, 500000000.00, 'Approved', 'MoD'),
('2025-2026', 7, 'Base', 300000000.00, 1000000000.00, 80000000.00, 450000000.00, 'Approved', 'MoD'),
('2024-2025', 2, 'Base', 750000000.00, 1400000000.00, 740000000.00, 1395000000.00, 'Exhausted', 'MoD'),
('2025-2026', 1, 'Command', 20000000000.00, 50000000000.00, 0.00, 0.00, 'Approved', 'MoD'), -- WNC
('2025-2026', 2, 'Command', 18000000000.00, 45000000000.00, 0.00, 0.00, 'Approved', 'MoD'), -- ENC
('2025-2026', 3, 'Command', 15000000000.00, 40000000000.00, 0.00, 0.00, 'Approved', 'MoD'), -- SNC
('2025-2026', 10, 'Base', 250000000.00, 800000000.00, 50000000.00, 300000000.00, 'Approved', 'MoD'),
('2024-2025', 101, 'Project P-17A', 11000000000.00, 45000000.00, 10950000000.00, 44000000.00, 'Exhausted', 'Cabinet Committee on Security'),
('2025-2026', 103, 'Project Varsha', 5000000000.00, 20000000.00, 500000000.00, 10000000.00, 'Approved', 'MoD'),
('2025-2026', 16, 'Base', 100000000.00, 50000000.00, 0.00, 0.00, 'Pending', 'Naval HQ'),
('2024-2025', 7, 'Base', 280000000.00, 950000000.00, 275000000.00, 945000000.00, 'Exhausted', 'MoD'),
('2025-2026', 104, 'UAV Procurement', 2000000000.00, 10000000.00, 0.00, 0.00, 'Approved', 'Defence Acquisition Council'),
('2025-2026', 17, 'Base', 150000000.00, 400000000.00, 20000000.00, 150000000.00, 'Approved', 'MoD'),
('2024-2025', 4, 'Base', 380000000.00, 1100000000.00, 370000000.00, 1090000000.00, 'Exhausted', 'MoD');

-- =================================================================
-- Table 16: Submarines
-- =================================================================
CREATE TABLE Submarines (
    sub_id INT PRIMARY KEY AUTO_INCREMENT,
    pennant_number VARCHAR(10) UNIQUE NOT NULL,
    sub_name VARCHAR(100),
    sub_class VARCHAR(100),
    sub_type VARCHAR(50), -- 'SSN', 'SSBN', 'SSK'
    commission_date DATE,
    decommission_date DATE,
    home_port_id INT,
    current_status VARCHAR(50),
    commanding_officer_id INT
);

-- Insert records for Submarines
INSERT INTO Submarines (pennant_number, sub_name, sub_class, sub_type, commission_date, home_port_id, current_status, commanding_officer_id) VALUES
('S71', 'INS Arihant', 'Arihant-class', 'SSBN', '2016-08-01', 3, 'Active', 51),
('S72', 'INS Arighat', 'Arihant-class', 'SSBN', '2024-01-01', 3, 'Active', 52),
('S50', 'INS Chakra', 'Akula-class', 'SSN', '2012-04-04', 3, 'Returned to Russia', 53),
('S21', 'INS Kalvari', 'Kalvari-class', 'SSK', '2017-12-14', 2, 'Active', 12),
('S22', 'INS Khanderi', 'Kalvari-class', 'SSK', '2019-09-28', 2, 'Active', 13),
('S23', 'INS Karanj', 'Kalvari-class', 'SSK', '2021-03-10', 2, 'Active', 14),
('S24', 'INS Vela', 'Kalvari-class', 'SSK', '2021-11-25', 2, 'Active', 54),
('S25', 'INS Vagir', 'Kalvari-class', 'SSK', '2023-01-23', 2, 'Active', 55),
('S26', 'INS Vagsheer', 'Kalvari-class', 'SSK', '2024-05-01', 2, 'Sea Trials', 56),
('S55', 'INS Sindhughosh', 'Sindhughosh-class', 'SSK', '1986-04-30', 2, 'Active', 21),
('S56', 'INS Sindhudhvaj', 'Sindhughosh-class', 'SSK', '1987-06-12', 2, 'Decommissioned', NULL),
('S57', 'INS Sindhuraj', 'Sindhughosh-class', 'SSK', '1987-10-20', 2, 'Active', 57),
('S58', 'INS Sindhuvir', 'Sindhughosh-class', 'SSK', '1988-08-26', 2, 'Transferred to Myanmar', NULL),
('S60', 'INS Sindhukesari', 'Sindhughosh-class', 'SSK', '1989-02-16', 2, 'Active', 58),
('S61', 'INS Sindhukirti', 'Sindhughosh-class', 'SSK', '1990-01-04', 3, 'Active', 59),
('S62', 'INS Sindhuvijay', 'Sindhughosh-class', 'SSK', '1991-03-08', 2, 'Active', 60),
('S63', 'INS Sindhuratna', 'Sindhughosh-class', 'SSK', '1988-12-22', 2, 'Active', 61),
('S44', 'INS Shishumar', 'Shishumar-class', 'SSK', '1986-09-22', 2, 'Active', 62),
('S45', 'INS Shankush', 'Shishumar-class', 'SSK', '1986-11-20', 2, 'Active', 63),
('S46', 'INS Shalki', 'Shishumar-class', 'SSK', '1992-02-07', 2, 'Active', 64);

-- =================================================================
-- Table 17: Promotions
-- =================================================================
CREATE TABLE Promotions (
    promotion_id INT PRIMARY KEY AUTO_INCREMENT,
    personnel_id INT,
    date_of_promotion DATE,
    previous_rank VARCHAR(50),
    new_rank VARCHAR(50),
    promotion_board_id VARCHAR(50),
    remarks TEXT,
    effective_from DATE,
    citation TEXT,
    authority VARCHAR(100),
    FOREIGN KEY (personnel_id) REFERENCES Personnel(personnel_id)
);

-- Insert records for Promotions
INSERT INTO Promotions (personnel_id, date_of_promotion, previous_rank, new_rank, promotion_board_id, remarks, effective_from, citation, authority) VALUES
(3, '2022-08-15', 'Commander', 'Captain', 'PB-2022/1A', 'Promoted based on seniority and merit.', '2022-08-15', NULL, 'Naval HQ'),
(4, '2020-01-26', 'Lieutenant Commander', 'Commander', 'PB-2020/2B', 'Excellent service record.', '2020-01-26', NULL, 'Naval HQ'),
(5, '2018-07-01', 'Lieutenant', 'Lieutenant Commander', 'PB-2018/3C', 'Time scale promotion.', '2018-07-01', NULL, 'Naval HQ'),
(6, '2019-06-22', 'Sub-Lieutenant', 'Lieutenant', 'PB-2019/4A', 'Completed Sub-Lieutenant''s courses.', '2019-06-22', NULL, 'Naval HQ'),
(8, '2015-05-01', 'Master Chief Petty Officer II', 'Master Chief Petty Officer I', 'SailorPB-2015/1', 'Exemplary service.', '2015-05-01', NULL, 'Bureau of Sailors'),
(9, '2012-09-01', 'Chief Petty Officer', 'Master Chief Petty Officer II', 'SailorPB-2012/2', 'Outstanding performance.', '2012-09-01', NULL, 'Bureau of Sailors'),
(10, '2008-06-01', 'Petty Officer', 'Chief Petty Officer', 'SailorPB-2008/3', 'Meritorious service.', '2008-06-01', NULL, 'Bureau of Sailors'),
(11, '2010-02-01', 'Leading Seaman', 'Petty Officer', 'SailorPB-2010/4', 'Passed PO qualifying exam.', '2010-02-01', NULL, 'Bureau of Sailors'),
(12, '2020-08-01', 'Seaman I', 'Leading Seaman', 'SailorPB-2020/5', 'Passed professional exam.', '2020-08-01', NULL, 'Bureau of Sailors'),
(13, '2022-12-15', 'Seaman II', 'Seaman I', 'SailorPB-2022/6', 'Time scale advancement.', '2022-12-15', NULL, 'Bureau of Sailors'),
(15, '2023-01-01', 'Commander', 'Captain', 'PB-2022/1A', 'Promoted based on merit.', '2023-01-01', NULL, 'Naval HQ'),
(16, '2021-06-30', 'Lieutenant Commander', 'Commander', 'PB-2021/2B', 'Strong command potential.', '2021-06-30', NULL, 'Naval HQ'),
(17, '2020-06-22', 'Sub-Lieutenant', 'Lieutenant', 'PB-2020/4A', 'Completed all mandatory courses.', '2020-06-22', NULL, 'Naval HQ'),
(19, '2010-06-01', 'Petty Officer', 'Chief Petty Officer', 'SailorPB-2010/3', 'Consistent high performance.', '2010-06-01', NULL, 'Bureau of Sailors'),
(20, '2012-02-01', 'Leading Seaman', 'Petty Officer', 'SailorPB-2012/4', 'Topped qualifying exam.', '2012-02-01', NULL, 'Bureau of Sailors'),
(1, '2021-11-30', 'Vice Admiral', 'Admiral', 'Appointments Committee', 'Appointed as Chief of the Naval Staff.', '2021-11-30', NULL, 'President of India'),
(2, '2021-07-31', 'Vice Admiral', 'Vice Admiral', 'Appointments Committee', 'Appointed as Vice Chief of Naval Staff.', '2021-07-31', 'Promotion to C-in-C Grade', 'President of India'),
(7, '2022-01-10', 'Sub-Lieutenant', 'Lieutenant', 'PB-2022/4A', 'Time scale promotion.', '2022-01-10', NULL, 'Naval HQ'),
(18, '2023-01-10', 'Sub-Lieutenant', 'Lieutenant', 'PB-2023/4A', 'Time scale promotion.', '2023-01-10', NULL, 'Naval HQ'),
(14, '2024-06-10', 'Seaman II', 'Seaman I', 'SailorPB-2024/6', 'Time scale advancement.', '2024-06-10', NULL, 'Bureau of Sailors');

-- =================================================================
-- Table 18: Awards_And_Honours
-- =================================================================
CREATE TABLE Awards_And_Honours (
    award_id INT PRIMARY KEY AUTO_INCREMENT,
    personnel_id INT,
    award_name VARCHAR(100),
    award_category VARCHAR(50), -- 'Gallantry', 'Distinguished Service', 'Unit Citation'
    date_awarded DATE,
    citation TEXT,
    awarding_authority VARCHAR(100),
    operation_id INT,
    is_posthumous BOOLEAN,
    medal_serial_number VARCHAR(50),
    FOREIGN KEY (personnel_id) REFERENCES Personnel(personnel_id),
    FOREIGN KEY (operation_id) REFERENCES Operations(operation_id)
);

-- Insert records for Awards_And_Honours
INSERT INTO Awards_And_Honours (personnel_id, award_name, award_category, date_awarded, citation, awarding_authority, operation_id, is_posthumous, medal_serial_number) VALUES
(1, 'Param Vishisht Seva Medal', 'Distinguished Service', '2022-01-26', 'For distinguished service of the most exceptional order.', 'President of India', NULL, 0, 'PVSM-1234'),
(2, 'Ati Vishisht Seva Medal', 'Distinguished Service', '2021-01-26', 'For distinguished service of an exceptional order.', 'President of India', NULL, 0, 'AVSM-5678'),
(3, 'Nao Sena Medal (Gallantry)', 'Gallantry', '2016-01-26', 'For an act of individual gallantry during anti-piracy operations.', 'President of India', 7, 0, 'NM(G)-9101'),
(4, 'Nao Sena Medal (Devotion to Duty)', 'Distinguished Service', '2019-08-15', 'For exemplary devotion to duty as Commander of INS Kochi.', 'President of India', NULL, 0, 'NM(D)-1121'),
(5, 'Shaurya Chakra', 'Gallantry', '2011-01-26', 'For conspicuous gallantry during counter-terrorism operations.', 'President of India', NULL, 0, 'SC-3141'),
(8, 'Vishisht Seva Medal', 'Distinguished Service', '2018-01-26', 'For distinguished service of a high order.', 'President of India', NULL, 0, 'VSM-5161'),
(12, 'Chief of Naval Staff Commendation', 'Commendation', '2020-12-15', 'For exceptional performance during Seaman Course.', 'Chief of the Naval Staff', NULL, 0, NULL),
(6, 'President''s Gold Medal', 'Academic', '2012-06-22', 'For standing first in the overall order of merit at INA.', 'President of India', NULL, 0, NULL),
(1, 'Ati Vishisht Seva Medal', 'Distinguished Service', '2020-01-26', 'Prior to becoming CNS.', 'President of India', NULL, 0, 'AVSM-7181'),
(2, 'Nao Sena Medal (Gallantry)', 'Gallantry', '2002-01-26', 'For gallantry during Op Talwar.', 'President of India', NULL, 0, 'NM(G)-9191'),
(11, 'Chief of Naval Staff Commendation', 'Commendation', '2015-12-15', 'For excellence in diving operations.', 'Chief of the Naval Staff', NULL, 0, NULL),
(10, 'Mention-in-Despatches', 'Gallantry', '2002-01-26', 'For meritorious service during Op Parakram.', 'Chief of Army Staff', NULL, 0, NULL),
(7, 'Sarvottam Jeevan Raksha Padak', 'Life Saving', '2017-01-26', 'For saving lives during a fire incident.', 'President of India', NULL, 0, 'SJRP-101'),
(16, 'Nao Sena Medal (Devotion to Duty)', 'Distinguished Service', '2022-08-15', 'For her role in commissioning of INS Chennai.', 'President of India', NULL, 0, 'NM(D)-1321'),
(NULL, 'President''s Colour', 'Unit Citation', '2021-09-06', 'Awarded to Naval Aviation in recognition of its service.', 'President of India', NULL, 0, NULL),
(NULL, 'Unit Citation', 'Unit Citation', '2021-01-26', 'To INS Sahyadri for performance in the Eastern Fleet.', 'Chief of the Naval Staff', NULL, 0, NULL),
(4, 'Mention-in-Despatches', 'Gallantry', '2008-11-29', 'For role during 26/11 Mumbai attacks.', 'Chief of the Naval Staff', NULL, 0, NULL),
(15, 'Vishisht Seva Medal', 'Distinguished Service', '2020-01-26', 'For distinguished service as CO of INS Kochi.', 'President of India', NULL, 0, 'VSM-5262'),
(19, 'Nao Sena Medal (Devotion to Duty)', 'Distinguished Service', '2014-08-15', 'For long and meritorious service.', 'President of India', NULL, 0, 'NM(D)-1423'),
(20, 'Chief of Naval Staff Commendation', 'Commendation', '2018-12-15', 'For dedication and professionalism.', 'Chief of the Naval Staff', NULL, 0, NULL);

-- =================================================================
-- Table 19: Deployment_History
-- =================================================================
CREATE TABLE Deployment_History (
    deployment_id INT PRIMARY KEY AUTO_INCREMENT,
    asset_id INT,
    asset_type VARCHAR(50), -- 'Ship', 'Submarine', 'Aircraft'
    operation_id INT,
    deployment_start_date DATE,
    deployment_end_date DATE,
    role_in_operation VARCHAR(255),
    region VARCHAR(100),
    distance_sailed_nm INT,
    sorties_flown INT,
    FOREIGN KEY (operation_id) REFERENCES Operations(operation_id)
);

-- Insert records for Deployment_History
INSERT INTO Deployment_History (asset_id, asset_type, operation_id, deployment_start_date, deployment_end_date, role_in_operation, region, distance_sailed_nm, sorties_flown) VALUES
(2, 'Ship', 1, '2023-06-01', '2023-08-30', 'Flagship, Maritime Security Patrol', 'Gulf of Oman', 15000, NULL),
(1, 'Ship', 2, '2020-05-08', '2020-05-16', 'Evacuation of citizens from Maldives', 'Maldives', 3000, NULL),
(7, 'Ship', 3, '2023-08-11', '2023-08-21', 'Participant in multilateral exercise', 'East Coast Australia', 12000, NULL),
(3, 'Aircraft', 4, '2021-01-15', '2021-02-15', 'Long Range Maritime Reconnaissance Patrol', 'Indian Ocean Region', NULL, 20),
(6, 'Ship', 5, '2018-08-17', '2018-08-25', 'Helicopter platform for rescue ops', 'Kerala Coast', 500, NULL),
(11, 'Ship', 6, '2015-04-01', '2015-04-11', 'Evacuation of citizens from Yemen', 'Gulf of Aden', 4000, NULL),
(8, 'Ship', 7, '2022-11-01', '2023-02-01', 'Anti-piracy escort duties', 'Gulf of Aden', 18000, NULL),
(3, 'Ship', 8, '2023-09-21', '2023-09-28', 'Participant in bilateral exercise', 'South China Sea', 6000, NULL),
(1, 'Aircraft', 1, '2024-01-10', '2024-03-10', 'Carrier deck operations and air superiority', 'Arabian Sea', NULL, 50),
(4, 'Submarine', 4, '2021-01-20', '2021-02-20', 'Sub-surface patrol and surveillance', 'Bay of Bengal', 5000, NULL),
(9, 'Ship', 10, '2023-01-16', '2023-01-20', 'Participant in bilateral exercise', 'Arabian Sea', 2000, NULL),
(15, 'Ship', 1, '2024-02-15', '2024-05-15', 'Maritime Security Patrol', 'Persian Gulf', 16000, NULL),
(16, 'Ship', 3, '2023-08-11', '2023-08-21', 'Participant in multilateral exercise', 'East Coast Australia', 12000, NULL),
(2, 'Aircraft', 4, '2021-01-10', '2021-02-10', 'ASW patrol and surveillance', 'Indian Ocean Region', NULL, 18),
(5, 'Aircraft', 5, '2018-08-17', '2018-08-25', 'SAR and relief material transport', 'Kerala', NULL, 40),
(1, 'Submarine', NULL, '2022-05-01', '2022-07-30', 'Deterrent Patrol', 'Undisclosed', 10000, NULL),
(17, 'Ship', 14, '2020-05-10', '2020-05-25', 'Delivery of aid to Mauritius and Comoros', 'South-West Indian Ocean', 7500, NULL),
(1, 'Ship', 15, '2023-07-22', '2023-07-22', 'PASSEX with USN CSG', 'Indian Ocean', 300, NULL),
(18, 'Ship', 17, '2023-03-20', '2023-03-22', 'Participant in bilateral exercise', 'Arabian Sea', 1500, NULL),
(20, 'Ship', 19, '2023-08-22', '2023-08-25', 'Participant in ASW exercise', 'Off Sydney', 12000, NULL);

-- =================================================================
-- Table 20: Family_Details
-- =================================================================
CREATE TABLE Family_Details (
    family_member_id INT PRIMARY KEY AUTO_INCREMENT,
    personnel_id INT,
    full_name VARCHAR(100),
    relationship VARCHAR(50), -- 'Spouse', 'Son', 'Daughter', 'Father', 'Mother'
    date_of_birth DATE,
    contact_number VARCHAR(15),
    address VARCHAR(255),
    is_next_of_kin BOOLEAN,
    is_dependent BOOLEAN,
    occupation VARCHAR(100),
    FOREIGN KEY (personnel_id) REFERENCES Personnel(personnel_id)
);

-- Insert records for Family_Details
INSERT INTO Family_Details (personnel_id, full_name, relationship, date_of_birth, contact_number, address, is_next_of_kin, is_dependent, occupation) VALUES
(1, 'Kala Kumar', 'Spouse', '1965-05-20', '9876543210', 'Navy House, New Delhi', 1, 1, 'Homemaker'),
(3, 'Meera Singh', 'Spouse', '1978-02-10', '9123456780', 'Naval Officers Mess, Mumbai', 1, 1, 'Teacher'),
(3, 'Rohan Singh', 'Son', '2005-10-15', NULL, 'Naval Officers Mess, Mumbai', 0, 1, 'Student'),
(4, 'Amit Sharma', 'Spouse', '1979-09-01', '9123456781', 'Naval Enclave, Visakhapatnam', 1, 1, 'Software Engineer'),
(4, 'Sonia Sharma', 'Daughter', '2008-04-22', NULL, 'Naval Enclave, Visakhapatnam', 0, 1, 'Student'),
(8, 'Lakshmi Kumar', 'Spouse', '1972-01-18', '9123456785', 'Sailors Quarters, Karwar', 1, 1, 'Homemaker'),
(12, 'Rekha Kumar', 'Spouse', '1996-03-30', '9123456789', 'Sailors Quarters, Kochi', 1, 1, 'Nurse'),
(13, 'Ram Singh', 'Father', '1970-11-12', '9123456790', 'Village Rampur, UP', 1, 0, 'Farmer'),
(14, 'Sunita Yadav', 'Mother', '1975-07-08', '9123456791', 'Patna, Bihar', 1, 0, 'Homemaker'),
(5, 'Naina Mehta', 'Spouse', '1986-08-19', '9123456782', 'Naval Apartments, Goa', 1, 1, 'Doctor'),
(6, 'Aditya Rao', 'Spouse', '1988-12-03', '9123456783', 'Naval Base, Kochi', 1, 1, 'Architect'),
(7, 'Priya Gupta', 'Spouse', '1994-05-21', '9123456784', 'Ezhimala, Kerala', 1, 1, 'Research Scholar'),
(9, 'Geeta Patel', 'Spouse', '1974-04-11', '9123456786', 'Naval Quarters, Mumbai', 1, 1, 'Bank Employee'),
(10, 'Sarita Verma', 'Spouse', '1980-02-25', '9123456787', 'Naval Quarters, Visakhapatnam', 1, 1, 'Homemaker'),
(10, 'Rahul Verma', 'Son', '2006-09-14', NULL, 'Naval Quarters, Visakhapatnam', 0, 1, 'Student'),
(11, 'Ramesh Chand', 'Spouse', '1980-10-05', '9123456788', 'Naval Quarters, Port Blair', 1, 1, 'Shopkeeper'),
(15, 'Anjali Jain', 'Spouse', '1979-05-29', '9123456792', 'Naval Enclave, Mumbai', 1, 1, 'Lawyer'),
(17, 'Ishaan Malhotra', 'Son', '2020-02-14', NULL, 'Naval Apartments, Kochi', 0, 1, 'Infant'),
(19, 'Parvati Shankar', 'Mother', '1955-06-10', '9123456796', 'Chennai, Tamil Nadu', 1, 0, 'Retired Teacher'),
(20, 'Suresh Kumar', 'Father', '1958-09-22', '9123456797', 'Jaipur, Rajasthan', 1, 0, 'Retired Govt. Servant');

-- =================================================================
-- Table 21: Asset_Inventory
-- =================================================================
CREATE TABLE Asset_Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    asset_id INT,
    asset_type VARCHAR(50), -- 'Ship', 'Submarine', 'Aircraft', 'Weapon'
    asset_name VARCHAR(100),
    pennant_or_tail_number VARCHAR(20),
    location_id INT, -- Base ID
    location_type VARCHAR(50), -- 'Base', 'Afloat'
    status VARCHAR(50), -- 'Operational', 'Maintenance', 'Storage'
    last_inventory_date DATE,
    remarks TEXT
);

-- Insert records for Asset_Inventory
INSERT INTO Asset_Inventory (asset_id, asset_type, asset_name, pennant_or_tail_number, location_id, location_type, status, last_inventory_date, remarks) VALUES
(1, 'Ship', 'INS Vikramaditya', 'R33', 1, 'Base', 'Maintenance', '2025-07-20', 'Undergoing mid-life refit.'),
(2, 'Ship', 'INS Kolkata', 'D63', 2, 'Base', 'Operational', '2025-07-25', 'Ready for deployment.'),
(3, 'Ship', 'INS Kochi', 'D64', 2, 'Afloat', 'Operational', '2025-07-30', 'On patrol in Arabian Sea.'),
(1, 'Aircraft', 'MiG-29K', 'INAS303-01', 7, 'Base', 'Operational', '2025-07-28', 'Flight ready.'),
(4, 'Aircraft', 'P-8I Neptune', 'INAS312-02', 6, 'Base', 'Maintenance', '2025-07-22', 'Scheduled phase check.'),
(1, 'Submarine', 'INS Arihant', 'S71', 3, 'Afloat', 'Operational', '2025-07-15', 'On deterrent patrol.'),
(4, 'Submarine', 'INS Kalvari', 'S21', 2, 'Base', 'Operational', '2025-07-26', 'Preparing for work-up.'),
(1, 'Weapon', 'BrahMos', NULL, 16, 'Base', 'Storage', '2025-06-30', 'Stored in climate-controlled bunker.'),
(2, 'Weapon', 'Barak 8', NULL, 2, 'Afloat', 'Operational', '2025-07-25', 'Loaded on INS Kolkata.'),
(8, 'Ship', 'INS Saryu', 'P62', 4, 'Afloat', 'Operational', '2025-07-29', 'Patrolling EEZ.'),
(10, 'Ship', 'INS Kavaratti', 'K43', 3, 'Base', 'Operational', '2025-07-24', 'Ready for deployment.'),
(6, 'Aircraft', 'ALH Dhruv', 'INAS322-02', 4, 'Base', 'Operational', '2025-07-28', 'SAR standby.'),
(8, 'Aircraft', 'Westland Sea King', 'INAS330-02', 1, 'Base', 'Storage', '2025-07-20', 'Preserved for future use.'),
(5, 'Submarine', 'INS Khanderi', 'S22', 2, 'Afloat', 'Operational', '2025-07-28', 'On patrol.'),
(10, 'Submarine', 'INS Sindhughosh', 'S55', 2, 'Maintenance', 'Operational', '2025-07-18', 'Undergoing minor repairs.'),
(3, 'Weapon', 'Varunastra', NULL, 3, 'Afloat', 'Operational', '2025-07-24', 'Loaded on INS Sahyadri.'),
(4, 'Weapon', 'AK-630', NULL, 1, 'Afloat', 'Operational', '2025-07-30', 'Fitted on INS Vikramaditya.'),
(16, 'Ship', 'INS Vikrant', 'R33', 1, 'Base', 'Operational', '2025-07-25', 'Flight deck certification in progress.'),
(12, 'Aircraft', 'P-8I Neptune', 'INAS316-02', 7, 'Afloat', 'Operational', '2025-07-29', 'Deployed for mission.'),
(11, 'Submarine', 'INS Sindhudhvaj', 'S56', 2, 'Base', 'Decommissioned', '2022-07-16', 'Awaiting disposal.');

-- =================================================================
-- Table 22: Hydrographic_Data
-- =================================================================
CREATE TABLE Hydrographic_Data (
    survey_id INT PRIMARY KEY AUTO_INCREMENT,
    survey_ship_id INT,
    survey_date DATE,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    depth_meters DECIMAL(10, 2),
    seabed_topography VARCHAR(100),
    salinity_ppt DECIMAL(5, 2),
    water_temperature_celsius DECIMAL(5, 2),
    tidal_data VARCHAR(255),
    chart_number VARCHAR(20)
);

-- Insert records for Hydrographic_Data
INSERT INTO Hydrographic_Data (survey_ship_id, survey_date, latitude, longitude, depth_meters, seabed_topography, salinity_ppt, water_temperature_celsius, tidal_data, chart_number) VALUES
(NULL, '2024-02-15', 18.90111111, 72.81222222, 15.50, 'Silty Clay', 35.2, 28.5, 'High Tide: 4.5m, Low Tide: 1.2m', 'IN2022'),
(NULL, '2024-02-16', 17.68681944, 83.21847222, 25.00, 'Sand', 34.8, 29.1, 'High Tide: 1.8m, Low Tide: 0.5m', 'IN3004'),
(NULL, '2024-03-10', 9.96666667, 76.26666667, 12.80, 'Mud', 35.0, 29.5, 'High Tide: 1.1m, Low Tide: 0.3m', 'IN2004'),
(NULL, '2024-03-25', 14.86000000, 74.08000000, 35.20, 'Rocky', 35.5, 28.9, 'High Tide: 2.1m, Low Tide: 0.6m', 'IN2016'),
(NULL, '2024-04-05', 11.62340000, 92.72648600, 55.00, 'Coral Reef', 34.5, 30.1, 'High Tide: 2.3m, Low Tide: 0.8m', 'IN4016'),
(NULL, '2024-04-20', 22.46666667, 69.06666667, 18.70, 'Sandstone', 36.1, 27.8, 'High Tide: 3.5m, Low Tide: 1.0m', 'IN2008'),
(NULL, '2024-05-01', 12.01666667, 75.21666667, 22.40, 'Laterite', 35.3, 29.8, 'High Tide: 1.5m, Low Tide: 0.4m', 'IN2020'),
(NULL, '2024-05-15', 18.92200000, 72.83350000, 14.20, 'Silt', 35.2, 28.6, 'See Tide Table 2024', 'IN2022'),
(NULL, '2024-06-01', 17.70000000, 83.29000000, 30.10, 'Sandy Mud', 34.9, 29.3, 'See Tide Table 2024', 'IN3004'),
(NULL, '2024-06-12', 9.93123280, 76.26730410, 13.50, 'Mud', 35.1, 29.6, 'See Tide Table 2024', 'IN2004'),
(NULL, '2023-11-10', 15.38020000, 73.83110000, 8.50, 'Silty Sand', 35.4, 28.2, 'See Tide Table 2023', 'IN2019'),
(NULL, '2023-11-25', 13.08270000, 80.27070000, 10.20, 'Clay', 34.7, 29.0, 'See Tide Table 2023', 'IN3001'),
(NULL, '2023-12-05', 21.64130000, 69.60830000, 11.80, 'Sand', 36.2, 27.5, 'See Tide Table 2023', 'IN2010'),
(NULL, '2023-12-20', 6.98330000, 93.91670000, 75.00, 'Volcanic Rock', 34.4, 30.5, 'See Tide Table 2023', 'IN4701'),
(NULL, '2024-01-10', 18.95000000, 72.83000000, 16.00, 'Mud', 35.2, 28.4, 'See Tide Table 2024', 'IN2022'),
(NULL, '2024-01-25', 17.69830000, 83.21850000, 28.30, 'Sand', 34.8, 29.0, 'See Tide Table 2024', 'IN3004'),
(NULL, '2024-02-05', 9.96500000, 76.25000000, 11.90, 'Silty Clay', 35.0, 29.4, 'See Tide Table 2024', 'IN2004'),
(NULL, '2024-02-20', 14.81000000, 74.12500000, 33.00, 'Rocky Outcrop', 35.5, 28.8, 'See Tide Table 2024', 'IN2016'),
(NULL, '2024-03-15', 11.64110000, 92.71560000, 48.00, 'Coral Debris', 34.5, 30.2, 'See Tide Table 2024', 'IN4016'),
(NULL, '2024-04-01', 22.53940000, 88.33470000, 9.80, 'River Silt', 15.2, 30.0, 'Riverine Tides', 'IN101');

-- =================================================================
-- Table 23: Incident_Reports
-- =================================================================
CREATE TABLE Incident_Reports (
    incident_id INT PRIMARY KEY AUTO_INCREMENT,
    incident_datetime DATETIME,
    asset_id INT,
    asset_type VARCHAR(50),
    location VARCHAR(255),
    incident_type VARCHAR(50), -- 'Fire', 'Collision', 'Grounding', 'Equipment Failure'
    severity VARCHAR(20), -- 'Minor', 'Moderate', 'Major', 'Catastrophic'
    personnel_involved INT,
    casualties INT,
    damage_report TEXT,
    action_taken TEXT
);

-- Insert records for Incident_Reports
INSERT INTO Incident_Reports (incident_datetime, asset_id, asset_type, location, incident_type, severity, personnel_involved, casualties, damage_report, action_taken) VALUES
('2024-02-26 10:30:00', 63, 'Submarine', 'Mumbai Harbour', 'Fire', 'Major', 7, 2, 'Fire in battery compartment. Significant damage to electrical systems.', 'Submarine surfaced, fire extinguished by crew. Board of Inquiry ordered.'),
('2023-10-05 14:00:00', 55, 'Ship', 'Off Visakhapatnam', 'Collision', 'Moderate', 250, 0, 'Collision with merchant vessel in dense fog. Damage to bow section.', 'Vessel escorted back to port for repairs. Investigation initiated.'),
('2024-05-12 03:15:00', 19, 'Ship', 'Palk Bay', 'Grounding', 'Minor', 120, 0, 'Vessel ran aground on uncharted shoal. Minor damage to hull.', 'Vessel refloated at high tide. Hydrographic survey ordered.'),
('2025-01-18 11:00:00', 7, 'Aircraft', 'Goa Airspace', 'Engine Failure', 'Major', 2, 0, 'Single engine failure during training sortie. Aircraft landed safely.', 'Engine replaced. Fleet-wide check ordered.'),
('2023-08-09 22:45:00', 17, 'Ship', 'Arabian Sea', 'Flooding', 'Moderate', 180, 0, 'Flooding in engine room due to pipe rupture.', 'Damage control teams contained flooding. Ship returned to port for repairs.'),
('2024-11-20 09:00:00', 4, 'Weapon', 'Firing Range', 'Misfire', 'Minor', 10, 0, '76mm shell misfired during practice.', 'Gun cleared safely. Ammunition batch recalled for inspection.'),
('2025-03-03 16:20:00', 5, 'Aircraft', 'INS Hansa', 'Landing Gear Malfunction', 'Minor', 1, 0, 'Nose wheel did not deploy. Pilot executed a safe belly landing.', 'Minor airframe damage. Investigation underway.'),
('2023-09-14 19:00:00', 11, 'Ship', 'Bay of Bengal', 'Man Overboard', 'Major', 300, 1, 'Sailor fell overboard during rough weather.', 'Extensive search conducted but sailor could not be recovered.'),
('2024-07-30 08:00:00', 10, 'Ship', 'Dry Dock, Visakhapatnam', 'Crane Accident', 'Moderate', 20, 1, 'Crane collapsed during ammunition loading.', 'Operations halted. Safety review initiated.'),
('2025-02-10 13:00:00', 6, 'Submarine', 'At Sea', 'Inertial Navigation System Failure', 'Major', 60, 0, 'Primary INS failed. Submarine surfaced and navigated via GPS.', 'Submarine returned to base. System sent for overhaul.'),
('2023-12-01 17:50:00', 1, 'Ship', 'Off Karwar', 'Helicopter Crash', 'Catastrophic', 4, 2, 'Chetak helicopter crashed during landing on deck.', 'Search and rescue launched. Board of Inquiry convened.'),
('2024-08-15 12:00:00', 2, 'Aircraft', 'Arakkonam', 'Tyre Burst on Takeoff', 'Minor', 2, 0, 'P-8I tyre burst on takeoff roll. Aborted takeoff.', 'Aircraft safe. Runway cleared.'),
('2025-04-01 06:30:00', 18, 'Ship', 'South China Sea', 'Aggressive Maneuvering by Foreign Vessel', 'Minor', 200, 0, 'Foreign coast guard vessel performed unsafe maneuvers.', 'Diplomatic protest lodged. Evasive action taken.'),
('2023-11-11 21:00:00', 14, 'Submarine', 'Indian Ocean', 'Snorkel Damage', 'Moderate', 55, 0, 'Snorkel mast damaged by floating container.', 'Repairs undertaken at sea. Patrol continued.'),
('2024-09-22 10:45:00', 3, 'Weapon', 'At Sea', 'Torpedo Test Failure', 'Minor', 15, 0, 'Test torpedo failed to acquire target.', 'Torpedo recovered for analysis.'),
('2025-06-07 15:00:00', 9, 'Aircraft', 'Kochi', 'Bird Hit', 'Moderate', 2, 0, 'Heron UAV engine ingested a bird. Returned to base.', 'Engine inspection and repair.'),
('2024-01-26 11:30:00', 8, 'Ship', 'Off Chennai', 'Steering Gear Failure', 'Moderate', 150, 0, 'Ship lost steering control temporarily.', 'Switched to emergency steering. Repairs completed.'),
('2023-10-19 18:00:00', 13, 'Ship', 'Malacca Strait', 'Piracy Attempt', 'Minor', 180, 0, 'Attempted boarding by pirates.', 'Alert crew and warning shots fired, pirates fled.'),
('2024-12-25 09:20:00', 20, 'Ship', 'INS Adyar', 'Minor Fire', 'Minor', 5, 0, 'Fire in galley due to electrical short circuit.', 'Fire extinguished quickly. Minor damage.'),
('2025-07-14 14:00:00', 1, 'Weapon', 'At Sea', 'CIWS Malfunction', 'Minor', 8, 0, 'AK-630 jammed during live firing.', 'Weapon cleared and rectified by technicians.');

-- =================================================================
-- Table 24: Command_Structure
-- =================================================================
CREATE TABLE Command_Structure (
    command_id INT PRIMARY KEY AUTO_INCREMENT,
    command_name VARCHAR(100),
    command_level VARCHAR(50), -- 'Operational Command', 'Fleet', 'Flotilla'
    commander_id INT, -- links to Personnel
    hq_base_id INT, -- links to Bases
    area_of_responsibility VARCHAR(255),
    parent_command_id INT,
    establishment_date DATE,
    mission_statement TEXT,
    is_active BOOLEAN
);

-- Insert records for Command_Structure
INSERT INTO Command_Structure (command_name, command_level, commander_id, hq_base_id, area_of_responsibility, parent_command_id, establishment_date, mission_statement, is_active) VALUES
('Chief of the Naval Staff', 'Apex', 1, NULL, 'Entire Indian Navy', NULL, '1950-01-26', 'To lead the Indian Navy.', 1),
('Western Naval Command', 'Operational Command', NULL, 1, 'Arabian Sea and Western Seaboard', 1, '1968-03-01', 'To safeguard India''s maritime interests on the western seaboard.', 1),
('Eastern Naval Command', 'Operational Command', NULL, 3, 'Bay of Bengal and Eastern Seaboard', 1, '1968-03-01', 'To safeguard India''s maritime interests on the eastern seaboard.', 1),
('Southern Naval Command', 'Operational Command', NULL, 4, 'Southern Seaboard and Training', 1, '1971-01-01', 'To oversee all training activities of the Indian Navy.', 1),
('Andaman and Nicobar Command', 'Tri-Service Command', NULL, 14, 'Andaman & Nicobar Islands', 1, '2001-10-08', 'To defend the A&N Islands and control the Malacca Strait.', 1),
('Western Fleet', 'Fleet', NULL, 1, 'Western Seaboard', 2, '1971-11-01', 'The sword arm of the Western Naval Command.', 1),
('Eastern Fleet', 'Fleet', NULL, 3, 'Eastern Seaboard', 3, '1971-11-01', 'The sword arm of the Eastern Naval Command.', 1),
('Submarine Command (West)', 'Flotilla', NULL, 2, 'Submarine operations in the West', 2, '1997-04-01', 'To command all submarines under WNC.', 1),
('Submarine Command (East)', 'Flotilla', NULL, 3, 'Submarine operations in the East', 3, '1997-04-01', 'To command all submarines under ENC.', 1),
('Naval Air Command (West)', 'Air Command', NULL, 7, 'Air operations in the West', 2, '1987-01-01', 'To command all air assets under WNC.', 1),
('Naval Air Command (East)', 'Air Command', NULL, 5, 'Air operations in the East', 3, '1987-01-01', 'To command all air assets under ENC.', 1),
('MARCOS Command (West)', 'Special Forces', NULL, 2, 'Special operations in the West', 2, '1987-02-14', 'To conduct maritime special operations.', 1),
('MARCOS Command (East)', 'Special Forces', NULL, 3, 'Special operations in the East', 3, '1987-02-14', 'To conduct maritime special operations.', 1),
('First Training Squadron', 'Training Squadron', NULL, 4, 'Sea training for officer cadets', 4, '1984-01-01', 'To provide basic sea training.', 1),
('Karwar Naval Area', 'Naval Area', NULL, 2, 'Defence of Karwar and its approaches', 2, '2005-05-31', 'To provide local naval defence.', 1),
('Goa Naval Area', 'Naval Area', NULL, 7, 'Defence of Goa and its approaches', 2, '1961-12-19', 'To provide local naval defence.', 1),
('Gujarat Naval Area', 'Naval Area', NULL, 11, 'Defence of Gujarat coast', 2, '2002-01-01', 'To provide local naval defence.', 1),
('Tamil Nadu & Puducherry Naval Area', 'Naval Area', NULL, 19, 'Defence of TN & Puducherry coast', 3, '1985-01-01', 'To provide local naval defence.', 1),
('Naval Officer-in-Charge (West Bengal)', 'Naval Area', NULL, 12, 'Defence of West Bengal coast', 3, '1974-07-05', 'To provide local naval defence.', 1),
('Flag Officer Sea Training', 'Training Command', NULL, 4, 'Operational sea training for all ships', 4, '1978-01-01', 'To ensure all units are combat-ready.', 1);

-- =================================================================
-- Table 25: Sensor_Data
-- =================================================================
CREATE TABLE Sensor_Data (
    sensor_log_id INT PRIMARY KEY AUTO_INCREMENT,
    asset_id INT,
    asset_type VARCHAR(50),
    sensor_type VARCHAR(50), -- 'Radar', 'Sonar', 'ESM', 'EO/IR'
    detection_timestamp DATETIME,
    contact_id VARCHAR(50),
    bearing DECIMAL(5, 2),
    range_nm DECIMAL(6, 2),
    course DECIMAL(5, 2),
    speed_kts DECIMAL(5, 2),
    classification VARCHAR(100) -- 'Friendly', 'Neutral', 'Hostile', 'Unknown'
);

-- Insert records for Sensor_Data
INSERT INTO Sensor_Data (asset_id, asset_type, sensor_type, detection_timestamp, contact_id, bearing, range_nm, course, speed_kts, classification) VALUES
(2, 'Ship', 'Radar', '2025-07-30 14:00:00', 'UNKN-001', 180.00, 50.50, 360.00, 15.00, 'Unknown'),
(3, 'Ship', 'Sonar', '2025-07-30 14:05:00', 'SUB-001', 270.00, 15.20, 90.00, 8.00, 'Suspected Submarine'),
(1, 'Aircraft', 'ESM', '2025-07-30 14:10:00', 'RADAR-X', 90.00, 150.00, NULL, NULL, 'Hostile Fire Control Radar'),
(4, 'Submarine', 'Sonar', '2025-07-30 14:12:00', 'BIO-001', 310.00, 5.00, 180.00, 3.00, 'Biological (Whale)'),
(7, 'Ship', 'Radar', '2025-07-30 14:15:00', 'MV-CMA-CGM', 45.00, 20.00, 225.00, 18.00, 'Neutral (Merchant Vessel)'),
(1, 'Ship', 'EO/IR', '2025-07-30 14:18:00', 'DHOW-001', 120.00, 8.00, 300.00, 10.00, 'Unknown (Fishing Dhow)'),
(3, 'Aircraft', 'Radar', '2025-07-30 14:20:00', 'AIR-001', 200.00, 80.00, 20.00, 450.00, 'Unknown Aircraft'),
(5, 'Submarine', 'Sonar', '2025-07-30 14:25:00', 'TORP-WARN', 10.00, 4.00, 190.00, 40.00, 'Hostile (Torpedo in water)'),
(2, 'Ship', 'ESM', '2025-07-30 14:28:00', 'RADAR-Y', 250.00, 120.00, NULL, NULL, 'Friendly (Allied Warship Radar)'),
(8, 'Ship', 'Radar', '2025-07-30 14:30:00', 'FISHING-FLT', 90.00, 12.50, 270.00, 5.00, 'Neutral (Fishing Fleet)'),
(1, 'Aircraft', 'Radar', '2025-07-30 14:35:00', 'AIR-002', 330.00, 100.00, 150.00, 500.00, 'Friendly (IAF Fighter)'),
(4, 'Submarine', 'Sonar', '2025-07-30 14:40:00', 'SURF-001', 180.00, 25.00, 360.00, 12.00, 'Neutral (Surface Ship)'),
(16, 'Ship', 'Radar', '2025-07-30 14:45:00', 'HEL-001', 270.00, 10.00, 90.00, 120.00, 'Friendly (Own Helicopter)'),
(10, 'Ship', 'Sonar', '2025-07-30 14:50:00', 'NOISE-SRC', 60.00, 18.00, NULL, NULL, 'Unknown (Ambient Noise Source)'),
(2, 'Ship', 'Radar', '2025-07-30 14:55:00', 'UNKN-001', 185.00, 45.00, 358.00, 15.00, 'Unknown'),
(3, 'Ship', 'Sonar', '2025-07-30 15:00:00', 'SUB-001', 275.00, 12.00, 92.00, 8.00, 'Suspected Submarine'),
(1, 'Aircraft', 'EO/IR', '2025-07-30 15:05:00', 'SMALL-BOAT', 150.00, 15.00, 330.00, 25.00, 'Unknown (Fast Boat)'),
(7, 'Ship', 'Radar', '2025-07-30 15:10:00', 'FRIGATE-F40', 190.00, 30.00, 10.00, 20.00, 'Friendly (INS Talwar)'),
(5, 'Submarine', 'Sonar', '2025-07-30 15:15:00', 'BOTTOM-BOUNCE', 0.00, 0.00, NULL, NULL, 'Self-Noise'),
(3, 'Aircraft', 'Radar', '2025-07-30 15:20:00', 'AIR-001', 210.00, 70.00, 25.00, 450.00, 'Unknown Aircraft');
