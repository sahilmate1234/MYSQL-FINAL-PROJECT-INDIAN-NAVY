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

-- 1. INNER JOIN: List vessels with their assigned base
SELECT v.VesselID, v.VesselName, b.BaseName
FROM Naval_Vessels v
INNER JOIN Naval_Bases b ON v.BaseID = b.BaseID;

-- 2. LEFT JOIN: Show all vessels and their assigned missions (if any)
SELECT v.VesselName, m.MissionName
FROM Naval_Vessels v
LEFT JOIN Missions m ON v.VesselID = m.VesselID;

-- 3. RIGHT JOIN: Show missions even if vessel info is missing
SELECT v.VesselName, m.MissionName
FROM Naval_Vessels v
RIGHT JOIN Missions m ON v.VesselID = m.VesselID;

-- 4. FULL JOIN (simulate with UNION): List vessels and missions
SELECT v.VesselName, m.MissionName
FROM Naval_Vessels v
LEFT JOIN Missions m ON v.VesselID = m.VesselID
UNION
SELECT v.VesselName, m.MissionName
FROM Naval_Vessels v
RIGHT JOIN Missions m ON v.VesselID = m.VesselID;

-- 5. Subquery (non-correlated): Find vessels larger than avg displacement
SELECT VesselName, Displacement
FROM Naval_Vessels
WHERE Displacement > (SELECT AVG(Displacement) FROM Naval_Vessels);

-- 6. Correlated Subquery: Find vessels whose crew size is above avg of their class
SELECT v1.VesselName, v1.CrewSize
FROM Naval_Vessels v1
WHERE v1.CrewSize > (
   SELECT AVG(v2.CrewSize)
   FROM Naval_Vessels v2
   WHERE v2.Class = v1.Class
);

-- 7. Built-in Function: Count vessels by type
SELECT VesselType, COUNT(*) AS TotalVessels
FROM Naval_Vessels
GROUP BY VesselType;

-- 8. Built-in Function: Average crew size per vessel type
SELECT VesselType, AVG(CrewSize) AS AvgCrew
FROM Naval_Vessels
GROUP BY VesselType;

-- 9. String Function: Show vessel names in uppercase
SELECT UPPER(VesselName) AS VesselName_Upper
FROM Naval_Vessels;

-- 10. Date Function: List vessels commissioned in last 10 years
SELECT VesselName, CommissionDate
FROM Naval_Vessels
WHERE YEAR(CURDATE()) - YEAR(CommissionDate) <= 10;

-- 11. CONCAT Function: Show vessel code + name
SELECT CONCAT(VesselCode, '-', VesselName) AS FullName
FROM Naval_Vessels;

-- 12. Nested Subquery: Find oldest commissioned vessel
SELECT VesselName
FROM Naval_Vessels
WHERE CommissionDate = (
   SELECT MIN(CommissionDate) FROM Naval_Vessels
);

-- 13. JOIN with Weapon_Systems: Vessels and their weapons
SELECT v.VesselName, w.WeaponName
FROM Naval_Vessels v
JOIN Weapon_Systems w ON v.VesselID = w.VesselID;

-- 14. JOIN with Operations: Vessels in operations
SELECT v.VesselName, o.OperationName, o.OperationDate
FROM Naval_Vessels v
JOIN Naval_Operations o ON v.VesselID = o.VesselID;

-- 15. HAVING clause: Vessel types with avg displacement > 5000
SELECT VesselType, AVG(Displacement) AS AvgDisplacement
FROM Naval_Vessels
GROUP BY VesselType
HAVING AVG(Displacement) > 5000;

-- 16. EXISTS Subquery: Find vessels with at least one mission
SELECT VesselName
FROM Naval_Vessels v
WHERE EXISTS (SELECT 1 FROM Missions m WHERE m.VesselID = v.VesselID);

-- 17. NOT EXISTS: Vessels with no missions
SELECT VesselName
FROM Naval_Vessels v
WHERE NOT EXISTS (SELECT 1 FROM Missions m WHERE m.VesselID = v.VesselID);

-- 18. Self-Join: Compare vessels of same type
SELECT v1.VesselName AS Vessel1, v2.VesselName AS Vessel2, v1.VesselType
FROM Naval_Vessels v1
JOIN Naval_Vessels v2
  ON v1.VesselType = v2.VesselType AND v1.VesselID <> v2.VesselID;

-- 19. User-Defined Function Example (assuming fn_VesselAge exists)
SELECT VesselName, fn_VesselAge(CommissionDate) AS VesselAge
FROM Naval_Vessels;

-- 20. Case Statement: Categorize vessels by crew size
SELECT VesselName,
   CASE 
     WHEN CrewSize < 100 THEN 'Small'
     WHEN CrewSize BETWEEN 100 AND 500 THEN 'Medium'
     ELSE 'Large'
   END AS CrewCategory
FROM Naval_Vessels;

-- 1. INNER JOIN: List weapons with the vessels they belong to
SELECT w.WeaponID, w.WeaponName, v.VesselName
FROM Weapon_Systems w
INNER JOIN Naval_Vessels v ON w.VesselID = v.VesselID;

-- 2. LEFT JOIN: Show all vessels and their weapons (if any)
SELECT v.VesselName, w.WeaponName
FROM Naval_Vessels v
LEFT JOIN Weapon_Systems w ON v.VesselID = w.VesselID;

-- 3. RIGHT JOIN: Show all weapons, even if vessel details are missing
SELECT v.VesselName, w.WeaponName
FROM Naval_Vessels v
RIGHT JOIN Weapon_Systems w ON v.VesselID = w.VesselID;

-- 4. FULL JOIN (simulate): List vessels and weapons together
SELECT v.VesselName, w.WeaponName
FROM Naval_Vessels v
LEFT JOIN Weapon_Systems w ON v.VesselID = w.VesselID
UNION
SELECT v.VesselName, w.WeaponName
FROM Naval_Vessels v
RIGHT JOIN Weapon_Systems w ON v.VesselID = w.VesselID;

-- 5. Non-Correlated Subquery: Find weapons with range > avg range
SELECT WeaponName, RangeKM
FROM Weapon_Systems
WHERE RangeKM > (SELECT AVG(RangeKM) FROM Weapon_Systems);

-- 6. Correlated Subquery: Find weapons more powerful than average of their type
SELECT w1.WeaponName, w1.PowerRating
FROM Weapon_Systems w1
WHERE w1.PowerRating > (
   SELECT AVG(w2.PowerRating)
   FROM Weapon_Systems w2
   WHERE w2.WeaponType = w1.WeaponType
);

-- 7. Aggregate: Count weapons by type
SELECT WeaponType, COUNT(*) AS TotalWeapons
FROM Weapon_Systems
GROUP BY WeaponType;

-- 8. Aggregate: Max and min range per type
SELECT WeaponType, MAX(RangeKM) AS MaxRange, MIN(RangeKM) AS MinRange
FROM Weapon_Systems
GROUP BY WeaponType;

-- 9. Built-in Function: Uppercase weapon names
SELECT UPPER(WeaponName) AS WeaponName_Upper
FROM Weapon_Systems;

-- 10. Date Function: Weapons inducted in last 15 years
SELECT WeaponName, InductionDate
FROM Weapon_Systems
WHERE YEAR(CURDATE()) - YEAR(InductionDate) <= 15;

-- 11. CONCAT Function: Weapon full identity (Name + Code)
SELECT CONCAT(WeaponCode, '-', WeaponName) AS FullWeapon
FROM Weapon_Systems;

-- 12. Subquery with IN: Weapons installed on vessels stationed at 'Mumbai Base'
SELECT WeaponName
FROM Weapon_Systems
WHERE VesselID IN (
   SELECT VesselID FROM Naval_Vessels WHERE BaseID IN (
      SELECT BaseID FROM Naval_Bases WHERE BaseName = 'Mumbai Base'
   )
);

-- 13. JOIN with Missions: Weapons used in missions
SELECT m.MissionName, w.WeaponName
FROM Missions m
JOIN Weapon_Systems w ON m.WeaponID = w.WeaponID;

-- 14. JOIN with Operations: Weapons deployed in operations
SELECT o.OperationName, w.WeaponName
FROM Naval_Operations o
JOIN Weapon_Systems w ON o.WeaponID = w.WeaponID;

-- 15. HAVING clause: Weapon types with avg power > 80
SELECT WeaponType, AVG(PowerRating) AS AvgPower
FROM Weapon_Systems
GROUP BY WeaponType
HAVING AVG(PowerRating) > 80;

-- 16. EXISTS: Find weapons mounted on at least one vessel
SELECT WeaponName
FROM Weapon_Systems w
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = w.VesselID);

-- 17. NOT EXISTS: Weapons not yet mounted on any vessel
SELECT WeaponName
FROM Weapon_Systems w
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = w.VesselID);

-- 18. Self-Join: Compare weapons of the same type
SELECT w1.WeaponName AS Weapon1, w2.WeaponName AS Weapon2, w1.WeaponType
FROM Weapon_Systems w1
JOIN Weapon_Systems w2
  ON w1.WeaponType = w2.WeaponType AND w1.WeaponID <> w2.WeaponID;

-- 19. User-Defined Function Example (fn_WeaponAge)
SELECT WeaponName, fn_WeaponAge(InductionDate) AS WeaponAge
FROM Weapon_Systems;

-- 20. CASE Statement: Categorize weapons by range
SELECT WeaponName,
   CASE 
     WHEN RangeKM < 50 THEN 'Short-Range'
     WHEN RangeKM BETWEEN 50 AND 200 THEN 'Medium-Range'
     ELSE 'Long-Range'
   END AS RangeCategory
FROM Weapon_Systems;

-- 1. INNER JOIN: List all operations with their vessels
SELECT o.OperationID, o.OperationName, v.VesselName
FROM Naval_Operations o
INNER JOIN Naval_Vessels v ON o.VesselID = v.VesselID;

-- 2. LEFT JOIN: Show all operations and weapons used (if any)
SELECT o.OperationName, w.WeaponName
FROM Naval_Operations o
LEFT JOIN Weapon_Systems w ON o.WeaponID = w.WeaponID;

-- 3. RIGHT JOIN: Show all weapons and their operations
SELECT o.OperationName, w.WeaponName
FROM Naval_Operations o
RIGHT JOIN Weapon_Systems w ON o.WeaponID = w.WeaponID;

-- 4. FULL JOIN (simulate): Show operations and assigned vessels
SELECT o.OperationName, v.VesselName
FROM Naval_Operations o
LEFT JOIN Naval_Vessels v ON o.VesselID = v.VesselID
UNION
SELECT o.OperationName, v.VesselName
FROM Naval_Operations o
RIGHT JOIN Naval_Vessels v ON o.VesselID = v.VesselID;

-- 5. Non-Correlated Subquery: Operations longer than avg duration
SELECT OperationName, DurationDays
FROM Naval_Operations
WHERE DurationDays > (SELECT AVG(DurationDays) FROM Naval_Operations);

-- 6. Correlated Subquery: Operations longer than avg duration of same type
SELECT o1.OperationName, o1.DurationDays
FROM Naval_Operations o1
WHERE o1.DurationDays > (
   SELECT AVG(o2.DurationDays)
   FROM Naval_Operations o2
   WHERE o2.OperationType = o1.OperationType
);

-- 7. Aggregate: Count operations by type
SELECT OperationType, COUNT(*) AS TotalOps
FROM Naval_Operations
GROUP BY OperationType;

-- 8. Aggregate: Max & min duration per type
SELECT OperationType, MAX(DurationDays) AS Longest, MIN(DurationDays) AS Shortest
FROM Naval_Operations
GROUP BY OperationType;

-- 9. Built-in Function: Uppercase operation names
SELECT UPPER(OperationName) AS OperationName_Upper
FROM Naval_Operations;

-- 10. Date Function: Operations conducted in last 5 years
SELECT OperationName, OperationDate
FROM Naval_Operations
WHERE YEAR(CURDATE()) - YEAR(OperationDate) <= 5;

-- 11. CONCAT Function: Operation code + name
SELECT CONCAT(OperationCode, '-', OperationName) AS FullOperation
FROM Naval_Operations;

-- 12. Subquery with IN: Operations involving vessels stationed at 'Visakhapatnam Base'
SELECT OperationName
FROM Naval_Operations
WHERE VesselID IN (
   SELECT VesselID
   FROM Naval_Vessels
   WHERE BaseID = (SELECT BaseID FROM Naval_Bases WHERE BaseName = 'Visakhapatnam Base')
);

-- 13. JOIN with Missions: Operations linked to missions
SELECT m.MissionName, o.OperationName
FROM Missions m
JOIN Naval_Operations o ON m.OperationID = o.OperationID;

-- 14. JOIN with Training_Programs: Operations used in training
SELECT t.ProgramName, o.OperationName
FROM Training_Programs t
JOIN Naval_Operations o ON t.OperationID = o.OperationID;

-- 15. HAVING clause: Operation types with avg duration > 30 days
SELECT OperationType, AVG(DurationDays) AS AvgDuration
FROM Naval_Operations
GROUP BY OperationType
HAVING AVG(DurationDays) > 30;

-- 16. EXISTS: Operations with at least one assigned weapon
SELECT OperationName
FROM Naval_Operations o
WHERE EXISTS (SELECT 1 FROM Weapon_Systems w WHERE w.WeaponID = o.WeaponID);

-- 17. NOT EXISTS: Operations without assigned weapons
SELECT OperationName
FROM Naval_Operations o
WHERE NOT EXISTS (SELECT 1 FROM Weapon_Systems w WHERE w.WeaponID = o.WeaponID);

-- 18. Self-Join: Compare operations of same type
SELECT o1.OperationName AS Operation1, o2.OperationName AS Operation2, o1.OperationType
FROM Naval_Operations o1
JOIN Naval_Operations o2
  ON o1.OperationType = o2.OperationType AND o1.OperationID <> o2.OperationID;

-- 19. User-Defined Function Example (fn_OperationAge)
SELECT OperationName, fn_OperationAge(OperationDate) AS OperationYears
FROM Naval_Operations;

-- 20. CASE Statement: Categorize operations by duration
SELECT OperationName,
   CASE 
     WHEN DurationDays < 10 THEN 'Short'
     WHEN DurationDays BETWEEN 10 AND 30 THEN 'Medium'
     ELSE 'Long'
   END AS OperationCategory
FROM Naval_Operations;

-- 1. INNER JOIN: List missions with their assigned vessels
SELECT m.MissionID, m.MissionName, v.VesselName
FROM Missions m
INNER JOIN Naval_Vessels v ON m.VesselID = v.VesselID;

-- 2. LEFT JOIN: Show all missions and linked operations (if any)
SELECT m.MissionName, o.OperationName
FROM Missions m
LEFT JOIN Naval_Operations o ON m.OperationID = o.OperationID;

-- 3. RIGHT JOIN: Show all operations and their missions
SELECT m.MissionName, o.OperationName
FROM Missions m
RIGHT JOIN Naval_Operations o ON m.OperationID = o.OperationID;

-- 4. FULL JOIN (simulate): Missions and operations
SELECT m.MissionName, o.OperationName
FROM Missions m
LEFT JOIN Naval_Operations o ON m.OperationID = o.OperationID
UNION
SELECT m.MissionName, o.OperationName
FROM Missions m
RIGHT JOIN Naval_Operations o ON m.OperationID = o.OperationID;

-- 5. Non-Correlated Subquery: Missions longer than avg duration
SELECT MissionName, DurationDays
FROM Missions
WHERE DurationDays > (SELECT AVG(DurationDays) FROM Missions);

-- 6. Correlated Subquery: Missions longer than avg duration of same category
SELECT m1.MissionName, m1.DurationDays
FROM Missions m1
WHERE m1.DurationDays > (
   SELECT AVG(m2.DurationDays)
   FROM Missions m2
   WHERE m2.MissionType = m1.MissionType
);

-- 7. Aggregate: Count missions by type
SELECT MissionType, COUNT(*) AS TotalMissions
FROM Missions
GROUP BY MissionType;

-- 8. Aggregate: Max & min duration per mission type
SELECT MissionType, MAX(DurationDays) AS Longest, MIN(DurationDays) AS Shortest
FROM Missions
GROUP BY MissionType;

-- 9. Built-in Function: Uppercase mission names
SELECT UPPER(MissionName) AS MissionName_Upper
FROM Missions;

-- 10. Date Function: Missions in last 3 years
SELECT MissionName, StartDate
FROM Missions
WHERE YEAR(CURDATE()) - YEAR(StartDate) <= 3;

-- 11. CONCAT Function: Mission code + name
SELECT CONCAT(MissionCode, '-', MissionName) AS FullMission
FROM Missions;

-- 12. Subquery with IN: Missions assigned to vessels at 'Kochi Base'
SELECT MissionName
FROM Missions
WHERE VesselID IN (
   SELECT VesselID
   FROM Naval_Vessels
   WHERE BaseID = (SELECT BaseID FROM Naval_Bases WHERE BaseName = 'Kochi Base')
);

-- 13. JOIN with Weapon_Systems: Weapons assigned in missions
SELECT m.MissionName, w.WeaponName
FROM Missions m
JOIN Weapon_Systems w ON m.WeaponID = w.WeaponID;

-- 14. JOIN with Training_Programs: Training programs linked with missions
SELECT t.ProgramName, m.MissionName
FROM Training_Programs t
JOIN Missions m ON t.MissionID = m.MissionID;

-- 15. HAVING clause: Mission types with avg duration > 20 days
SELECT MissionType, AVG(DurationDays) AS AvgDuration
FROM Missions
GROUP BY MissionType
HAVING AVG(DurationDays) > 20;

-- 16. EXISTS: Missions that used at least one weapon
SELECT MissionName
FROM Missions m
WHERE EXISTS (SELECT 1 FROM Weapon_Systems w WHERE w.WeaponID = m.WeaponID);

-- 17. NOT EXISTS: Missions without any assigned weapon
SELECT MissionName
FROM Missions m
WHERE NOT EXISTS (SELECT 1 FROM Weapon_Systems w WHERE w.WeaponID = m.WeaponID);

-- 18. Self-Join: Compare missions of same type
SELECT m1.MissionName AS Mission1, m2.MissionName AS Mission2, m1.MissionType
FROM Missions m1
JOIN Missions m2
  ON m1.MissionType = m2.MissionType AND m1.MissionID <> m2.MissionID;

-- 19. User-Defined Function Example (fn_MissionAge)
SELECT MissionName, fn_MissionAge(StartDate) AS MissionYears
FROM Missions;

-- 20. CASE Statement: Categorize missions by duration
SELECT MissionName,
   CASE 
     WHEN DurationDays < 7 THEN 'Short'
     WHEN DurationDays BETWEEN 7 AND 21 THEN 'Medium'
     ELSE 'Long'
   END AS MissionCategory
FROM Missions;

-- 1. INNER JOIN: List bases with the vessels stationed there
SELECT b.BaseID, b.BaseName, v.VesselName
FROM Naval_Bases b
INNER JOIN Naval_Vessels v ON b.BaseID = v.BaseID;

-- 2. LEFT JOIN: Show all bases and their training programs (if any)
SELECT b.BaseName, t.ProgramName
FROM Naval_Bases b
LEFT JOIN Training_Programs t ON b.BaseID = t.BaseID;

-- 3. RIGHT JOIN: Show training programs and their bases
SELECT b.BaseName, t.ProgramName
FROM Naval_Bases b
RIGHT JOIN Training_Programs t ON b.BaseID = t.BaseID;

-- 4. FULL JOIN (simulate): Bases and training programs
SELECT b.BaseName, t.ProgramName
FROM Naval_Bases b
LEFT JOIN Training_Programs t ON b.BaseID = t.BaseID
UNION
SELECT b.BaseName, t.ProgramName
FROM Naval_Bases b
RIGHT JOIN Training_Programs t ON b.BaseID = t.BaseID;

-- 5. Non-Correlated Subquery: Bases with capacity above avg
SELECT BaseName, Capacity
FROM Naval_Bases
WHERE Capacity > (SELECT AVG(Capacity) FROM Naval_Bases);

-- 6. Correlated Subquery: Bases with more vessels than avg for same region
SELECT b1.BaseName, b1.Capacity
FROM Naval_Bases b1
WHERE b1.Capacity > (
   SELECT AVG(b2.Capacity)
   FROM Naval_Bases b2
   WHERE b2.Region = b1.Region
);

-- 7. Aggregate: Count bases by region
SELECT Region, COUNT(*) AS TotalBases
FROM Naval_Bases
GROUP BY Region;

-- 8. Aggregate: Max and min capacity by region
SELECT Region, MAX(Capacity) AS MaxCap, MIN(Capacity) AS MinCap
FROM Naval_Bases
GROUP BY Region;

-- 9. Built-in Function: Uppercase base names
SELECT UPPER(BaseName) AS BaseName_Upper
FROM Naval_Bases;

-- 10. Date Function: Bases established before 1980
SELECT BaseName, EstablishedDate
FROM Naval_Bases
WHERE YEAR(EstablishedDate) < 1980;

-- 11. CONCAT Function: Base code + name
SELECT CONCAT(BaseCode, '-', BaseName) AS FullBase
FROM Naval_Bases;

-- 12. Subquery with IN: Bases hosting vessels with displacement > 8000
SELECT BaseName
FROM Naval_Bases
WHERE BaseID IN (
   SELECT BaseID
   FROM Naval_Vessels
   WHERE Displacement > 8000
);

-- 13. JOIN with Operations: Bases supporting operations
SELECT o.OperationName, b.BaseName
FROM Naval_Operations o
JOIN Naval_Bases b ON o.BaseID = b.BaseID;

-- 14. JOIN with Missions: Missions starting from each base
SELECT m.MissionName, b.BaseName
FROM Missions m
JOIN Naval_Bases b ON m.BaseID = b.BaseID;

-- 15. HAVING clause: Regions with avg base capacity > 10,000
SELECT Region, AVG(Capacity) AS AvgCapacity
FROM Naval_Bases
GROUP BY Region
HAVING AVG(Capacity) > 10000;

-- 16. EXISTS: Bases with at least one vessel stationed
SELECT BaseName
FROM Naval_Bases b
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.BaseID = b.BaseID);

-- 17. NOT EXISTS: Bases without vessels
SELECT BaseName
FROM Naval_Bases b
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.BaseID = b.BaseID);

-- 18. Self-Join: Compare bases in the same region
SELECT b1.BaseName AS Base1, b2.BaseName AS Base2, b1.Region
FROM Naval_Bases b1
JOIN Naval_Bases b2
  ON b1.Region = b2.Region AND b1.BaseID <> b2.BaseID;

-- 19. User-Defined Function Example (fn_BaseAge)
SELECT BaseName, fn_BaseAge(EstablishedDate) AS BaseAge
FROM Naval_Bases;

-- 20. CASE Statement: Categorize bases by capacity
SELECT BaseName,
   CASE 
     WHEN Capacity < 5000 THEN 'Small'
     WHEN Capacity BETWEEN 5000 AND 15000 THEN 'Medium'
     ELSE 'Large'
   END AS BaseCategory
FROM Naval_Bases;

-- 1. INNER JOIN: Training programs with their base locations
SELECT t.ProgramID, t.ProgramName, b.BaseName
FROM Training_Programs t
INNER JOIN Naval_Bases b ON t.BaseID = b.BaseID;

-- 2. LEFT JOIN: Show all training programs and linked missions (if any)
SELECT t.ProgramName, m.MissionName
FROM Training_Programs t
LEFT JOIN Missions m ON t.MissionID = m.MissionID;

-- 3. RIGHT JOIN: Show missions and their training programs
SELECT t.ProgramName, m.MissionName
FROM Training_Programs t
RIGHT JOIN Missions m ON t.MissionID = m.MissionID;

-- 4. FULL JOIN (simulate): Training programs and missions
SELECT t.ProgramName, m.MissionName
FROM Training_Programs t
LEFT JOIN Missions m ON t.MissionID = m.MissionID
UNION
SELECT t.ProgramName, m.MissionName
FROM Training_Programs t
RIGHT JOIN Missions m ON t.MissionID = m.MissionID;

-- 5. Non-Correlated Subquery: Programs with duration > avg duration
SELECT ProgramName, DurationDays
FROM Training_Programs
WHERE DurationDays > (SELECT AVG(DurationDays) FROM Training_Programs);

-- 6. Correlated Subquery: Programs longer than avg of same category
SELECT t1.ProgramName, t1.DurationDays
FROM Training_Programs t1
WHERE t1.DurationDays > (
   SELECT AVG(t2.DurationDays)
   FROM Training_Programs t2
   WHERE t2.ProgramType = t1.ProgramType
);

-- 7. Aggregate: Count programs by type
SELECT ProgramType, COUNT(*) AS TotalPrograms
FROM Training_Programs
GROUP BY ProgramType;

-- 8. Aggregate: Min & max duration by program type
SELECT ProgramType, MIN(DurationDays) AS MinDays, MAX(DurationDays) AS MaxDays
FROM Training_Programs
GROUP BY ProgramType;

-- 9. Built-in Function: Uppercase program names
SELECT UPPER(ProgramName) AS ProgramName_Upper
FROM Training_Programs;

-- 10. Date Function: Programs started in the last 2 years
SELECT ProgramName, StartDate
FROM Training_Programs
WHERE YEAR(CURDATE()) - YEAR(StartDate) <= 2;

-- 11. CONCAT Function: Program code + name
SELECT CONCAT(ProgramCode, '-', ProgramName) AS FullProgram
FROM Training_Programs;

-- 12. Subquery with IN: Programs conducted at 'Mumbai Base'
SELECT ProgramName
FROM Training_Programs
WHERE BaseID IN (
   SELECT BaseID FROM Naval_Bases WHERE BaseName = 'Mumbai Base'
);

-- 13. JOIN with Naval_Operations: Programs linked to operations
SELECT t.ProgramName, o.OperationName
FROM Training_Programs t
JOIN Naval_Operations o ON t.OperationID = o.OperationID;

-- 14. JOIN with Naval_Vessels: Vessels used in training
SELECT t.ProgramName, v.VesselName
FROM Training_Programs t
JOIN Naval_Vessels v ON t.VesselID = v.VesselID;

-- 15. HAVING clause: Program types with avg duration > 40 days
SELECT ProgramType, AVG(DurationDays) AS AvgDuration
FROM Training_Programs
GROUP BY ProgramType
HAVING AVG(DurationDays) > 40;

-- 16. EXISTS: Programs associated with missions
SELECT ProgramName
FROM Training_Programs t
WHERE EXISTS (SELECT 1 FROM Missions m WHERE m.MissionID = t.MissionID);

-- 17. NOT EXISTS: Programs without linked missions
SELECT ProgramName
FROM Training_Programs t
WHERE NOT EXISTS (SELECT 1 FROM Missions m WHERE m.MissionID = t.MissionID);

-- 18. Self-Join: Compare programs of the same type
SELECT t1.ProgramName AS Program1, t2.ProgramName AS Program2, t1.ProgramType
FROM Training_Programs t1
JOIN Training_Programs t2
  ON t1.ProgramType = t2.ProgramType AND t1.ProgramID <> t2.ProgramID;

-- 19. User-Defined Function Example (fn_ProgramAge)
SELECT ProgramName, fn_ProgramAge(StartDate) AS ProgramAge
FROM Training_Programs;

-- 20. CASE Statement: Categorize training programs by duration
SELECT ProgramName,
   CASE 
     WHEN DurationDays < 15 THEN 'Short-Term'
     WHEN DurationDays BETWEEN 15 AND 45 THEN 'Medium-Term'
     ELSE 'Long-Term'
   END AS ProgramCategory
FROM Training_Programs;

-- 1. INNER JOIN
SELECT c.CourseName, i.InstructorName
FROM Training_Courses c
INNER JOIN Instructors i ON c.InstructorID = i.InstructorID;

-- 2. LEFT JOIN
SELECT c.CourseName, d.DeptName
FROM Training_Courses c
LEFT JOIN Departments d ON c.DepartmentID = d.DepartmentID;

-- 3. RIGHT JOIN
SELECT d.DeptName, c.CourseName
FROM Training_Courses c
RIGHT JOIN Departments d ON c.DepartmentID = d.DepartmentID;

-- 4. FULL JOIN (simulated with UNION)
SELECT c.CourseName, d.DeptName
FROM Training_Courses c
LEFT JOIN Departments d ON c.DepartmentID = d.DepartmentID
UNION
SELECT c.CourseName, d.DeptName
FROM Training_Courses c
RIGHT JOIN Departments d ON c.DepartmentID = d.DepartmentID;

-- 5. JOIN with condition
SELECT c.CourseName, i.InstructorName, c.Duration
FROM Training_Courses c
JOIN Instructors i ON c.InstructorID = i.InstructorID
WHERE c.Duration > 8;

-- 6. Subquery: Capacity above average
SELECT CourseName, Capacity
FROM Training_Courses
WHERE Capacity > (SELECT AVG(Capacity) FROM Training_Courses);

-- 7. Subquery: Instructor with max courses
SELECT InstructorID
FROM Training_Courses
GROUP BY InstructorID
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 8. Correlated subquery
SELECT CourseName
FROM Training_Courses c
WHERE EXISTS (
    SELECT 1 FROM Instructors i
    WHERE i.InstructorID = c.InstructorID
      AND c.StartDate > i.JoiningDate
);

-- 9. Subquery in FROM
SELECT DeptName, TotalCourses
FROM (
    SELECT DepartmentID, COUNT(*) AS TotalCourses
    FROM Training_Courses
    GROUP BY DepartmentID
) t
JOIN Departments d ON t.DepartmentID = d.DepartmentID;

-- 10. Subquery: Earliest start date
SELECT CourseName
FROM Training_Courses
WHERE StartDate = (SELECT MIN(StartDate) FROM Training_Courses);

-- 11. Built-in: Uppercase course names
SELECT UPPER(CourseName) AS CourseName_Upper
FROM Training_Courses;

-- 12. Built-in: Duration in days
SELECT CourseName, DATEDIFF(EndDate, StartDate) AS TotalDays
FROM Training_Courses;

-- 13. Built-in: Rounded average capacity
SELECT ROUND(AVG(Capacity), 0) AS AvgCapacity
FROM Training_Courses;

-- 14. Built-in: Count courses per location
SELECT Location, COUNT(*) AS TotalCourses
FROM Training_Courses
GROUP BY Location;

-- 15. Built-in: Control flow with CASE
SELECT CourseName,
       CASE WHEN Capacity > 40 THEN 'Full' ELSE 'Available' END AS StatusFlag
FROM Training_Courses;

-- 16. UDF: Create function for duration in months
CREATE FUNCTION CourseDurationMonths(cid INT)
RETURNS INT
DETERMINISTIC
RETURN (SELECT ROUND(Duration/4,0) FROM Training_Courses WHERE CourseID = cid);

-- 17. Use UDF: Duration in months
SELECT CourseName, CourseDurationMonths(CourseID) AS DurationMonths
FROM Training_Courses;

-- 18. UDF: Create function for course status
CREATE FUNCTION CourseStatus(cid INT)
RETURNS VARCHAR(20)
DETERMINISTIC
RETURN (
   SELECT CASE
       WHEN CURDATE() BETWEEN StartDate AND EndDate THEN 'Ongoing'
       WHEN CURDATE() < StartDate THEN 'Upcoming'
       ELSE 'Completed' END
   FROM Training_Courses WHERE CourseID = cid
);

-- 19. Use UDF: Show status
SELECT CourseName, CourseStatus(CourseID) AS CurrentStatus
FROM Training_Courses;

-- 20. UDF with Join
SELECT c.CourseName, i.InstructorName, CourseStatus(c.CourseID) AS CurrentStatus
FROM Training_Courses c
JOIN Instructors i ON c.InstructorID = i.InstructorID;

/* ==========================
   Phase-3 Queries – Table 15
   Table: Supplies
   ========================== */

-- 1. INNER JOIN: Supplies with bases
SELECT s.SupplyName, b.BaseName
FROM Supplies s
INNER JOIN Naval_Bases b ON s.BaseID = b.BaseID;

-- 2. LEFT JOIN: Supplies with vessels (if assigned)
SELECT s.SupplyName, v.VesselName
FROM Supplies s
LEFT JOIN Naval_Vessels v ON s.VesselID = v.VesselID;

-- 3. RIGHT JOIN: Vessels and their supplies
SELECT v.VesselName, s.SupplyName
FROM Supplies s
RIGHT JOIN Naval_Vessels v ON s.VesselID = v.VesselID;

-- 4. FULL JOIN (simulate with UNION)
SELECT s.SupplyName, b.BaseName
FROM Supplies s
LEFT JOIN Naval_Bases b ON s.BaseID = b.BaseID
UNION
SELECT s.SupplyName, b.BaseName
FROM Supplies s
RIGHT JOIN Naval_Bases b ON s.BaseID = b.BaseID;

-- 5. JOIN with condition: Quantity > 100
SELECT s.SupplyName, s.Quantity
FROM Supplies s
WHERE s.Quantity > 100;

-- 6. Subquery: Supplies with quantity above avg
SELECT SupplyName, Quantity
FROM Supplies
WHERE Quantity > (SELECT AVG(Quantity) FROM Supplies);

-- 7. Correlated Subquery: Supplies expiring sooner than avg in same type
SELECT s1.SupplyName, s1.ExpiryDate
FROM Supplies s1
WHERE s1.ExpiryDate < (
   SELECT AVG(DATEDIFF(s2.ExpiryDate, CURDATE()))
   FROM Supplies s2
   WHERE s2.SupplyType = s1.SupplyType
);

-- 8. Aggregate: Count supplies by type
SELECT SupplyType, COUNT(*) AS TotalSupplies
FROM Supplies
GROUP BY SupplyType;

-- 9. Aggregate: Total quantity per base
SELECT BaseID, SUM(Quantity) AS TotalQuantity
FROM Supplies
GROUP BY BaseID;

-- 10. Built-in: Uppercase supply names
SELECT UPPER(SupplyName) AS SupplyName_Upper
FROM Supplies;

-- 11. Date function: Supplies arriving in last 30 days
SELECT SupplyName, ArrivalDate
FROM Supplies
WHERE ArrivalDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 12. CONCAT function: Supply name + type
SELECT CONCAT(SupplyName, '-', SupplyType) AS FullSupply
FROM Supplies;

-- 13. Subquery with IN: Supplies for vessels with displacement > 8000
SELECT SupplyName
FROM Supplies
WHERE VesselID IN (
   SELECT VesselID FROM Naval_Vessels WHERE Displacement > 8000
);

-- 14. JOIN with Bases and Vessels: Complete supply info
SELECT s.SupplyName, b.BaseName, v.VesselName
FROM Supplies s
LEFT JOIN Naval_Bases b ON s.BaseID = b.BaseID
LEFT JOIN Naval_Vessels v ON s.VesselID = v.VesselID;

-- 15. HAVING clause: Supply types with avg quantity > 50
SELECT SupplyType, AVG(Quantity) AS AvgQuantity
FROM Supplies
GROUP BY SupplyType
HAVING AVG(Quantity) > 50;

-- 16. EXISTS: Supplies assigned to a vessel
SELECT SupplyName
FROM Supplies s
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = s.VesselID);

-- 17. NOT EXISTS: Supplies not assigned to any vessel
SELECT SupplyName
FROM Supplies s
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = s.VesselID);

-- 18. Self-Join: Compare supplies of same type
SELECT s1.SupplyName AS Supply1, s2.SupplyName AS Supply2, s1.SupplyType
FROM Supplies s1
JOIN Supplies s2
  ON s1.SupplyType = s2.SupplyType AND s1.SupplyID <> s2.SupplyID;

-- 19. User-Defined Function Example (fn_SupplyAge)
SELECT SupplyName, fn_SupplyAge(ArrivalDate) AS SupplyAgeDays
FROM Supplies;

-- 20. CASE Statement: Categorize supplies by quantity
SELECT SupplyName,
   CASE
     WHEN Quantity < 50 THEN 'Low'
     WHEN Quantity BETWEEN 50 AND 150 THEN 'Medium'
     ELSE 'High'
   END AS QuantityCategory
FROM Supplies;

/* ==========================
   Phase-3 Queries – Table 16
   Table: Weapon_Systems
   ========================== */

-- 1. INNER JOIN: Weapon with vessel assigned
SELECT w.WeaponName, v.VesselName
FROM Weapon_Systems w
INNER JOIN Naval_Vessels v ON w.VesselID = v.VesselID;

-- 2. LEFT JOIN: Weapon with base
SELECT w.WeaponName, b.BaseName
FROM Weapon_Systems w
LEFT JOIN Naval_Bases b ON w.BaseID = b.BaseID;

-- 3. RIGHT JOIN: Bases and weapons (if any)
SELECT b.BaseName, w.WeaponName
FROM Weapon_Systems w
RIGHT JOIN Naval_Bases b ON w.BaseID = b.BaseID;

-- 4. FULL JOIN (simulate with UNION)
SELECT w.WeaponName, b.BaseName
FROM Weapon_Systems w
LEFT JOIN Naval_Bases b ON w.BaseID = b.BaseID
UNION
SELECT w.WeaponName, b.BaseName
FROM Weapon_Systems w
RIGHT JOIN Naval_Bases b ON w.BaseID = b.BaseID;

-- 5. JOIN with condition: Range > 10 km
SELECT WeaponName, RangeKm
FROM Weapon_Systems
WHERE RangeKm > 10;

-- 6. Subquery: Weapons with range above average
SELECT WeaponName, RangeKm
FROM Weapon_Systems
WHERE RangeKm > (SELECT AVG(RangeKm) FROM Weapon_Systems);

-- 7. Correlated Subquery: Weapons with caliber > avg of same type
SELECT w1.WeaponName, w1.Caliber
FROM Weapon_Systems w1
WHERE w1.Caliber > (
   SELECT AVG(w2.Caliber)
   FROM Weapon_Systems w2
   WHERE w2.WeaponType = w1.WeaponType
);

-- 8. Aggregate: Count weapons by type
SELECT WeaponType, COUNT(*) AS TotalWeapons
FROM Weapon_Systems
GROUP BY WeaponType;

-- 9. Aggregate: Max & min range per type
SELECT WeaponType, MAX(RangeKm) AS MaxRange, MIN(RangeKm) AS MinRange
FROM Weapon_Systems
GROUP BY WeaponType;

-- 10. Built-in: Uppercase weapon names
SELECT UPPER(WeaponName) AS WeaponName_Upper
FROM Weapon_Systems;

-- 11. Date function: Weapons manufactured before 2015
SELECT WeaponName, ManufactureDate
FROM Weapon_Systems
WHERE YEAR(ManufactureDate) < 2015;

-- 12. CONCAT function: Weapon name + type
SELECT CONCAT(WeaponName, '-', WeaponType) AS FullWeapon
FROM Weapon_Systems;

-- 13. Subquery with IN: Weapons on vessels with displacement > 8000
SELECT WeaponName
FROM Weapon_Systems
WHERE VesselID IN (
   SELECT VesselID FROM Naval_Vessels WHERE Displacement > 8000
);

-- 14. JOIN with Bases and Vessels: Complete weapon info
SELECT w.WeaponName, b.BaseName, v.VesselName
FROM Weapon_Systems w
LEFT JOIN Naval_Bases b ON w.BaseID = b.BaseID
LEFT JOIN Naval_Vessels v ON w.VesselID = v.VesselID;

-- 15. HAVING clause: Weapon types with avg range > 15 km
SELECT WeaponType, AVG(RangeKm) AS AvgRange
FROM Weapon_Systems
GROUP BY WeaponType
HAVING AVG(RangeKm) > 15;

-- 16. EXISTS: Weapons assigned to vessels
SELECT WeaponName
FROM Weapon_Systems w
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = w.VesselID);

-- 17. NOT EXISTS: Weapons not assigned to any vessel
SELECT WeaponName
FROM Weapon_Systems w
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = w.VesselID);

-- 18. Self-Join: Compare weapons of same type
SELECT w1.WeaponName AS Weapon1, w2.WeaponName AS Weapon2, w1.WeaponType
FROM Weapon_Systems w1
JOIN Weapon_Systems w2
  ON w1.WeaponType = w2.WeaponType AND w1.WeaponID <> w2.WeaponID;

-- 19. User-Defined Function (fn_WeaponAge)
SELECT WeaponName, fn_WeaponAge(ManufactureDate) AS WeaponAgeYears
FROM Weapon_Systems;

-- 20. CASE Statement: Categorize weapons by range
SELECT WeaponName,
   CASE
     WHEN RangeKm < 5 THEN 'Short'
     WHEN RangeKm BETWEEN 5 AND 15 THEN 'Medium'
     ELSE 'Long'
   END AS RangeCategory
FROM Weapon_Systems;

/* ==========================
   Phase-3 Queries – Table 17
   Table: Naval_Projects
   ========================== */

-- 1. INNER JOIN: Projects with bases
SELECT p.ProjectName, b.BaseName
FROM Naval_Projects p
INNER JOIN Naval_Bases b ON p.BaseID = b.BaseID;

-- 2. LEFT JOIN: Projects with department
SELECT p.ProjectName, d.DeptName
FROM Naval_Projects p
LEFT JOIN Departments d ON p.DepartmentID = d.DepartmentID;

-- 3. RIGHT JOIN: Departments and projects
SELECT d.DeptName, p.ProjectName
FROM Naval_Projects p
RIGHT JOIN Departments d ON p.DepartmentID = d.DepartmentID;

-- 4. FULL JOIN (simulate with UNION)
SELECT p.ProjectName, d.DeptName
FROM Naval_Projects p
LEFT JOIN Departments d ON p.DepartmentID = d.DepartmentID
UNION
SELECT p.ProjectName, d.DeptName
FROM Naval_Projects p
RIGHT JOIN Departments d ON p.DepartmentID = d.DepartmentID;

-- 5. JOIN with condition: Budget > 5000000
SELECT ProjectName, Budget
FROM Naval_Projects
WHERE Budget > 5000000;

-- 6. Subquery: Projects with budget above avg
SELECT ProjectName, Budget
FROM Naval_Projects
WHERE Budget > (SELECT AVG(Budget) FROM Naval_Projects);

-- 7. Correlated Subquery: Projects longer than avg duration in same base
SELECT p1.ProjectName, DATEDIFF(p1.EndDate, p1.StartDate) AS DurationDays
FROM Naval_Projects p1
WHERE DATEDIFF(p1.EndDate, p1.StartDate) > (
    SELECT AVG(DATEDIFF(p2.EndDate, p2.StartDate))
    FROM Naval_Projects p2
    WHERE p2.BaseID = p1.BaseID
);

-- 8. Aggregate: Count projects by status
SELECT Status, COUNT(*) AS TotalProjects
FROM Naval_Projects
GROUP BY Status;

-- 9. Aggregate: Total budget per base
SELECT BaseID, SUM(Budget) AS TotalBudget
FROM Naval_Projects
GROUP BY BaseID;

-- 10. Built-in: Uppercase project names
SELECT UPPER(ProjectName) AS ProjectName_Upper
FROM Naval_Projects;

-- 11. Date function: Projects started in last 3 years
SELECT ProjectName, StartDate
FROM Naval_Projects
WHERE YEAR(CURDATE()) - YEAR(StartDate) <= 3;

-- 12. CONCAT function: Project name + status
SELECT CONCAT(ProjectName, '-', Status) AS ProjectInfo
FROM Naval_Projects;

-- 13. Subquery with IN: Projects in bases with capacity > 10000
SELECT ProjectName
FROM Naval_Projects
WHERE BaseID IN (
    SELECT BaseID FROM Naval_Bases WHERE Capacity > 10000
);

-- 14. JOIN with Personnel: Project manager info
SELECT p.ProjectName, n.Name AS ProjectManager
FROM Naval_Projects p
JOIN Naval_Personnel n ON p.ProjectManagerID = n.PersonnelID;

-- 15. HAVING clause: Bases with avg project budget > 5M
SELECT BaseID, AVG(Budget) AS AvgBudget
FROM Naval_Projects
GROUP BY BaseID
HAVING AVG(Budget) > 5000000;

-- 16. EXISTS: Projects assigned to department
SELECT ProjectName
FROM Naval_Projects p
WHERE EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = p.DepartmentID);

-- 17. NOT EXISTS: Projects not assigned to any department
SELECT ProjectName
FROM Naval_Projects p
WHERE NOT EXISTS (SELECT 1 FROM Departments d WHERE d.DepartmentID = p.DepartmentID);

-- 18. Self-Join: Compare projects in same base
SELECT p1.ProjectName AS Project1, p2.ProjectName AS Project2, p1.BaseID
FROM Naval_Projects p1
JOIN Naval_Projects p2
  ON p1.BaseID = p2.BaseID AND p1.ProjectID <> p2.ProjectID;

-- 19. User-Defined Function (fn_ProjectDuration)
SELECT ProjectName, fn_ProjectDuration(StartDate, EndDate) AS DurationDays
FROM Naval_Projects;

-- 20. CASE Statement: Categorize projects by budget
SELECT ProjectName,
   CASE
     WHEN Budget < 1000000 THEN 'Low'
     WHEN Budget BETWEEN 1000000 AND 5000000 THEN 'Medium'
     ELSE 'High'
   END AS BudgetCategory
FROM Naval_Projects;


/* ==========================
   Phase-3 Queries – Table 18
   Table: Naval_Operations
   ========================== */

-- 1. INNER JOIN: Operations with vessel
SELECT o.OperationName, v.VesselName
FROM Naval_Operations o
INNER JOIN Naval_Vessels v ON o.VesselID = v.VesselID;

-- 2. LEFT JOIN: Operations with base
SELECT o.OperationName, b.BaseName
FROM Naval_Operations o
LEFT JOIN Naval_Bases b ON o.BaseID = b.BaseID;

-- 3. RIGHT JOIN: Bases and operations
SELECT b.BaseName, o.OperationName
FROM Naval_Operations o
RIGHT JOIN Naval_Bases b ON o.BaseID = b.BaseID;

-- 4. FULL JOIN (simulate with UNION)
SELECT o.OperationName, b.BaseName
FROM Naval_Operations o
LEFT JOIN Naval_Bases b ON o.BaseID = b.BaseID
UNION
SELECT o.OperationName, b.BaseName
FROM Naval_Operations o
RIGHT JOIN Naval_Bases b ON o.BaseID = b.BaseID;

-- 5. JOIN with condition: Operations longer than 10 days
SELECT OperationName, DATEDIFF(EndDate, StartDate) AS DurationDays
FROM Naval_Operations
WHERE DATEDIFF(EndDate, StartDate) > 10;

-- 6. Subquery: Operations lasting longer than avg duration
SELECT OperationName, DATEDIFF(EndDate, StartDate) AS DurationDays
FROM Naval_Operations
WHERE DATEDIFF(EndDate, StartDate) > (
    SELECT AVG(DATEDIFF(EndDate, StartDate)) FROM Naval_Operations
);

-- 7. Correlated Subquery: Operations with vessels having displacement > avg
SELECT o.OperationName, o.VesselID
FROM Naval_Operations o
WHERE EXISTS (
    SELECT 1 FROM Naval_Vessels v
    WHERE v.VesselID = o.VesselID AND v.Displacement > (
        SELECT AVG(Displacement) FROM Naval_Vessels
    )
);

-- 8. Aggregate: Count operations by type
SELECT OperationType, COUNT(*) AS TotalOperations
FROM Naval_Operations
GROUP BY OperationType;

-- 9. Aggregate: Max & min duration of operations
SELECT MAX(DATEDIFF(EndDate, StartDate)) AS MaxDuration,
       MIN(DATEDIFF(EndDate, StartDate)) AS MinDuration
FROM Naval_Operations;

-- 10. Built-in: Uppercase operation names
SELECT UPPER(OperationName) AS OperationName_Upper
FROM Naval_Operations;

-- 11. Date function: Operations started in last 2 years
SELECT OperationName, StartDate
FROM Naval_Operations
WHERE YEAR(CURDATE()) - YEAR(StartDate) <= 2;

-- 12. CONCAT function: Operation name + status
SELECT CONCAT(OperationName, '-', Status) AS OperationInfo
FROM Naval_Operations;

-- 13. Subquery with IN: Operations on vessels with displacement > 8000
SELECT OperationName
FROM Naval_Operations
WHERE VesselID IN (
    SELECT VesselID FROM Naval_Vessels WHERE Displacement > 8000
);

-- 14. JOIN with Personnel: Operation commander
SELECT o.OperationName, p.Name AS CommanderName
FROM Naval_Operations o
JOIN Naval_Personnel p ON o.CommanderID = p.PersonnelID;

-- 15. HAVING clause: Operation types with avg duration > 15 days
SELECT OperationType, AVG(DATEDIFF(EndDate, StartDate)) AS AvgDuration
FROM Naval_Operations
GROUP BY OperationType
HAVING AVG(DATEDIFF(EndDate, StartDate)) > 15;

-- 16. EXISTS: Operations with assigned vessel
SELECT OperationName
FROM Naval_Operations o
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = o.VesselID);

-- 17. NOT EXISTS: Operations without assigned vessel
SELECT OperationName
FROM Naval_Operations o
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = o.VesselID);

-- 18. Self-Join: Compare operations on same vessel
SELECT o1.OperationName AS Operation1, o2.OperationName AS Operation2, o1.VesselID
FROM Naval_Operations o1
JOIN Naval_Operations o2
  ON o1.VesselID = o2.VesselID AND o1.OperationID <> o2.OperationID;

-- 19. User-Defined Function (fn_OperationDuration)
SELECT OperationName, fn_OperationDuration(StartDate, EndDate) AS DurationDays
FROM Naval_Operations;

-- 20. CASE Statement: Categorize operations by duration
SELECT OperationName,
   CASE
     WHEN DATEDIFF(EndDate, StartDate) < 5 THEN 'Short'
     WHEN DATEDIFF(EndDate, StartDate) BETWEEN 5 AND 15 THEN 'Medium'
     ELSE 'Long'
   END AS DurationCategory
FROM Naval_Operations;

/* ==========================
   Phase-3 Queries – Table 19
   Table: Vessel_Maintenance
   ========================== */

-- 1. INNER JOIN: Maintenance with vessel
SELECT m.MaintenanceID, v.VesselName
FROM Vessel_Maintenance m
INNER JOIN Naval_Vessels v ON m.VesselID = v.VesselID;

-- 2. LEFT JOIN: Maintenance with base
SELECT m.MaintenanceID, b.BaseName
FROM Vessel_Maintenance m
LEFT JOIN Naval_Bases b ON m.BaseID = b.BaseID;

-- 3. RIGHT JOIN: Bases and maintenance
SELECT b.BaseName, m.MaintenanceID
FROM Vessel_Maintenance m
RIGHT JOIN Naval_Bases b ON m.BaseID = b.BaseID;

-- 4. FULL JOIN (simulate with UNION)
SELECT m.MaintenanceID, b.BaseName
FROM Vessel_Maintenance m
LEFT JOIN Naval_Bases b ON m.BaseID = b.BaseID
UNION
SELECT m.MaintenanceID, b.BaseName
FROM Vessel_Maintenance m
RIGHT JOIN Naval_Bases b ON m.BaseID = b.BaseID;

-- 5. JOIN with condition: Maintenance cost > 50000
SELECT MaintenanceID, Cost
FROM Vessel_Maintenance
WHERE Cost > 50000;

-- 6. Subquery: Maintenance with cost above average
SELECT MaintenanceID, Cost
FROM Vessel_Maintenance
WHERE Cost > (SELECT AVG(Cost) FROM Vessel_Maintenance);

-- 7. Correlated Subquery: Maintenance longer than avg duration per vessel
SELECT m1.MaintenanceID, DATEDIFF(m1.EndDate, m1.StartDate) AS DurationDays
FROM Vessel_Maintenance m1
WHERE DATEDIFF(m1.EndDate, m1.StartDate) > (
    SELECT AVG(DATEDIFF(m2.EndDate, m2.StartDate))
    FROM Vessel_Maintenance m2
    WHERE m2.VesselID = m1.VesselID
);

-- 8. Aggregate: Count maintenance tasks by type
SELECT MaintenanceType, COUNT(*) AS TotalTasks
FROM Vessel_Maintenance
GROUP BY MaintenanceType;

-- 9. Aggregate: Total cost per base
SELECT BaseID, SUM(Cost) AS TotalCost
FROM Vessel_Maintenance
GROUP BY BaseID;

-- 10. Built-in: Uppercase maintenance type
SELECT UPPER(MaintenanceType) AS MaintenanceType_Upper
FROM Vessel_Maintenance;

-- 11. Date function: Maintenance in last 6 months
SELECT MaintenanceID, StartDate
FROM Vessel_Maintenance
WHERE StartDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 12. CONCAT function: Vessel + MaintenanceType
SELECT CONCAT(v.VesselName, '-', m.MaintenanceType) AS MaintenanceInfo
FROM Vessel_Maintenance m
JOIN Naval_Vessels v ON m.VesselID = v.VesselID;

-- 13. Subquery with IN: Maintenance on vessels with displacement > 8000
SELECT MaintenanceID
FROM Vessel_Maintenance
WHERE VesselID IN (
    SELECT VesselID FROM Naval_Vessels WHERE Displacement > 8000
);

-- 14. JOIN with Personnel: Technician info
SELECT m.MaintenanceID, p.Name AS TechnicianName
FROM Vessel_Maintenance m
JOIN Naval_Personnel p ON m.TechnicianID = p.PersonnelID;

-- 15. HAVING clause: Maintenance types with avg cost > 50000
SELECT MaintenanceType, AVG(Cost) AS AvgCost
FROM Vessel_Maintenance
GROUP BY MaintenanceType
HAVING AVG(Cost) > 50000;

-- 16. EXISTS: Maintenance assigned to a vessel
SELECT MaintenanceID
FROM Vessel_Maintenance m
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = m.VesselID);

-- 17. NOT EXISTS: Maintenance not assigned to any vessel
SELECT MaintenanceID
FROM Vessel_Maintenance m
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = m.VesselID);

-- 18. Self-Join: Compare maintenance on same vessel
SELECT m1.MaintenanceID AS Task1, m2.MaintenanceID AS Task2, m1.VesselID
FROM Vessel_Maintenance m1
JOIN Vessel_Maintenance m2
  ON m1.VesselID = m2.VesselID AND m1.MaintenanceID <> m2.MaintenanceID;

-- 19. User-Defined Function (fn_MaintenanceDuration)
SELECT MaintenanceID, fn_MaintenanceDuration(StartDate, EndDate) AS DurationDays
FROM Vessel_Maintenance;

-- 20. CASE Statement: Categorize maintenance by duration
SELECT MaintenanceID,
   CASE
     WHEN DATEDIFF(EndDate, StartDate) < 5 THEN 'Short'
     WHEN DATEDIFF(EndDate, StartDate) BETWEEN 5 AND 15 THEN 'Medium'
     ELSE 'Long'
   END AS DurationCategory
FROM Vessel_Maintenance;

/* ==========================
   Phase-3 Queries – Table 20
   Table: Naval_Exercises
   ========================== */

-- 1. INNER JOIN: Exercises with vessel
SELECT e.ExerciseName, v.VesselName
FROM Naval_Exercises e
INNER JOIN Naval_Vessels v ON e.VesselID = v.VesselID;

-- 2. LEFT JOIN: Exercises with base
SELECT e.ExerciseName, b.BaseName
FROM Naval_Exercises e
LEFT JOIN Naval_Bases b ON e.BaseID = b.BaseID;

-- 3. RIGHT JOIN: Bases and exercises
SELECT b.BaseName, e.ExerciseName
FROM Naval_Exercises e
RIGHT JOIN Naval_Bases b ON e.BaseID = b.BaseID;

-- 4. FULL JOIN (simulate with UNION)
SELECT e.ExerciseName, b.BaseName
FROM Naval_Exercises e
LEFT JOIN Naval_Bases b ON e.BaseID = b.BaseID
UNION
SELECT e.ExerciseName, b.BaseName
FROM Naval_Exercises e
RIGHT JOIN Naval_Bases b ON e.BaseID = b.BaseID;

-- 5. JOIN with condition: Exercises longer than 7 days
SELECT ExerciseName, DATEDIFF(EndDate, StartDate) AS DurationDays
FROM Naval_Exercises
WHERE DATEDIFF(EndDate, StartDate) > 7;

-- 6. Subquery: Exercises longer than avg duration
SELECT ExerciseName, DATEDIFF(EndDate, StartDate) AS DurationDays
FROM Naval_Exercises
WHERE DATEDIFF(EndDate, StartDate) > (
    SELECT AVG(DATEDIFF(EndDate, StartDate)) FROM Naval_Exercises
);

-- 7. Correlated Subquery: Exercises with vessels of displacement > avg
SELECT e.ExerciseName, e.VesselID
FROM Naval_Exercises e
WHERE EXISTS (
    SELECT 1 FROM Naval_Vessels v
    WHERE v.VesselID = e.VesselID AND v.Displacement > (
        SELECT AVG(Displacement) FROM Naval_Vessels
    )
);

-- 8. Aggregate: Count exercises by type
SELECT ExerciseType, COUNT(*) AS TotalExercises
FROM Naval_Exercises
GROUP BY ExerciseType;

-- 9. Aggregate: Max & min duration
SELECT MAX(DATEDIFF(EndDate, StartDate)) AS MaxDuration,
       MIN(DATEDIFF(EndDate, StartDate)) AS MinDuration
FROM Naval_Exercises;

-- 10. Built-in: Uppercase exercise names
SELECT UPPER(ExerciseName) AS ExerciseName_Upper
FROM Naval_Exercises;

-- 11. Date function: Exercises in last 1 year
SELECT ExerciseName, StartDate
FROM Naval_Exercises
WHERE StartDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- 12. CONCAT function: Exercise name + status
SELECT CONCAT(ExerciseName, '-', Status) AS ExerciseInfo
FROM Naval_Exercises;

-- 13. Subquery with IN: Exercises on vessels with displacement > 8000
SELECT ExerciseName
FROM Naval_Exercises
WHERE VesselID IN (
    SELECT VesselID FROM Naval_Vessels WHERE Displacement > 8000
);

-- 14. JOIN with Personnel: Exercise commander info
SELECT e.ExerciseName, p.Name AS CommanderName
FROM Naval_Exercises e
JOIN Naval_Personnel p ON e.CommanderID = p.PersonnelID;

-- 15. HAVING clause: Exercise types with avg duration > 10 days
SELECT ExerciseType, AVG(DATEDIFF(EndDate, StartDate)) AS AvgDuration
FROM Naval_Exercises
GROUP BY ExerciseType
HAVING AVG(DATEDIFF(EndDate, StartDate)) > 10;

-- 16. EXISTS: Exercises with assigned vessel
SELECT ExerciseName
FROM Naval_Exercises e
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = e.VesselID);

-- 17. NOT EXISTS: Exercises without assigned vessel
SELECT ExerciseName
FROM Naval_Exercises e
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = e.VesselID);

-- 18. Self-Join: Compare exercises on same vessel
SELECT e1.ExerciseName AS Exercise1, e2.ExerciseName AS Exercise2, e1.VesselID
FROM Naval_Exercises e1
JOIN Naval_Exercises e2
  ON e1.VesselID = e2.VesselID AND e1.ExerciseID <> e2.ExerciseID;

-- 19. User-Defined Function (fn_ExerciseDuration)
SELECT ExerciseName, fn_ExerciseDuration(StartDate, EndDate) AS DurationDays
FROM Naval_Exercises;

-- 20. CASE Statement: Categorize exercises by duration
SELECT ExerciseName,
   CASE
     WHEN DATEDIFF(EndDate, StartDate) < 5 THEN 'Short'
     WHEN DATEDIFF(EndDate, StartDate) BETWEEN 5 AND 10 THEN 'Medium'
     ELSE 'Long'
   END AS DurationCategory
FROM Naval_Exercises;

/* ==========================
   Phase-3 Queries – Table 21
   Table: Naval_Reports
   ========================== */

-- 1. INNER JOIN: Reports with base
SELECT r.ReportTitle, b.BaseName
FROM Naval_Reports r
INNER JOIN Naval_Bases b ON r.BaseID = b.BaseID;

-- 2. LEFT JOIN: Reports with vessel
SELECT r.ReportTitle, v.VesselName
FROM Naval_Reports r
LEFT JOIN Naval_Vessels v ON r.VesselID = v.VesselID;

-- 3. RIGHT JOIN: Vessels and reports
SELECT v.VesselName, r.ReportTitle
FROM Naval_Reports r
RIGHT JOIN Naval_Vessels v ON r.VesselID = v.VesselID;

-- 4. FULL JOIN (simulate with UNION)
SELECT r.ReportTitle, b.BaseName
FROM Naval_Reports r
LEFT JOIN Naval_Bases b ON r.BaseID = b.BaseID
UNION
SELECT r.ReportTitle, b.BaseName
FROM Naval_Reports r
RIGHT JOIN Naval_Bases b ON r.BaseID = b.BaseID;

-- 5. JOIN with condition: Reports after 2022-01-01
SELECT ReportTitle, ReportDate
FROM Naval_Reports
WHERE ReportDate > '2022-01-01';

-- 6. Subquery: Reports prepared in last 6 months
SELECT ReportTitle, ReportDate
FROM Naval_Reports
WHERE ReportDate > (
    SELECT DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);

-- 7. Correlated Subquery: Reports by personnel with most reports in base
SELECT r1.ReportTitle, r1.PreparedBy
FROM Naval_Reports r1
WHERE r1.PreparedBy = (
    SELECT PreparedBy
    FROM Naval_Reports r2
    WHERE r2.BaseID = r1.BaseID
    GROUP BY PreparedBy
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 8. Aggregate: Count reports by type
SELECT ReportType, COUNT(*) AS TotalReports
FROM Naval_Reports
GROUP BY ReportType;

-- 9. Aggregate: Count reports per base
SELECT BaseID, COUNT(*) AS TotalReports
FROM Naval_Reports
GROUP BY BaseID;

-- 10. Built-in: Uppercase report titles
SELECT UPPER(ReportTitle) AS ReportTitle_Upper
FROM Naval_Reports;

-- 11. Date function: Reports in last year
SELECT ReportTitle, ReportDate
FROM Naval_Reports
WHERE YEAR(ReportDate) = YEAR(CURDATE()) - 1;

-- 12. CONCAT function: Report title + status
SELECT CONCAT(ReportTitle, '-', Status) AS ReportInfo
FROM Naval_Reports;

-- 13. Subquery with IN: Reports for vessels with displacement > 8000
SELECT ReportTitle
FROM Naval_Reports
WHERE VesselID IN (
    SELECT VesselID FROM Naval_Vessels WHERE Displacement > 8000
);

-- 14. JOIN with Personnel: Prepared by
SELECT r.ReportTitle, p.Name AS PreparedByName
FROM Naval_Reports r
JOIN Naval_Personnel p ON r.PreparedBy = p.PersonnelID;

-- 15. HAVING clause: Report types with more than 5 reports
SELECT ReportType, COUNT(*) AS CountReports
FROM Naval_Reports
GROUP BY ReportType
HAVING COUNT(*) > 5;

-- 16. EXISTS: Reports for a vessel
SELECT ReportTitle
FROM Naval_Reports r
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = r.VesselID);

-- 17. NOT EXISTS: Reports without any vessel assigned
SELECT ReportTitle
FROM Naval_Reports r
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = r.VesselID);

-- 18. Self-Join: Compare reports from same base
SELECT r1.ReportTitle AS Report1, r2.ReportTitle AS Report2, r1.BaseID
FROM Naval_Reports r1
JOIN Naval_Reports r2
  ON r1.BaseID = r2.BaseID AND r1.ReportID <> r2.ReportID;

-- 19. User-Defined Function (fn_ReportAge)
SELECT ReportTitle, fn_ReportAge(ReportDate) AS DaysOld
FROM Naval_Reports;

-- 20. CASE Statement: Categorize reports by status
SELECT ReportTitle,
   CASE
     WHEN Status = 'Pending' THEN 'Pending'
     WHEN Status = 'Reviewed' THEN 'Reviewed'
     ELSE 'Completed'
   END AS StatusCategory
FROM Naval_Reports;


/* ==========================
   Phase-3 Queries – Table 22
   Table: Naval_Training
   ========================== */

-- 1. INNER JOIN: Training with personnel
SELECT t.TrainingName, p.Name AS Trainee
FROM Naval_Training t
INNER JOIN Naval_Personnel p ON t.PersonnelID = p.PersonnelID;

-- 2. LEFT JOIN: Training with base
SELECT t.TrainingName, b.BaseName
FROM Naval_Training t
LEFT JOIN Naval_Bases b ON t.BaseID = b.BaseID;

-- 3. RIGHT JOIN: Bases and training
SELECT b.BaseName, t.TrainingName
FROM Naval_Training t
RIGHT JOIN Naval_Bases b ON t.BaseID = b.BaseID;

-- 4. FULL JOIN (simulate with UNION)
SELECT t.TrainingName, b.BaseName
FROM Naval_Training t
LEFT JOIN Naval_Bases b ON t.BaseID = b.BaseID
UNION
SELECT t.TrainingName, b.BaseName
FROM Naval_Training t
RIGHT JOIN Naval_Bases b ON t.BaseID = b.BaseID;

-- 5. JOIN with condition: Training duration > 10 days
SELECT TrainingName, DATEDIFF(EndDate, StartDate) AS DurationDays
FROM Naval_Training
WHERE DATEDIFF(EndDate, StartDate) > 10;

-- 6. Subquery: Training longer than avg duration
SELECT TrainingName, DATEDIFF(EndDate, StartDate) AS DurationDays
FROM Naval_Training
WHERE DATEDIFF(EndDate, StartDate) > (
    SELECT AVG(DATEDIFF(EndDate, StartDate)) FROM Naval_Training
);

-- 7. Correlated Subquery: Training for personnel with most trainings in base
SELECT t1.TrainingName, t1.PersonnelID
FROM Naval_Training t1
WHERE t1.PersonnelID = (
    SELECT PersonnelID
    FROM Naval_Training t2
    WHERE t2.BaseID = t1.BaseID
    GROUP BY PersonnelID
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 8. Aggregate: Count trainings by type
SELECT TrainingType, COUNT(*) AS TotalTrainings
FROM Naval_Training
GROUP BY TrainingType;

-- 9. Aggregate: Total training days per base
SELECT BaseID, SUM(DATEDIFF(EndDate, StartDate)) AS TotalTrainingDays
FROM Naval_Training
GROUP BY BaseID;

-- 10. Built-in: Uppercase training names
SELECT UPPER(TrainingName) AS TrainingName_Upper
FROM Naval_Training;

-- 11. Date function: Trainings in last 1 year
SELECT TrainingName, StartDate
FROM Naval_Training
WHERE StartDate >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- 12. CONCAT function: Training name + status
SELECT CONCAT(TrainingName, '-', Status) AS TrainingInfo
FROM Naval_Training;

-- 13. Subquery with IN: Training for personnel in specific department
SELECT TrainingName
FROM Naval_Training
WHERE PersonnelID IN (
    SELECT PersonnelID FROM Naval_Personnel WHERE DepartmentID = 2
);

-- 14. JOIN with Instructor info
SELECT t.TrainingName, i.Name AS InstructorName
FROM Naval_Training t
JOIN Naval_Personnel i ON t.InstructorID = i.PersonnelID;

-- 15. HAVING clause: Training types with avg duration > 15 days
SELECT TrainingType, AVG(DATEDIFF(EndDate, StartDate)) AS AvgDuration
FROM Naval_Training
GROUP BY TrainingType
HAVING AVG(DATEDIFF(EndDate, StartDate)) > 15;

-- 16. EXISTS: Training assigned to personnel
SELECT TrainingName
FROM Naval_Training t
WHERE EXISTS (SELECT 1 FROM Naval_Personnel p WHERE p.PersonnelID = t.PersonnelID);

-- 17. NOT EXISTS: Training without assigned personnel
SELECT TrainingName
FROM Naval_Training t
WHERE NOT EXISTS (SELECT 1 FROM Naval_Personnel p WHERE p.PersonnelID = t.PersonnelID);

-- 18. Self-Join: Compare trainings in same base
SELECT t1.TrainingName AS Training1, t2.TrainingName AS Training2, t1.BaseID
FROM Naval_Training t1
JOIN Naval_Training t2
  ON t1.BaseID = t2.BaseID AND t1.TrainingID <> t2.TrainingID;

-- 19. User-Defined Function (fn_TrainingDuration)
SELECT TrainingName, fn_TrainingDuration(StartDate, EndDate) AS DurationDays
FROM Naval_Training;

-- 20. CASE Statement: Categorize trainings by duration
SELECT TrainingName,
   CASE
     WHEN DATEDIFF(EndDate, StartDate) < 5 THEN 'Short'
     WHEN DATEDIFF(EndDate, StartDate) BETWEEN 5 AND 15 THEN 'Medium'
     ELSE 'Long'
   END AS DurationCategory
FROM Naval_Training;

/* ==========================
   Phase-3 Queries – Table 23
   Table: Naval_Inventory
   ========================== */

-- 1. INNER JOIN: Inventory with base
SELECT i.ItemName, b.BaseName
FROM Naval_Inventory i
INNER JOIN Naval_Bases b ON i.BaseID = b.BaseID;

-- 2. LEFT JOIN: Inventory with vessel
SELECT i.ItemName, v.VesselName
FROM Naval_Inventory i
LEFT JOIN Naval_Vessels v ON i.VesselID = v.VesselID;

-- 3. RIGHT JOIN: Vessels and inventory
SELECT v.VesselName, i.ItemName
FROM Naval_Inventory i
RIGHT JOIN Naval_Vessels v ON i.VesselID = v.VesselID;

-- 4. FULL JOIN (simulate with UNION)
SELECT i.ItemName, b.BaseName
FROM Naval_Inventory i
LEFT JOIN Naval_Bases b ON i.BaseID = b.BaseID
UNION
SELECT i.ItemName, b.BaseName
FROM Naval_Inventory i
RIGHT JOIN Naval_Bases b ON i.BaseID = b.BaseID;

-- 5. JOIN with condition: Quantity < 50
SELECT ItemName, Quantity
FROM Naval_Inventory
WHERE Quantity < 50;

-- 6. Subquery: Items with quantity above average
SELECT ItemName, Quantity
FROM Naval_Inventory
WHERE Quantity > (SELECT AVG(Quantity) FROM Naval_Inventory);

-- 7. Correlated Subquery: Items with unit price above avg in same type
SELECT i1.ItemName, i1.UnitPrice
FROM Naval_Inventory i1
WHERE i1.UnitPrice > (
    SELECT AVG(i2.UnitPrice)
    FROM Naval_Inventory i2
    WHERE i2.ItemType = i1.ItemType
);

-- 8. Aggregate: Count items by type
SELECT ItemType, COUNT(*) AS TotalItems
FROM Naval_Inventory
GROUP BY ItemType;

-- 9. Aggregate: Total inventory value per base
SELECT BaseID, SUM(Quantity * UnitPrice) AS TotalValue
FROM Naval_Inventory
GROUP BY BaseID;

-- 10. Built-in: Uppercase item names
SELECT UPPER(ItemName) AS ItemName_Upper
FROM Naval_Inventory;

-- 11. Date function: Items received in last 6 months
SELECT ItemName, ReceivedDate
FROM Naval_Inventory
WHERE ReceivedDate >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 12. CONCAT function: Item name + status
SELECT CONCAT(ItemName, '-', Status) AS ItemInfo
FROM Naval_Inventory;

-- 13. Subquery with IN: Items for vessels with displacement > 8000
SELECT ItemName
FROM Naval_Inventory
WHERE VesselID IN (
    SELECT VesselID FROM Naval_Vessels WHERE Displacement > 8000
);

-- 14. JOIN with Base and Vessel names
SELECT i.ItemName, b.BaseName, v.VesselName
FROM Naval_Inventory i
LEFT JOIN Naval_Bases b ON i.BaseID = b.BaseID
LEFT JOIN Naval_Vessels v ON i.VesselID = v.VesselID;

-- 15. HAVING clause: Item types with avg quantity > 100
SELECT ItemType, AVG(Quantity) AS AvgQuantity
FROM Naval_Inventory
GROUP BY ItemType
HAVING AVG(Quantity) > 100;

-- 16. EXISTS: Items assigned to a vessel
SELECT ItemName
FROM Naval_Inventory i
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = i.VesselID);

-- 17. NOT EXISTS: Items not assigned to any vessel
SELECT ItemName
FROM Naval_Inventory i
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = i.VesselID);

-- 18. Self-Join: Compare items in same base
SELECT i1.ItemName AS Item1, i2.ItemName AS Item2, i1.BaseID
FROM Naval_Inventory i1
JOIN Naval_Inventory i2
  ON i1.BaseID = i2.BaseID AND i1.InventoryID <> i2.InventoryID;

-- 19. User-Defined Function (fn_InventoryValue)
SELECT ItemName, fn_InventoryValue(Quantity, UnitPrice) AS TotalValue
FROM Naval_Inventory;

-- 20. CASE Statement: Categorize items by quantity
SELECT ItemName,
   CASE
     WHEN Quantity < 50 THEN 'Low'
     WHEN Quantity BETWEEN 50 AND 150 THEN 'Medium'
     ELSE 'High'
   END AS QuantityCategory
FROM Naval_Inventory;

/* ==========================
   Phase-3 Queries – Table 24
   Table: Naval_Fuel_Logs
   ========================== */

-- 1. INNER JOIN: Fuel logs with vessel
SELECT f.FuelLogID, v.VesselName
FROM Naval_Fuel_Logs f
INNER JOIN Naval_Vessels v ON f.VesselID = v.VesselID;

-- 2. LEFT JOIN: Fuel logs with base
SELECT f.FuelLogID, b.BaseName
FROM Naval_Fuel_Logs f
LEFT JOIN Naval_Bases b ON f.BaseID = b.BaseID;

-- 3. RIGHT JOIN: Bases and fuel logs
SELECT b.BaseName, f.FuelLogID
FROM Naval_Fuel_Logs f
RIGHT JOIN Naval_Bases b ON f.BaseID = b.BaseID;

-- 4. FULL JOIN (simulate with UNION)
SELECT f.FuelLogID, b.BaseName
FROM Naval_Fuel_Logs f
LEFT JOIN Naval_Bases b ON f.BaseID = b.BaseID
UNION
SELECT f.FuelLogID, b.BaseName
FROM Naval_Fuel_Logs f
RIGHT JOIN Naval_Bases b ON f.BaseID = b.BaseID;

-- 5. JOIN with condition: Quantity > 5000 liters
SELECT FuelLogID, Quantity
FROM Naval_Fuel_Logs
WHERE Quantity > 5000;

-- 6. Subquery: Logs with unit price above average
SELECT FuelLogID, UnitPrice
FROM Naval_Fuel_Logs
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Naval_Fuel_Logs);

-- 7. Correlated Subquery: Logs with quantity above avg per fuel type
SELECT f1.FuelLogID, f1.Quantity
FROM Naval_Fuel_Logs f1
WHERE f1.Quantity > (
    SELECT AVG(f2.Quantity)
    FROM Naval_Fuel_Logs f2
    WHERE f2.FuelType = f1.FuelType
);

-- 8. Aggregate: Count fuel logs by fuel type
SELECT FuelType, COUNT(*) AS TotalLogs
FROM Naval_Fuel_Logs
GROUP BY FuelType;

-- 9. Aggregate: Total fuel quantity per base
SELECT BaseID, SUM(Quantity) AS TotalFuel
FROM Naval_Fuel_Logs
GROUP BY BaseID;

-- 10. Built-in: Uppercase fuel type
SELECT UPPER(FuelType) AS FuelType_Upper
FROM Naval_Fuel_Logs;

-- 11. Date function: Logs in last 3 months
SELECT FuelLogID, RefuelDate
FROM Naval_Fuel_Logs
WHERE RefuelDate >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH);

-- 12. CONCAT function: Vessel + fuel type
SELECT CONCAT(v.VesselName, '-', f.FuelType) AS FuelInfo
FROM Naval_Fuel_Logs f
JOIN Naval_Vessels v ON f.VesselID = v.VesselID;

-- 13. Subquery with IN: Logs for vessels with displacement > 8000
SELECT FuelLogID
FROM Naval_Fuel_Logs
WHERE VesselID IN (
    SELECT VesselID FROM Naval_Vessels WHERE Displacement > 8000
);

-- 14. JOIN with Personnel: Technician info
SELECT f.FuelLogID, p.Name AS TechnicianName
FROM Naval_Fuel_Logs f
JOIN Naval_Personnel p ON f.TechnicianID = p.PersonnelID;

-- 15. HAVING clause: Fuel types with avg quantity > 4000
SELECT FuelType, AVG(Quantity) AS AvgQuantity
FROM Naval_Fuel_Logs
GROUP BY FuelType
HAVING AVG(Quantity) > 4000;

-- 16. EXISTS: Logs for a vessel
SELECT FuelLogID
FROM Naval_Fuel_Logs f
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = f.VesselID);

-- 17. NOT EXISTS: Logs without assigned vessel
SELECT FuelLogID
FROM Naval_Fuel_Logs f
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = f.VesselID);

-- 18. Self-Join: Compare fuel logs for same vessel
SELECT f1.FuelLogID AS Log1, f2.FuelLogID AS Log2, f1.VesselID
FROM Naval_Fuel_Logs f1
JOIN Naval_Fuel_Logs f2
  ON f1.VesselID = f2.VesselID AND f1.FuelLogID <> f2.FuelLogID;

-- 19. User-Defined Function (fn_FuelCost)
SELECT FuelLogID, fn_FuelCost(Quantity, UnitPrice) AS TotalCost
FROM Naval_Fuel_Logs;

-- 20. CASE Statement: Categorize logs by quantity
SELECT FuelLogID,
   CASE
     WHEN Quantity < 1000 THEN 'Low'
     WHEN Quantity BETWEEN 1000 AND 5000 THEN 'Medium'
     ELSE 'High'
   END AS QuantityCategory
FROM Naval_Fuel_Logs;

/* ==========================
   Phase-3 Queries – Table 25
   Table: Naval_Incidents
   ========================== */

-- 1. INNER JOIN: Incidents with vessel
SELECT i.IncidentName, v.VesselName
FROM Naval_Incidents i
INNER JOIN Naval_Vessels v ON i.VesselID = v.VesselID;

-- 2. LEFT JOIN: Incidents with base
SELECT i.IncidentName, b.BaseName
FROM Naval_Incidents i
LEFT JOIN Naval_Bases b ON i.BaseID = b.BaseID;

-- 3. RIGHT JOIN: Bases and incidents
SELECT b.BaseName, i.IncidentName
FROM Naval_Incidents i
RIGHT JOIN Naval_Bases b ON i.BaseID = b.BaseID;

-- 4. FULL JOIN (simulate with UNION)
SELECT i.IncidentName, b.BaseName
FROM Naval_Incidents i
LEFT JOIN Naval_Bases b ON i.BaseID = b.BaseID
UNION
SELECT i.IncidentName, b.BaseName
FROM Naval_Incidents i
RIGHT JOIN Naval_Bases b ON i.BaseID = b.BaseID;

-- 5. JOIN with condition: Severity = 'High'
SELECT IncidentName, Severity
FROM Naval_Incidents
WHERE Severity = 'High';

-- 6. Subquery: Incidents in last 6 months
SELECT IncidentName, IncidentDate
FROM Naval_Incidents
WHERE IncidentDate >= (
    SELECT DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);

-- 7. Correlated Subquery: Incidents reported by personnel with most reports
SELECT i1.IncidentName, i1.ReportedBy
FROM Naval_Incidents i1
WHERE i1.ReportedBy = (
    SELECT ReportedBy
    FROM Naval_Incidents i2
    WHERE i2.BaseID = i1.BaseID
    GROUP BY ReportedBy
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 8. Aggregate: Count incidents by type
SELECT IncidentType, COUNT(*) AS TotalIncidents
FROM Naval_Incidents
GROUP BY IncidentType;

-- 9. Aggregate: Count incidents per base
SELECT BaseID, COUNT(*) AS TotalIncidents
FROM Naval_Incidents
GROUP BY BaseID;

-- 10. Built-in: Uppercase incident names
SELECT UPPER(IncidentName) AS IncidentName_Upper
FROM Naval_Incidents;

-- 11. Date function: Incidents in current year
SELECT IncidentName, IncidentDate
FROM Naval_Incidents
WHERE YEAR(IncidentDate) = YEAR(CURDATE());

-- 12. CONCAT function: Incident name + severity
SELECT CONCAT(IncidentName, '-', Severity) AS IncidentInfo
FROM Naval_Incidents;

-- 13. Subquery with IN: Incidents on vessels with displacement > 8000
SELECT IncidentName
FROM Naval_Incidents
WHERE VesselID IN (
    SELECT VesselID FROM Naval_Vessels WHERE Displacement > 8000
);

-- 14. JOIN with Personnel: Reporter info
SELECT i.IncidentName, p.Name AS ReportedByName
FROM Naval_Incidents i
JOIN Naval_Personnel p ON i.ReportedBy = p.PersonnelID;

-- 15. HAVING clause: Incident types with more than 3 reports
SELECT IncidentType, COUNT(*) AS CountIncidents
FROM Naval_Incidents
GROUP BY IncidentType
HAVING COUNT(*) > 3;

-- 16. EXISTS: Incidents for a vessel
SELECT IncidentName
FROM Naval_Incidents i
WHERE EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = i.VesselID);

-- 17. NOT EXISTS: Incidents without assigned vessel
SELECT IncidentName
FROM Naval_Incidents i
WHERE NOT EXISTS (SELECT 1 FROM Naval_Vessels v WHERE v.VesselID = i.VesselID);

-- 18. Self-Join: Compare incidents in same base
SELECT i1.IncidentName AS Incident1, i2.IncidentName AS Incident2, i1.BaseID
FROM Naval_Incidents i1
JOIN Naval_Incidents i2
  ON i1.BaseID = i2.BaseID AND i1.IncidentID <> i2.IncidentID;

-- 19. User-Defined Function (fn_IncidentAge)
SELECT IncidentName, fn_IncidentAge(IncidentDate) AS DaysOld
FROM Naval_Incidents;

-- 20. CASE Statement: Categorize incidents by severity
SELECT IncidentName,
   CASE
     WHEN Severity = 'Low' THEN 'Low'
     WHEN Severity = 'Medium' THEN 'Medium'
     ELSE 'High'
   END AS SeverityCategory
FROM Naval_Incidents;


