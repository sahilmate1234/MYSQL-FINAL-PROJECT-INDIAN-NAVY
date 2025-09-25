-- PROJECT SUBMISSION: PHASE 4
-- DATABASE: indian_navy
USE indian_navy;
-- ====================================================================================================
-- PRELIMINARY SETUP: CREATE AUDIT TABLES & DUMMY USERS FOR DCL
-- These tables will be used by triggers to log changes.
-- ====================================================================================================

-- Audit table for Personnel changes
CREATE TABLE IF NOT EXISTS Personnel_Audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    personnel_id INT,
    changed_column VARCHAR(100),
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    change_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Log table for Ship status changes
CREATE TABLE IF NOT EXISTS Ship_Status_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    ship_id INT,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    log_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100)
);

-- Log table for low weapon inventory alerts
CREATE TABLE IF NOT EXISTS Weapon_Reorder_Alerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    weapon_id INT,
    weapon_name VARCHAR(100),
    inventory_count INT,
    alert_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create dummy users for DCL commands
CREATE USER IF NOT EXISTS 'hr_officer'@'localhost' IDENTIFIED BY 'password123';
CREATE USER IF NOT EXISTS 'logistics_officer'@'localhost' IDENTIFIED BY 'password123';
CREATE USER IF NOT EXISTS 'ops_officer'@'localhost' IDENTIFIED BY 'password123';

-- ====================================================================================================
-- TABLE 1: Personnel
-- ====================================================================================================

-- -------------------------------
-- VIEWS on Personnel
-- -------------------------------
-- 1. View to show only senior officers (Captain and above)
CREATE OR REPLACE VIEW Senior_Officers_View AS
SELECT personnel_id, service_number, post, full_name, date_of_commission
FROM Personnel
WHERE post IN ('Admiral', 'Vice Admiral', 'Captain');

-- 2. View to display personnel with O+ blood group
CREATE OR REPLACE VIEW O_Positive_Personnel_View AS
SELECT full_name, post, contact_number, email_address
FROM Personnel
WHERE blood_group = 'O+';

-- 3. Complex View: Personnel details with their current posting base name
CREATE OR REPLACE VIEW Personnel_Posting_Details_View AS
SELECT p.full_name, p.post, b.base_name, b.location_city
FROM Personnel p
JOIN Bases b ON p.current_posting_id = b.base_id;

-- -------------------------------
-- CURSORS on Personnel
-- -------------------------------
-- 4. Cursor to fetch and display the names of all Admirals
DELIMITER $$
CREATE PROCEDURE ListAllAdmirals()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE admiral_name VARCHAR(100);
    DECLARE admiral_cursor CURSOR FOR SELECT full_name FROM Personnel WHERE post LIKE '%Admiral%';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN admiral_cursor;
    admiral_loop: LOOP
        FETCH admiral_cursor INTO admiral_name;
        IF done THEN
            LEAVE admiral_loop;
        END IF;
        SELECT CONCAT('Admiral Name: ', admiral_name) AS Message;
    END LOOP;
    CLOSE admiral_cursor;
END$$
DELIMITER ;
-- CALL ListAllAdmirals();

-- 5. Cursor to iterate through personnel commissioned before 1990
DELIMITER $$
CREATE PROCEDURE ListVeteranPersonnel()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE p_name VARCHAR(100);
    DECLARE p_commission_date DATE;
    DECLARE veteran_cursor CURSOR FOR SELECT full_name, date_of_commission FROM Personnel WHERE YEAR(date_of_commission) < 1990;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN veteran_cursor;
    read_loop: LOOP
        FETCH veteran_cursor INTO p_name, p_commission_date;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT(p_name, ' was commissioned on ', p_commission_date) AS Veteran_Info;
    END LOOP;
    CLOSE veteran_cursor;
END$$
DELIMITER ;
-- CALL ListVeteranPersonnel();

-- -------------------------------
-- STORED PROCEDURES for Personnel
-- -------------------------------
-- 6. Procedure to get personnel details by service number
DELIMITER $$
CREATE PROCEDURE GetPersonnelByServiceNumber(IN s_num VARCHAR(20))
BEGIN
    SELECT * FROM Personnel WHERE service_number = s_num;
END$$
DELIMITER ;
-- CALL GetPersonnelByServiceNumber('IN001');

-- 7. Procedure to update a person's contact number and email
DELIMITER $$
CREATE PROCEDURE UpdatePersonnelContact(IN p_id INT, IN new_contact VARCHAR(15), IN new_email VARCHAR(100))
BEGIN
    UPDATE Personnel
    SET contact_number = new_contact, email_address = new_email
    WHERE personnel_id = p_id;
    SELECT 'Contact details updated successfully.' AS Status;
END$$
DELIMITER ;
-- CALL UpdatePersonnelContact(5, '9123456799', 'arjun.mehta.new@navy.mil');

-- 8. Procedure to count personnel by a specific post
DELIMITER $$
CREATE PROCEDURE CountPersonnelByPost(IN p_post VARCHAR(50), OUT p_count INT)
BEGIN
    SELECT COUNT(*) INTO p_count FROM Personnel WHERE post = p_post;
END$$
DELIMITER ;
-- CALL CountPersonnelByPost('Captain', @captain_count);
-- SELECT @captain_count;

-- -------------------------------
-- WINDOW FUNCTIONS on Personnel
-- -------------------------------
-- 9. Rank personnel by date of birth (oldest first)
SELECT full_name, date_of_birth, post,
       RANK() OVER (ORDER BY date_of_birth ASC) as age_rank
FROM Personnel;

-- 10. Get the next and previous personnel based on commission date
SELECT full_name, date_of_commission,
       LAG(full_name, 1) OVER (ORDER BY date_of_commission) as previous_commissioned,
       LEAD(full_name, 1) OVER (ORDER BY date_of_commission) as next_commissioned
FROM Personnel;

-- 11. Assign personnel to 4 groups (quartiles) based on their commission date
SELECT full_name, date_of_commission,
       NTILE(4) OVER (ORDER BY date_of_commission) as commission_quartile
FROM Personnel;

-- 12. Calculate the running total of personnel commissioned over the years
SELECT full_name, date_of_commission,
       COUNT(personnel_id) OVER (ORDER BY date_of_commission) as running_total_personnel
FROM Personnel;

-- -------------------------------
-- DCL & TCL on Personnel
-- -------------------------------
-- 13. DCL: Grant select access to HR officer
GRANT SELECT(personnel_id, full_name, post, email_address) ON indian_navy.Personnel TO 'hr_officer'@'localhost';

-- 14. DCL: Revoke access from HR officer
REVOKE SELECT ON indian_navy.Personnel FROM 'hr_officer'@'localhost';

-- 15. TCL: A transaction to update two personnel's postings and commit
START TRANSACTION;
UPDATE Personnel SET current_posting_id = 1 WHERE personnel_id = 7;
UPDATE Personnel SET current_posting_id = 2 WHERE personnel_id = 8;
COMMIT;

-- 16. TCL: A transaction with a rollback
START TRANSACTION;
UPDATE Personnel SET post = 'Fleet Commander' WHERE personnel_id = 3;
-- Let's assume this was a mistake
ROLLBACK;

-- -------------------------------
-- TRIGGERS on Personnel
-- -------------------------------
-- 17. Trigger to prevent deleting the Chief of Navy (Admiral)
DELIMITER $$
CREATE TRIGGER Before_Personnel_Delete
BEFORE DELETE ON Personnel
FOR EACH ROW
BEGIN
    IF OLD.post = 'Admiral' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete the Chief of the Naval Staff.';
    END IF;
END$$
DELIMITER ;

-- 18. Trigger to audit changes to a person's post
DELIMITER $$
CREATE TRIGGER After_Personnel_Post_Update
AFTER UPDATE ON Personnel
FOR EACH ROW
BEGIN
    IF OLD.post <> NEW.post THEN
        INSERT INTO Personnel_Audit(personnel_id, changed_column, old_value, new_value)
        VALUES (OLD.personnel_id, 'post', OLD.post, NEW.post);
    END IF;
END$$
DELIMITER ;

-- 19. Trigger to standardize email addresses to lowercase on insert
DELIMITER $$
CREATE TRIGGER Before_Personnel_Insert_Lowercase_Email
BEFORE INSERT ON Personnel
FOR EACH ROW
BEGIN
    SET NEW.email_address = LOWER(NEW.email_address);
END$$
DELIMITER ;

-- 20. Stored procedure to add a new person, which will fire the `Before_Personnel_Insert_Lowercase_Email` trigger
DELIMITER $$
CREATE PROCEDURE AddNewPersonnel(
    IN s_num VARCHAR(20), IN p_post VARCHAR(50), IN f_name VARCHAR(100), IN dob DATE, 
    IN doc DATE, IN b_group VARCHAR(5), IN contact VARCHAR(15), IN email VARCHAR(100), IN posting_id INT
)
BEGIN
    INSERT INTO Personnel (service_number, post, full_name, date_of_birth, date_of_commission, blood_group, contact_number, email_address, current_posting_id)
    VALUES (s_num, p_post, f_name, dob, doc, b_group, contact, email, posting_id);
END$$
DELIMITER ;
-- CALL AddNewPersonnel('IN021', 'Seaman II', 'Test Person', '2002-01-01', '2025-01-01', 'A+', '9999999999', 'Test.Person@NAVY.MIL', 10);
-- SELECT * FROM Personnel WHERE service_number = 'IN021'; -- verify email is lowercase


-- ====================================================================================================
-- TABLE 2: Ships
-- ====================================================================================================

-- -------------------------------
-- VIEWS on Ships
-- -------------------------------
-- 1. View of all active destroyers and frigates
CREATE OR REPLACE VIEW Active_Combatants_View AS
SELECT ship_name, pennant_number, ship_class, commission_date
FROM Ships
WHERE current_status = 'Active' AND ship_type IN ('Destroyer', 'Frigate');

-- 2. View showing decommissioned ships
CREATE OR REPLACE VIEW Decommissioned_Ships_View AS
SELECT ship_name, ship_class, commission_date, decommission_date
FROM Ships
WHERE current_status = 'Decommissioned';

-- 3. Complex View: Ships with their Commanding Officer's name and post
CREATE OR REPLACE VIEW Ship_CO_Details_View AS
SELECT s.ship_name, s.pennant_number, p.full_name AS commanding_officer, p.post
FROM Ships s
LEFT JOIN Personnel p ON s.commanding_officer_id = p.personnel_id;

-- -------------------------------
-- CURSORS on Ships
-- -------------------------------
-- 4. Cursor to list all ships based in Mumbai
DELIMITER $$
CREATE PROCEDURE ListMumbaiBasedShips()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE ship_name_var VARCHAR(100);
    DECLARE home_port_id_var INT;
    DECLARE base_name_var VARCHAR(100);

    -- Get base_id for Mumbai
    SELECT base_id INTO home_port_id_var FROM Bases WHERE location_city = 'Mumbai' LIMIT 1;
    
    DECLARE ship_cursor CURSOR FOR SELECT ship_name FROM Ships WHERE home_port_id = home_port_id_var;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN ship_cursor;
    ship_loop: LOOP
        FETCH ship_cursor INTO ship_name_var;
        IF done THEN
            LEAVE ship_loop;
        END IF;
        SELECT CONCAT('Ship based in Mumbai: ', ship_name_var) AS Message;
    END LOOP;
    CLOSE ship_cursor;
END$$
DELIMITER ;
-- CALL ListMumbaiBasedShips();

-- 5. Cursor to iterate through ships commissioned in the 21st century
DELIMITER $$
CREATE PROCEDURE ListModernShips()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE s_name VARCHAR(100);
    DECLARE s_comm_date DATE;
    DECLARE modern_ship_cursor CURSOR FOR SELECT ship_name, commission_date FROM Ships WHERE YEAR(commission_date) >= 2000;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN modern_ship_cursor;
    read_loop: LOOP
        FETCH modern_ship_cursor INTO s_name, s_comm_date;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT(s_name, ' (Commissioned: ', s_comm_date, ')') AS Modern_Ship_Info;
    END LOOP;
    CLOSE modern_ship_cursor;
END$$
DELIMITER ;
-- CALL ListModernShips();

-- -------------------------------
-- STORED PROCEDURES for Ships
-- -------------------------------
-- 6. Procedure to get ship details by pennant number
DELIMITER $$
CREATE PROCEDURE GetShipByPennant(IN p_num VARCHAR(10))
BEGIN
    SELECT * FROM Ships WHERE pennant_number = p_num;
END$$
DELIMITER ;
-- CALL GetShipByPennant('D66');

-- 7. Procedure to assign a new Commanding Officer to a ship
DELIMITER $$
CREATE PROCEDURE AssignShipCO(IN s_id INT, IN new_co_id INT)
BEGIN
    UPDATE Ships SET commanding_officer_id = new_co_id WHERE ship_id = s_id;
    SELECT 'New CO assigned.' AS Result;
END$$
DELIMITER ;
-- CALL AssignShipCO(1, 15); -- Assign Alok Jain to INS Vikramaditya

-- 8. Procedure to decommission a ship
DELIMITER $$
CREATE PROCEDURE DecommissionShip(IN s_id INT, IN decomm_date DATE)
BEGIN
    UPDATE Ships
    SET current_status = 'Decommissioned', decommission_date = decomm_date, commanding_officer_id = NULL
    WHERE ship_id = s_id;
    SELECT 'Ship has been decommissioned.' as Status;
END$$
DELIMITER ;
-- CALL DecommissionShip(17, '2025-10-31'); -- Decommission INS Ranvijay

-- -------------------------------
-- WINDOW FUNCTIONS on Ships
-- -------------------------------
-- 9. Rank ships within each class by their commission date
SELECT ship_name, ship_class, commission_date,
       RANK() OVER (PARTITION BY ship_class ORDER BY commission_date ASC) as rank_in_class
FROM Ships;

-- 10. Find the number of years between the commissioning of a ship and the next ship in its class
SELECT ship_name, ship_class, commission_date,
       LEAD(commission_date, 1) OVER (PARTITION BY ship_class ORDER BY commission_date) as next_ship_commission_date,
       TIMESTAMPDIFF(YEAR, commission_date, LEAD(commission_date, 1) OVER (PARTITION BY ship_class ORDER BY commission_date)) as years_until_next
FROM Ships;

-- 11. Calculate the total number of active ships per home port
SELECT DISTINCT home_port_id,
       COUNT(ship_id) OVER (PARTITION BY home_port_id) as active_ships_in_port
FROM Ships
WHERE current_status = 'Active';

-- 12. Dense rank of ships based on commission date (newest first)
SELECT ship_name, commission_date,
       DENSE_RANK() OVER (ORDER BY commission_date DESC) as modernity_rank
FROM Ships;

-- -------------------------------
-- DCL & TCL on Ships
-- -------------------------------
-- 13. DCL: Grant update on ship status to ops_officer
GRANT UPDATE(current_status) ON indian_navy.Ships TO 'ops_officer'@'localhost';

-- 14. DCL: Revoke the update privilege
REVOKE UPDATE ON indian_navy.Ships FROM 'ops_officer'@'localhost';

-- 15. TCL: Use a savepoint in a multi-step transaction
START TRANSACTION;
-- Update status for maintenance
UPDATE Ships SET current_status = 'In-Refit' WHERE ship_id = 5;
SAVEPOINT before_second_update;
-- Update status for another ship
UPDATE Ships SET current_status = 'In-Refit' WHERE ship_id = 6;
-- Decide to rollback the second update
ROLLBACK TO SAVEPOINT before_second_update;
COMMIT; -- Commits only the first update

-- 16. TCL: A simple transaction to update a home port
START TRANSACTION;
UPDATE Ships SET home_port_id = 3 WHERE ship_id = 15;
COMMIT;

-- -------------------------------
-- TRIGGERS on Ships
-- -------------------------------
-- 17. Trigger to log any change in a ship's status
DELIMITER $$
CREATE TRIGGER After_Ship_Status_Update
AFTER UPDATE ON Ships
FOR EACH ROW
BEGIN
    IF OLD.current_status <> NEW.current_status THEN
        INSERT INTO Ship_Status_Log(ship_id, old_status, new_status, changed_by)
        VALUES (OLD.ship_id, OLD.current_status, NEW.current_status, USER());
    END IF;
END$$
DELIMITER ;
-- UPDATE Ships SET current_status = 'In-Refit' where ship_id = 2; -- This will fire the trigger.
-- SELECT * from Ship_Status_Log;

-- 18. Trigger to prevent a decommissioned ship's record from being updated
DELIMITER $$
CREATE TRIGGER Before_Decommissioned_Ship_Update
BEFORE UPDATE ON Ships
FOR EACH ROW
BEGIN
    IF OLD.current_status = 'Decommissioned' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot update the record of a decommissioned ship.';
    END IF;
END$$
DELIMITER ;

-- 19. Trigger to set the commission date to the current date if it's not provided
DELIMITER $$
CREATE TRIGGER Before_Ship_Insert_Set_Commission_Date
BEFORE INSERT ON Ships
FOR EACH ROW
BEGIN
    IF NEW.commission_date IS NULL THEN
        SET NEW.commission_date = CURDATE();
    END IF;
END$$
DELIMITER ;

-- 20. A bonus query: Find the oldest active ship in the navy
SELECT ship_name, commission_date, TIMESTAMPDIFF(YEAR, commission_date, CURDATE()) AS service_age
FROM Ships
WHERE current_status = 'Active'
ORDER BY commission_date ASC
LIMIT 1;


-- ====================================================================================================
-- TABLE 3: Weapons
-- ====================================================================================================

-- -------------------------------
-- VIEWS on Weapons
-- -------------------------------
-- 1. View for high-range missiles (range > 300 km)
CREATE OR REPLACE VIEW Long_Range_Missiles_View AS
SELECT weapon_name, weapon_type, range_km, country_of_origin
FROM Weapons
WHERE weapon_type LIKE '%Missile%' AND range_km > 300;

-- 2. View for weapons of Indian origin
CREATE OR REPLACE VIEW Indigenous_Weapons_View AS
SELECT weapon_name, weapon_type, manufacturer, entry_into_service_year
FROM Weapons
WHERE country_of_origin LIKE '%India%';

-- 3. Complex View: Weapons and their total inventory value (assuming a dummy price)
CREATE OR REPLACE VIEW Weapon_Inventory_Value_View AS
SELECT weapon_name, inventory_count, (inventory_count * 100000) AS dummy_inventory_value_usd
FROM Weapons
ORDER BY dummy_inventory_value_usd DESC;

-- -------------------------------
-- CURSORS on Weapons
-- -------------------------------
-- 4. Cursor to list all weapons with low inventory (count < 50)
DELIMITER $$
CREATE PROCEDURE ListLowInventoryWeapons()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE w_name VARCHAR(100);
    DECLARE w_count INT;
    DECLARE low_inv_cursor CURSOR FOR SELECT weapon_name, inventory_count FROM Weapons WHERE inventory_count < 50;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN low_inv_cursor;
    read_loop: LOOP
        FETCH low_inv_cursor INTO w_name, w_count;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT CONCAT('Low Inventory Alert: ', w_name, ' (Count: ', w_count, ')') AS Alert;
    END LOOP;
    CLOSE low_inv_cursor;
END$$
DELIMITER ;
-- CALL ListLowInventoryWeapons();

-- 5. Cursor to list all Russian-made weapons
DELIMITER $$
CREATE PROCEDURE ListRussianWeapons()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE w_name VARCHAR(100);
    DECLARE rus_wpn_cursor CURSOR FOR SELECT weapon_name FROM Weapons WHERE country_of_origin LIKE '%Russia%';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN rus_wpn_cursor;
    read_loop: LOOP
        FETCH rus_wpn_cursor INTO w_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT w_name AS Russian_Weapon;
    END LOOP;
    CLOSE rus_wpn_cursor;
END$$
DELIMITER ;
-- CALL ListRussianWeapons();

-- -------------------------------
-- STORED PROCEDURES for Weapons
-- -------------------------------
-- 6. Procedure to add a new weapon system to the inventory
DELIMITER $$
CREATE PROCEDURE AddNewWeapon(
    IN w_name VARCHAR(100), IN w_type VARCHAR(50), IN w_mfg VARCHAR(100), 
    IN w_origin VARCHAR(50), IN w_range INT, IN w_guidance VARCHAR(100), 
    IN w_warhead VARCHAR(50), IN w_count INT, IN w_service_year INT
)
BEGIN
    INSERT INTO Weapons (weapon_name, weapon_type, manufacturer, country_of_origin, range_km, guidance_system, warhead_type, inventory_count, entry_into_service_year)
    VALUES (w_name, w_type, w_mfg, w_origin, w_range, w_guidance, w_warhead, w_count, w_service_year);
END$$
DELIMITER ;
-- CALL AddNewWeapon('New Gen Missile', 'Hypersonic Cruise Missile', 'DRDO', 'India', 1500, 'Advanced Seeker', 'HE', 5, 2025);

-- 7. Procedure to update the inventory count of a weapon
DELIMITER $$
CREATE PROCEDURE UpdateWeaponInventory(IN w_id INT, IN quantity_change INT)
BEGIN
    UPDATE Weapons SET inventory_count = inventory_count + quantity_change WHERE weapon_id = w_id;
    SELECT 'Inventory updated.' as Result;
END$$
DELIMITER ;
-- CALL UpdateWeaponInventory(1, 10); -- Add 10 BrahMos missiles

-- 8. Procedure to get all weapons of a certain type (e.g., 'Naval Gun')
DELIMITER $$
CREATE PROCEDURE GetWeaponsByType(IN w_type VARCHAR(50))
BEGIN
    SELECT * FROM Weapons WHERE weapon_type = w_type;
END$$
DELIMITER ;
-- CALL GetWeaponsByType('Naval Gun');

-- -------------------------------
-- WINDOW FUNCTIONS on Weapons
-- -------------------------------
-- 9. Rank weapons by range within each weapon type
SELECT weapon_name, weapon_type, range_km,
       RANK() OVER (PARTITION BY weapon_type ORDER BY range_km DESC) as range_rank_in_type
FROM Weapons;

-- 10. Compare the range of a weapon to the average range of its type
SELECT weapon_name, weapon_type, range_km,
       AVG(range_km) OVER (PARTITION BY weapon_type) as avg_range_for_type
FROM Weapons;

-- 11. Find the weapon with the longest and shortest range using FIRST_VALUE and LAST_VALUE
SELECT weapon_type,
       FIRST_VALUE(weapon_name) OVER (PARTITION BY weapon_type ORDER BY range_km DESC) as longest_range_weapon,
       LAST_VALUE(weapon_name) OVER (PARTITION BY weapon_type ORDER BY range_km DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as shortest_range_weapon
FROM Weapons;

-- 12. Assign weapons to 3 tiers based on their service entry year (new, mid, old)
SELECT weapon_name, entry_into_service_year,
       NTILE(3) OVER (ORDER BY entry_into_service_year DESC) as technology_tier
FROM Weapons;

-- -------------------------------
-- DCL & TCL on Weapons
-- -------------------------------
-- 13. DCL: Allow logistics_officer to update inventory count
GRANT UPDATE(inventory_count) ON indian_navy.Weapons TO 'logistics_officer'@'localhost';

-- 14. DCL: Revoke the permission
REVOKE UPDATE ON indian_navy.Weapons FROM 'logistics_officer'@'localhost';

-- 15. TCL: A transaction to deduct weapon counts and commit
START TRANSACTION;
-- Simulate firing 2 BrahMos and 10 Barak 8 missiles
UPDATE Weapons SET inventory_count = inventory_count - 2 WHERE weapon_name = 'BrahMos';
UPDATE Weapons SET inventory_count = inventory_count - 10 WHERE weapon_name = 'Barak 8';
COMMIT;

-- 16. TCL: A transaction that gets rolled back
START TRANSACTION;
UPDATE Weapons SET inventory_count = 0 WHERE weapon_type = 'Naval Gun';
ROLLBACK; -- This was an error, rollback the change.

-- -------------------------------
-- TRIGGERS on Weapons
-- -------------------------------
-- 17. Trigger to check for low inventory and insert an alert
DELIMITER $$
CREATE TRIGGER After_Weapon_Inventory_Update_Alert
AFTER UPDATE ON Weapons
FOR EACH ROW
BEGIN
    IF NEW.inventory_count < 20 AND OLD.inventory_count >= 20 THEN
        INSERT INTO Weapon_Reorder_Alerts(weapon_id, weapon_name, inventory_count)
        VALUES (NEW.weapon_id, NEW.weapon_name, NEW.inventory_count);
    END IF;
END$$
DELIMITER ;
-- UPDATE Weapons SET inventory_count = 15 WHERE weapon_id = 9; -- This should fire the trigger
-- SELECT * FROM Weapon_Reorder_Alerts;

-- 18. Trigger to prevent setting a negative inventory count
DELIMITER $$
CREATE TRIGGER Before_Weapon_Inventory_Update_Check_Negative
BEFORE UPDATE ON Weapons
FOR EACH ROW
BEGIN
    IF NEW.inventory_count < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Inventory count cannot be negative.';
    END IF;
END$$
DELIMITER ;
-- CALL UpdateWeaponInventory(7, -200); -- This should fail due to the trigger

-- 19. Trigger to capitalize the weapon name before insert
DELIMITER $$
CREATE TRIGGER Before_Weapon_Insert_Capitalize
BEFORE INSERT ON Weapons
FOR EACH ROW
BEGIN
    SET NEW.weapon_name = UPPER(NEW.weapon_name);
END$$
DELIMITER ;

-- 20. Bonus Query: Find the top 3 manufacturers by the number of different weapon systems they supply.
SELECT manufacturer, COUNT(weapon_id) as num_weapon_systems
FROM Weapons
GROUP BY manufacturer
ORDER BY num_weapon_systems DESC
LIMIT 3;

