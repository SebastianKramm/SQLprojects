/*

Cleaning Data in SQL queries for Survivor Show Project
--> tribe_table

*/

-- Cleaning tribe_table --

SELECT 
    *
FROM
    survivor.tribe_table;
    
#Checking num_season 
SELECT 
    num_season
FROM
    tribe_table
WHERE
    num_season < 1 OR num_season > 43
        OR num_season IS NULL;

#Checking tribe column: for each season, each tribe can change in its participants several times before the merge
SELECT DISTINCT
    num_season, tribe, iter_num
FROM
    tribe_table;

#Checking iter_num column
SELECT 
    MAX(iter_num), MIN(iter_num), AVG(iter_num)
FROM
    tribe_table;

#Checking num_contestants column
SELECT 
    MAX(num_contestants),
    MIN(num_contestants),
    AVG(num_contestants)
FROM
    tribe_table;

#Checking merge column
SELECT 
    merge
FROM
    tribe_table
WHERE
    merge <> 1 AND merge <> 0;
    
#Checking african_american,asian_american,latin_american,poc,lgbt,jewish,muslim columns
SELECT 
    MAX(african_american),
    MIN(african_american),
    AVG(african_american),
    MAX(asian_american),
    MIN(asian_american),
    AVG(asian_american),
    MAX(latin_american),
    MIN(latin_american),
    AVG(latin_american),
    MAX(poc),
    MIN(poc),
    AVG(poc),
    MAX(lgbt),
    MIN(lgbt),
    AVG(lgbt),
    MAX(jewish),
    MIN(jewish),
    AVG(jewish),
    MAX(muslim),
    MIN(muslim),
    AVG(muslim)
FROM
    tribe_table;
    
#Checking male, female, no_binary columns
SELECT 
    MAX(male),
    MIN(male),
    AVG(male),
    MAX(female),
    MIN(female),
    AVG(female),
    MAX(non_binary),
    MIN(non_binary),
    AVG(non_binary)
FROM
    tribe_table;