/*

Cleaning Data in SQL queries for Survivor Show Project
--> season_table

*/

-- Cleaning season_table --

SELECT 
    *
FROM
    survivor.season_table
;

#Checking season column
SELECT DISTINCT
    season
FROM
    season_table
;
SELECT 
    COUNT(DISTINCT season)
FROM
    season_table;

#Checking merged_tribe column
SELECT 
    COUNT(DISTINCT merged_tribe)
FROM
    season_table;
    
#Checking num_merge column
SELECT 
    MAX(num_merge), MIN(num_merge), AVG(num_merge)
FROM
    season_table;

#Checking day_merge column
SELECT 
    MAX(day_merge), MIN(day_merge), AVG(day_merge)
FROM
    season_table;

#Checking num_jury column
SELECT 
    MAX(num_jury), MIN(num_jury), AVG(num_jury)
FROM
    season_table;

#Checking num_ftc column and num_swaps
SELECT 
    MAX(num_ftc),
    MIN(num_ftc),
    AVG(num_ftc),
    MAX(num_swaps),
    MIN(num_swaps),
    AVG(num_swaps)
FROM
    season_table;

#Checking num_contestans column
SELECT 
    MAX(num_contestants),
    MIN(num_contestants),
    AVG(num_contestants)
FROM
    season_table;
    
#Checking num_days column
SELECT 
    MAX(num_days), MIN(num_days), AVG(num_days)
FROM
    season_table;
    
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
    season_table;
    
#Checking num_quits and num_evacs columns
SELECT 
    MAX(num_quits),
    MIN(num_quits),
    AVG(num_quits),
    MAX(num_evacs),
    MIN(num_evacs),
    AVG(num_evacs)
FROM
    season_table;