use indianarmy;

-- =================================================================
-- Queries for Table 1: `Personnel`
-- =================================================================

-- 1. List all personnel with their formatted rank and name using a UDF.
SELECT personnel_id, service_number, FormatRankAndName(full_name, post) AS formatted_name
FROM Personnel;

-- 2. Calculate the service duration for all personnel using a UDF.
SELECT full_name, date_of_commission, CalculateServiceDuration(date_of_commission) AS years_of_service
FROM Personnel
ORDER BY years_of_service DESC;

-- 3. INNER JOIN: List all personnel who are commanding officers of active ships.
SELECT p.full_name, p.post, s.ship_name
FROM Personnel p
INNER JOIN Ships s ON p.personnel_id = s.commanding_officer_id
WHERE s.current_status = 'Active';

-- 4. LEFT JOIN: Show all personnel and, if they have one, the award they received.
SELECT p.full_name, a.award_name
FROM Personnel p
LEFT JOIN Awards_And_Honours a ON p.personnel_id = a.personnel_id;

-- 5. SUBQUERY (Scalar): Find personnel who are older than the average age of all personnel.
SELECT full_name, date_of_birth
FROM Personnel
WHERE date_of_birth < (SELECT DATE_SUB(CURDATE(), INTERVAL (SELECT AVG(TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE())) FROM Personnel) YEAR));

-- 6. SUBQUERY (IN): Find all personnel who have received a 'Gallantry' award.
SELECT full_name, post FROM Personnel
WHERE personnel_id IN (SELECT personnel_id FROM Awards_And_Honours WHERE award_category = 'Gallantry');

-- 7. SUBQUERY (EXISTS): Find personnel for whom a family record exists.
SELECT full_name FROM Personnel p
WHERE EXISTS (SELECT 1 FROM Family_Details fd WHERE fd.personnel_id = p.personnel_id);

-- 8. AGGREGATE FUNCTION: Count the number of personnel by blood group.
SELECT blood_group, COUNT(*) AS number_of_personnel
FROM Personnel
GROUP BY blood_group
ORDER BY number_of_personnel DESC;

-- 9. STRING FUNCTION: Display full names and email addresses (if it existed) in lowercase.
SELECT LOWER(full_name) AS lower_case_name, post
FROM Personnel;

-- 10. DATE FUNCTION: List personnel commissioned in the 1990s.
SELECT full_name, date_of_commission
FROM Personnel
WHERE YEAR(date_of_commission) BETWEEN 1990 AND 1999;

-- 11. Find the top 5 longest-serving personnel.
SELECT full_name, post, CalculateServiceDuration(date_of_commission) AS service_years
FROM Personnel
ORDER BY service_years DESC
LIMIT 5;

-- 12. INNER JOIN & AGGREGATE: List personnel and the number of awards they have received.
SELECT p.full_name, COUNT(a.award_id) AS total_awards
FROM Personnel p
INNER JOIN Awards_And_Honours a ON p.personnel_id = a.personnel_id
GROUP BY p.full_name
ORDER BY total_awards DESC;

-- 13. SUBQUERY (Correlated): Find personnel whose date of birth is the earliest for their respective post.
SELECT full_name, post, date_of_birth FROM Personnel p1
WHERE date_of_birth = (SELECT MIN(date_of_birth) FROM Personnel p2 WHERE p2.post = p1.post);

-- 14. Find personnel with a specific contact number prefix.
SELECT full_name, contact_number FROM Personnel
WHERE contact_number LIKE '9123%';

-- 15. RIGHT JOIN: List all promotions with the personnel's name, including any promotions for personnel not in the main table (if possible).
SELECT p.full_name, pr.new_rank, pr.date_of_promotion
FROM Promotions pr
RIGHT JOIN Personnel p ON pr.personnel_id = p.personnel_id;

-- 16. NUMERIC FUNCTION: Calculate the age of each person in years and months.
SELECT full_name, 
       FLOOR(DATEDIFF(CURDATE(), date_of_birth) / 365) AS age_in_years,
       FLOOR((DATEDIFF(CURDATE(), date_of_birth) % 365) / 30) AS age_in_months
FROM Personnel;

-- 17. SUBQUERY in FROM: Select personnel from a derived table of officers only.
SELECT officer.Name
FROM (SELECT full_name AS Name, post FROM Personnel WHERE post IN ('Admiral', 'Vice Admiral', 'Captain', 'Commander')) AS officer;

-- 18. Find personnel who are listed as analysts on intelligence reports.
SELECT DISTINCT p.full_name, p.post FROM Personnel p
INNER JOIN Intelligence_Reports ir ON p.personnel_id = ir.analyst_id;

-- 19. List personnel and their next of kin.
SELECT p.full_name, fd.full_name AS next_of_kin, fd.relationship
FROM Personnel p
JOIN Family_Details fd ON p.personnel_id = fd.personnel_id
WHERE fd.is_next_of_kin = 1;

-- 20. Find all personnel who have not had a promotion recorded in the Promotions table.
SELECT p.full_name FROM Personnel p
LEFT JOIN Promotions pr ON p.personnel_id = pr.personnel_id
WHERE pr.promotion_id IS NULL;


-- =================================================================
-- Queries for Table 2: `Ships`
-- =================================================================

-- 1. INNER JOIN: List all active ships with the name of their commanding officer.
SELECT s.ship_name, s.pennant_number, p.full_name AS commanding_officer
FROM Ships s
INNER JOIN Personnel p ON s.commanding_officer_id = p.personnel_id
WHERE s.current_status = 'Active';

-- 2. LEFT JOIN: Show all ships and their home port's city and state.
SELECT s.ship_name, b.base_name, b.location_city, b.location_state
FROM Ships s
LEFT JOIN Bases b ON s.home_port_id = b.base_id;

-- 3. AGGREGATE FUNCTION: Count the number of ships of each type.
SELECT ship_type, COUNT(ship_id) AS number_of_ships
FROM Ships
GROUP BY ship_type
ORDER BY number_of_ships DESC;

-- 4. UDF: Calculate the age of each ship.
SELECT ship_name, commission_date, GetAssetAge(commission_date) AS age_in_years
FROM Ships
ORDER BY age_in_years DESC;

-- 5. SUBQUERY (Scalar): Find ships commissioned after the oldest ship.
SELECT ship_name, commission_date
FROM Ships
WHERE commission_date > (SELECT MIN(commission_date) FROM Ships);

-- 6. SUBQUERY (IN): Find all ships based in 'Mumbai'.
SELECT ship_name, ship_class FROM Ships
WHERE home_port_id IN (SELECT base_id FROM Bases WHERE location_city = 'Mumbai');

-- 7. SUBQUERY (Correlated): For each ship type, find the ship that was commissioned first.
SELECT ship_name, ship_type, commission_date FROM Ships s1
WHERE commission_date = (SELECT MIN(commission_date) FROM Ships s2 WHERE s2.ship_type = s1.ship_type);

-- 8. DATE FUNCTION: List all ships commissioned in the last 10 years.
SELECT ship_name, commission_date
FROM Ships
WHERE commission_date >= DATE_SUB(CURDATE(), INTERVAL 10 YEAR);

-- 9. STRING FUNCTION: List ship names in uppercase.
SELECT UPPER(ship_name) AS upper_case_ship_name, ship_class
FROM Ships;

-- 10. Find ships that participated in 'Malabar 2023' operation.
SELECT DISTINCT s.ship_name
FROM Ships s
JOIN Deployment_History dh ON s.ship_id = dh.asset_id AND dh.asset_type = 'Ship'
JOIN Operations o ON dh.operation_id = o.operation_id
WHERE o.operation_name = 'Malabar 2023';

-- 11. Find all ships that are currently undergoing maintenance.
SELECT s.ship_name, ms.maintenance_type, ms.status
FROM Ships s
JOIN Maintenance_Schedule ms ON s.ship_id = ms.asset_id AND ms.asset_type = 'Ship'
WHERE ms.status = 'In Progress';

-- 12. Find the ship with the most deployments recorded.
SELECT s.ship_name, COUNT(dh.deployment_id) AS deployment_count
FROM Ships s
JOIN Deployment_History dh ON s.ship_id = dh.asset_id AND dh.asset_type = 'Ship'
GROUP BY s.ship_name
ORDER BY deployment_count DESC
LIMIT 1;

-- 13. List all ships and the total distance they have sailed according to deployment history.
SELECT s.ship_name, SUM(dh.distance_sailed_nm) AS total_distance_nm
FROM Ships s
JOIN Deployment_History dh ON s.ship_id = dh.asset_id AND dh.asset_type = 'Ship'
GROUP BY s.ship_name
HAVING total_distance_nm IS NOT NULL
ORDER BY total_distance_nm DESC;

-- 14. Find ships that are of the same class as 'INS Shivalik'.
SELECT ship_name, ship_class
FROM Ships
WHERE ship_class = (SELECT ship_class FROM Ships WHERE ship_name = 'INS Shivalik') AND ship_name != 'INS Shivalik';

-- 15. List all 'Destroyer' and 'Frigate' class ships using an IN clause.
SELECT ship_name, ship_type
FROM Ships
WHERE ship_type IN ('Destroyer', 'Frigate');

-- 16. List ships that do not have a commanding officer assigned.
SELECT ship_name, current_status
FROM Ships
WHERE commanding_officer_id IS NULL;

-- 17. CROSS JOIN: Create a hypothetical pairing of every ship with every weapon system.
SELECT s.ship_name, w.weapon_name
FROM Ships s
CROSS JOIN Weapons w
LIMIT 20; -- Limiting for brevity

-- 18. Find all active ships based at a dockyard.
SELECT s.ship_name, b.base_name
FROM Ships s
JOIN Bases b ON s.home_port_id = b.base_id
WHERE b.base_type = 'Dockyard' AND s.current_status = 'Active';

-- 19. Using a subquery in the FROM clause, find the average age of active destroyers.
SELECT AVG(age_in_years) AS avg_destroyer_age
FROM (SELECT GetAssetAge(commission_date) AS age_in_years FROM Ships WHERE ship_type = 'Destroyer' AND current_status = 'Active') AS active_destroyers;

-- 20. List ships along with their CO's name and the CO's years of service.
SELECT s.ship_name, p.full_name AS co_name, CalculateServiceDuration(p.date_of_commission) AS co_service_years
FROM Ships s
JOIN Personnel p ON s.commanding_officer_id = p.personnel_id
ORDER BY co_service_years DESC;


-- =================================================================
-- Queries for Table 3: `Bases`
-- =================================================================

-- 1. AGGREGATE: Count the number of bases in each command.
SELECT command, COUNT(*) AS base_count
FROM Bases
GROUP BY command;

-- 2. SUBQUERY: Find bases with capacity above the average capacity.
SELECT base_name, capacity
FROM Bases
WHERE capacity > (SELECT AVG(capacity) FROM Bases);

-- 3. INNER JOIN: List bases and the number of ships homed at each base.
SELECT b.base_name, b.location_city, COUNT(s.ship_id) AS ship_count
FROM Bases b
INNER JOIN Ships s ON b.base_id = s.home_port_id
GROUP BY b.base_name, b.location_city
ORDER BY ship_count DESC;

-- 4. LEFT JOIN: List all bases and the count of aircraft stationed there.
SELECT b.base_name, COUNT(a.aircraft_id) AS aircraft_count
FROM Bases b
LEFT JOIN Aircraft a ON b.base_id = a.base_id
GROUP BY b.base_name
ORDER BY aircraft_count DESC;

-- 5. DATE FUNCTION: Find the oldest naval base.
SELECT base_name, establishment_date
FROM Bases
ORDER BY establishment_date ASC
LIMIT 1;

-- 6. STRING FUNCTION: List bases with 'Naval' in their name.
SELECT base_name, location_city
FROM Bases
WHERE base_name LIKE '%Naval%';

-- 7. NUMERIC FUNCTION: Show base capacity in thousands, rounded down.
SELECT base_name, capacity, FLOOR(capacity / 1000) AS capacity_in_thousands
FROM Bases;

-- 8. SUBQUERY (IN): Find bases that are also training establishments for courses.
SELECT base_name, base_type FROM Bases
WHERE base_id IN (SELECT DISTINCT training_establishment_id FROM Training_Courses);

-- 9. List bases in 'Kerala' state.
SELECT base_name, location_city FROM Bases
WHERE location_state = 'Kerala';

-- 10. Find bases that are of type 'Air Station' or 'Dockyard'.
SELECT base_name, base_type, command
FROM Bases
WHERE base_type IN ('Air Station', 'Dockyard');

-- 11. Find the total capacity of all bases combined for each command.
SELECT command, SUM(capacity) AS total_capacity
FROM Bases
GROUP BY command;

-- 12. Find bases established between 1960 and 1990.
SELECT base_name, establishment_date
FROM Bases
WHERE YEAR(establishment_date) BETWEEN 1960 AND 1990;

-- 13. INNER JOIN: List the bases where maintenance activities are performed.
SELECT DISTINCT b.base_name, b.location_city
FROM Bases b
INNER JOIN Maintenance_Schedule ms ON b.base_id = ms.performing_unit_id;

-- 14. SUBQUERY (Correlated): Find bases whose capacity is the maximum in their state.
SELECT base_name, location_state, capacity FROM Bases b1
WHERE capacity = (SELECT MAX(capacity) FROM Bases b2 WHERE b2.location_state = b1.location_state);

-- 15. List bases and their geographical coordinates formatted.
SELECT base_name, CONCAT('Lat: ', latitude, ', Lon: ', longitude) AS coordinates
FROM Bases;

-- 16. Find the base which is home to the most submarines.
SELECT b.base_name, COUNT(sub.sub_id) AS submarine_count
FROM Bases b
JOIN Submarines sub ON b.base_id = sub.home_port_id
GROUP BY b.base_name
ORDER BY submarine_count DESC
LIMIT 1;

-- 17. Find bases that are headquarters for a command structure.
SELECT b.base_name, cs.command_name
FROM Bases b
JOIN Command_Structure cs ON b.base_id = cs.hq_base_id;

-- 18. List all bases that are NOT in the 'Western' command.
SELECT base_name, command FROM Bases
WHERE command != 'Western';

-- 19. Find the newest base in the 'Eastern' command.
SELECT base_name, establishment_date
FROM Bases
WHERE command = 'Eastern'
ORDER BY establishment_date DESC
LIMIT 1;

-- 20. Find bases that store 'Ammunition' based on the Logistics_Supply table.
SELECT DISTINCT b.base_name, b.location_city
FROM Bases b
JOIN Logistics_Supply ls ON b.base_id = ls.storage_location_id
WHERE ls.item_category = 'Ammunition';


-- =================================================================
-- Queries for Table 4: `Aircraft`
-- =================================================================

-- 1. UDF & JOIN: List all operational aircraft, their age, squadron, and base.
SELECT a.tail_number, a.model_name, GetAssetAge(a.commission_date) AS age, s.squadron_name, b.base_name
FROM Aircraft a
JOIN Squadrons s ON a.squadron_id = s.squadron_id
JOIN Bases b ON a.base_id = b.base_id
WHERE a.current_status = 'Operational';

-- 2. SUBQUERY: Find aircraft with more airframe hours than the average for their type.
SELECT tail_number, aircraft_type, airframe_hours FROM Aircraft a1
WHERE airframe_hours > (SELECT AVG(airframe_hours) FROM Aircraft a2 WHERE a2.aircraft_type = a1.aircraft_type);

-- 3. DATE FUNCTION: Find aircraft whose last service was more than a year ago.
SELECT tail_number, model_name, last_serviced_date
FROM Aircraft
WHERE last_serviced_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- 4. AGGREGATE & JOIN: Find the total airframe hours for each squadron.
SELECT s.squadron_name, SUM(a.airframe_hours) AS total_hours
FROM Aircraft a
JOIN Squadrons s ON a.squadron_id = s.squadron_id
GROUP BY s.squadron_name
ORDER BY total_hours DESC;

-- 5. SUBQUERY (EXISTS): Find aircraft types for which a squadron specialization exists.
SELECT DISTINCT model_name, aircraft_type FROM Aircraft a
WHERE EXISTS (SELECT 1 FROM Squadrons s WHERE s.aircraft_type_specialization = a.model_name);

-- 6. STRING FUNCTION: Find all 'P-8I Neptune' aircraft and display their tail numbers.
SELECT tail_number, current_status
FROM Aircraft
WHERE model_name = 'P-8I Neptune';

-- 7. List all aircraft based at 'INS Hansa' in Goa.
SELECT a.tail_number, a.model_name
FROM Aircraft a
JOIN Bases b ON a.base_id = b.base_id
WHERE b.base_name = 'INS Hansa';

-- 8. Find the aircraft with the highest number of airframe hours.
SELECT tail_number, model_name, airframe_hours
FROM Aircraft
ORDER BY airframe_hours DESC
LIMIT 1;

-- 9. Find aircraft that are currently in 'Maintenance'.
SELECT tail_number, model_name, base_id
FROM Aircraft
WHERE current_status = 'Maintenance';

-- 10. LEFT JOIN: List all aircraft and their upcoming maintenance schedule, if any.
SELECT a.tail_number, a.model_name, ms.maintenance_type, ms.scheduled_start_date
FROM Aircraft a
LEFT JOIN Maintenance_Schedule ms ON a.aircraft_id = ms.asset_id AND ms.asset_type = 'Aircraft'
WHERE ms.status = 'Scheduled';

-- 11. Count the number of operational aircraft per type.
SELECT aircraft_type, COUNT(*) as operational_count
FROM Aircraft
WHERE current_status = 'Operational'
GROUP BY aircraft_type;

-- 12. Find aircraft commissioned before the year 2000.
SELECT tail_number, model_name, commission_date
FROM Aircraft
WHERE YEAR(commission_date) < 2000;

-- 13. List aircraft and their squadron's role.
SELECT a.tail_number, a.model_name, s.role
FROM Aircraft a
JOIN Squadrons s ON a.squadron_id = s.squadron_id;

-- 14. SUBQUERY (NOT IN): List aircraft that have not been deployed on any recorded operation.
SELECT tail_number, model_name FROM Aircraft
WHERE aircraft_id NOT IN (SELECT DISTINCT asset_id FROM Deployment_History WHERE asset_type = 'Aircraft');

-- 15. Find the average airframe hours for all aircraft.
SELECT AVG(airframe_hours) AS average_hours
FROM Aircraft;

-- 16. List the number of sorties flown by each aircraft model.
SELECT a.model_name, SUM(dh.sorties_flown) AS total_sorties
FROM Aircraft a
JOIN Deployment_History dh ON a.aircraft_id = dh.asset_id AND dh.asset_type = 'Aircraft'
GROUP BY a.model_name
ORDER BY total_sorties DESC;

-- 17. Find the newest and oldest aircraft in the inventory.
(SELECT tail_number, model_name, commission_date, 'Newest' AS category FROM Aircraft ORDER BY commission_date DESC LIMIT 1)
UNION
(SELECT tail_number, model_name, commission_date, 'Oldest' AS category FROM Aircraft ORDER BY commission_date ASC LIMIT 1);

-- 18. List all 'Fighter' type aircraft and their squadron names.
SELECT a.tail_number, s.squadron_name
FROM Aircraft a
JOIN Squadrons s ON a.squadron_id = s.squadron_id
WHERE a.aircraft_type = 'Fighter';

-- 19. Correlated Subquery: Find aircraft with fewer hours than the squadron average.
SELECT tail_number, model_name, airframe_hours
FROM Aircraft a1
WHERE airframe_hours < (SELECT AVG(airframe_hours) FROM Aircraft a2 WHERE a2.squadron_id = a1.squadron_id);

-- 20. Display aircraft details along with the name of the base commander (hypothetical).
-- This query assumes a base_commander_id field in the Bases table for demonstration.
-- SELECT a.tail_number, b.base_name, p.full_name AS base_commander
-- FROM Aircraft a
-- JOIN Bases b ON a.base_id = b.base_id
-- JOIN Personnel p ON b.base_commander_id = p.personnel_id;


-- =================================================================
-- Queries for Table 5: `Squadrons`
-- =================================================================

-- 1. JOIN: List all squadrons with their commanding officer's name and base location.
SELECT s.squadron_name, s.squadron_number, p.full_name AS commanding_officer, b.base_name
FROM Squadrons s
JOIN Personnel p ON s.commanding_officer_id = p.personnel_id
JOIN Bases b ON s.base_id = b.base_id;

-- 2. AGGREGATE: Count the number of squadrons based at each naval base.
SELECT b.base_name, COUNT(s.squadron_id) AS number_of_squadrons
FROM Squadrons s
JOIN Bases b ON s.base_id = b.base_id
GROUP BY b.base_name
ORDER BY number_of_squadrons DESC;

-- 3. STRING FUNCTION: Display squadron names and their mottos in uppercase.
SELECT UPPER(squadron_name) AS name, UPPER(motto) AS motto
FROM Squadrons;

-- 4. SUBQUERY: Find squadrons with more than 10 total aircraft.
SELECT squadron_name, total_aircraft
FROM Squadrons
WHERE total_aircraft > 10;

-- 5. DATE FUNCTION: Find squadrons established in the 21st century.
SELECT squadron_name, establishment_date
FROM Squadrons
WHERE YEAR(establishment_date) >= 2001;

-- 6. Find squadrons specializing in 'Anti-Submarine Warfare'.
SELECT squadron_name, squadron_number, role
FROM Squadrons
WHERE role = 'Anti-Submarine Warfare';

-- 7. LEFT JOIN: List all squadrons and the number of operational aircraft they have.
SELECT s.squadron_name, COUNT(a.aircraft_id) AS operational_aircraft
FROM Squadrons s
LEFT JOIN Aircraft a ON s.squadron_id = a.squadron_id AND a.current_status = 'Operational'
GROUP BY s.squadron_name
ORDER BY operational_aircraft DESC;

-- 8. Find the oldest squadron.
SELECT squadron_name, establishment_date
FROM Squadrons
ORDER BY establishment_date ASC
LIMIT 1;

-- 9. List squadrons based in the 'Southern' command.
SELECT s.squadron_name, s.role
FROM Squadrons s
JOIN Bases b ON s.base_id = b.base_id
WHERE b.command = 'Southern';

-- 10. SUBQUERY (IN): Find the commanding officers of squadrons that fly the 'P-8I Neptune'.
SELECT full_name FROM Personnel
WHERE personnel_id IN (SELECT commanding_officer_id FROM Squadrons WHERE aircraft_type_specialization = 'P-8I Neptune');

-- 11. Find squadrons whose role is related to 'Training'.
SELECT squadron_name, role
FROM Squadrons
WHERE role LIKE '%Training%';

-- 12. Calculate the average number of aircraft per squadron.
SELECT AVG(total_aircraft) AS avg_aircraft_per_squadron
FROM Squadrons;

-- 13. List squadrons that have 0 total aircraft, indicating they are decommissioned or forming.
SELECT squadron_name, squadron_number
FROM Squadrons
WHERE total_aircraft = 0;

-- 14. SUBQUERY (Correlated): Find squadrons that have more aircraft than the average for their base.
SELECT squadron_name, total_aircraft, base_id FROM Squadrons s1
WHERE total_aircraft > (SELECT AVG(total_aircraft) FROM Squadrons s2 WHERE s2.base_id = s1.base_id);

-- 15. SELF JOIN (Hypothetical): Find squadrons based at the same base.
SELECT s1.squadron_name, s2.squadron_name, b.base_name
FROM Squadrons s1
JOIN Squadrons s2 ON s1.base_id = s2.base_id AND s1.squadron_id < s2.squadron_id
JOIN Bases b ON s1.base_id = b.base_id;

-- 16. List all aircraft belonging to 'The Black Panthers' squadron.
SELECT a.tail_number, a.model_name
FROM Aircraft a
JOIN Squadrons s ON a.squadron_id = s.squadron_id
WHERE s.squadron_name = 'The Black Panthers';

-- 17. Find the total number of aircraft specialized for each role.
SELECT role, SUM(total_aircraft) as total_specialized_aircraft
FROM Squadrons
GROUP BY role
ORDER BY total_specialized_aircraft DESC;

-- 18. List squadron numbers and their establishment year.
SELECT squadron_number, YEAR(establishment_date) AS establishment_year
FROM Squadrons;

-- 19. Find the commanding officer for squadron 'INAS 312'.
SELECT p.full_name
FROM Personnel p
JOIN Squadrons s ON p.personnel_id = s.commanding_officer_id
WHERE s.squadron_number = 'INAS 312';

-- 20. SUBQUERY (NOT EXISTS): Find squadrons for which no aircraft are currently listed in the Aircraft table.
SELECT s.squadron_name FROM Squadrons s
WHERE NOT EXISTS (SELECT 1 FROM Aircraft a WHERE a.squadron_id = s.squadron_id);

-- ... (This pattern continues for all 25 tables)

-- NOTE: To keep the response size manageable, I will now provide queries for the remaining tables in a more condensed format. 
-- The same principles of Joins, Subqueries, Built-in Functions, and UDFs are applied throughout.

-- =================================================================
-- Queries for Table 6: `Weapons`
-- =================================================================
-- 1. Find the top 5 weapons with the longest range.
SELECT weapon_name, range_km, weapon_type FROM Weapons ORDER BY range_km DESC LIMIT 5;
-- 2. Count the number of weapon systems by country of origin.
SELECT country_of_origin, COUNT(*) AS weapon_count FROM Weapons GROUP BY country_of_origin;
-- 3. SUBQUERY: Find weapons with a range greater than the average range of all weapons.
SELECT weapon_name, range_km FROM Weapons WHERE range_km > (SELECT AVG(range_km) FROM Weapons);
-- 4. List all 'Missile' type weapons with their manufacturer.
SELECT weapon_name, manufacturer FROM Weapons WHERE weapon_type LIKE '%Missile%';
-- 5. Calculate the total inventory count for each weapon type.
SELECT weapon_type, SUM(inventory_count) AS total_inventory FROM Weapons GROUP BY weapon_type;
-- 6. Find weapons that entered service before 1990.
SELECT weapon_name, entry_into_service_year FROM Weapons WHERE entry_into_service_year < 1990;
-- 7. List all weapons of Indian origin.
SELECT weapon_name, manufacturer FROM Weapons WHERE country_of_origin = 'India';
-- 8. Find the weapon with the highest inventory count.
SELECT weapon_name, inventory_count FROM Weapons ORDER BY inventory_count DESC LIMIT 1;
-- 9. List weapons with 'Radar' in their guidance system.
SELECT weapon_name, guidance_system FROM Weapons WHERE guidance_system LIKE '%Radar%';
-- 10. SUBQUERY (IN): Find weapons manufactured by 'DRDO'.
SELECT weapon_name FROM Weapons WHERE manufacturer IN ('DRDO', 'IAI/DRDO', 'BrahMos Aerospace');
-- 11. Find the average range of 'Anti-Ship' missiles.
SELECT AVG(range_km) AS avg_asm_range FROM Weapons WHERE weapon_name LIKE '%Anti-Ship%';
-- 12. List all unique manufacturers.
SELECT DISTINCT manufacturer FROM Weapons;
-- 13. Find weapons with a 'Nuclear' warhead type.
SELECT weapon_name, range_km FROM Weapons WHERE warhead_type LIKE '%Nuclear%';
-- 14. SUBQUERY (Correlated): Find weapons with the longest range for their type.
SELECT weapon_name, weapon_type, range_km FROM Weapons w1 WHERE range_km = (SELECT MAX(range_km) FROM Weapons w2 WHERE w2.weapon_type = w1.weapon_type);
-- 15. Show the age of service for each weapon system.
SELECT weapon_name, (YEAR(CURDATE()) - entry_into_service_year) AS service_age FROM Weapons;
-- 16. Find the total number of Russian-origin weapons in inventory.
SELECT SUM(inventory_count) AS russian_origin_inventory FROM Weapons WHERE country_of_origin = 'Russia';
-- 17. List weapons with an inventory count between 100 and 300.
SELECT weapon_name, inventory_count FROM Weapons WHERE inventory_count BETWEEN 100 AND 300;
-- 18. Find the most common guidance system.
SELECT guidance_system, COUNT(*) AS frequency FROM Weapons GROUP BY guidance_system ORDER BY frequency DESC LIMIT 1;
-- 19. Display weapon names and their types in a concatenated string.
SELECT CONCAT(weapon_name, ' (', weapon_type, ')') AS weapon_description FROM Weapons;
-- 20. Find weapons with no guidance system listed (Unguided).
SELECT weapon_name, weapon_type FROM Weapons WHERE guidance_system = 'Unguided';

-- =================================================================
-- Queries for Table 7: `Operations`
-- =================================================================
-- 1. UDF: List all operations and calculate their duration.
SELECT operation_name, operation_type, GetOperationDuration(start_date, end_date) AS duration FROM Operations;
-- 2. JOIN & AGGREGATE: List operations and the number of assets deployed for each.
SELECT o.operation_name, COUNT(dh.deployment_id) AS assets_deployed FROM Operations o JOIN Deployment_History dh ON o.operation_id = dh.operation_id GROUP BY o.operation_name;
-- 3. SUBQUERY: Find operations that occurred entirely within the year 2020.
SELECT operation_name FROM Operations WHERE YEAR(start_date) = 2020 AND YEAR(end_date) = 2020;
-- 4. STRING FUNCTION: Find operations with 'Exercise' in the type.
SELECT operation_name, operation_type FROM Operations WHERE operation_type LIKE '%Exercise%';
-- 5. Find all ongoing HADR operations.
SELECT operation_name, start_date FROM Operations WHERE status = 'Ongoing' AND operation_type = 'HADR';
-- 6. List all 'Completed' operations in the 'Indian Ocean Region'.
SELECT operation_name, start_date, end_date FROM Operations WHERE status = 'Completed' AND area_of_operation = 'Indian Ocean Region';
-- 7. Find the operation with the longest duration.
SELECT operation_name, DATEDIFF(end_date, start_date) AS duration_days FROM Operations WHERE end_date IS NOT NULL ORDER BY duration_days DESC LIMIT 1;
-- 8. Count the number of operations led by each command.
SELECT lead_command, COUNT(*) AS ops_count FROM Operations GROUP BY lead_command;
-- 9. Find operations that involved an evacuation.
SELECT operation_name, objective FROM Operations WHERE operation_type LIKE '%Evacuation%';
-- 10. SUBQUERY (EXISTS): List operations for which awards were given.
SELECT o.operation_name FROM Operations o WHERE EXISTS (SELECT 1 FROM Awards_And_Honours a WHERE a.operation_id = o.operation_id);
-- 11. Find all bilateral exercises.
SELECT operation_name, area_of_operation FROM Operations WHERE operation_name LIKE 'SIMBEX%' OR operation_name LIKE 'Varuna%' OR operation_name LIKE 'SLINEX%' OR operation_name LIKE 'Konkan%' OR operation_name LIKE 'AUSINDEX%' OR operation_name LIKE 'JIMEX%';
-- 12. LEFT JOIN: Show all operations and the name of the flagship deployed (if any).
SELECT o.operation_name, s.ship_name AS flagship FROM Operations o LEFT JOIN Deployment_History dh ON o.operation_id = dh.operation_id AND dh.role_in_operation LIKE '%Flagship%' LEFT JOIN Ships s ON dh.asset_id = s.ship_id;
-- 13. List operations and format their start and end dates.
SELECT operation_name, DATE_FORMAT(start_date, '%d %M %Y') AS formatted_start FROM Operations;
-- 14. Find operations with outcomes mentioning 'Successfully'.
SELECT operation_name, outcome FROM Operations WHERE outcome LIKE 'Successfully%';
-- 15. SUBQUERY (Correlated): Find operations longer than the average duration for their type.
SELECT operation_name, operation_type FROM Operations o1 WHERE DATEDIFF(IFNULL(end_date, CURDATE()), start_date) > (SELECT AVG(DATEDIFF(IFNULL(end_date, CURDATE()), start_date)) FROM Operations o2 WHERE o2.operation_type = o1.operation_type);
-- 16. Find the total number of ongoing operations.
SELECT COUNT(*) AS ongoing_operations FROM Operations WHERE status = 'Ongoing';
-- 17. List all anti-piracy operations.
SELECT operation_name, area_of_operation, status FROM Operations WHERE operation_type = 'Anti-Piracy';
-- 18. Find operations that started in the first quarter of any year.
SELECT operation_name, start_date FROM Operations WHERE MONTH(start_date) IN (1, 2, 3);
-- 19. Display operation objectives in uppercase.
SELECT operation_name, UPPER(objective) AS objective_caps FROM Operations;
-- 20. SUBQUERY (NOT IN): Find operations for which no ships were deployed.
SELECT operation_name FROM Operations WHERE operation_id NOT IN (SELECT DISTINCT operation_id FROM Deployment_History WHERE asset_type = 'Ship');


