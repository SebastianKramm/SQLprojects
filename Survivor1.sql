/*

Cleaning Data in SQL queries for Survivor Show Project
--> Contestant_table

*/

-- Data cleaning Contestant_table

use survivor;
SELECT 
    *
FROM
    contestant_table;
    
#Looking for NULLs in contestant_name column
SELECT 
    *
FROM
    contestant_table
WHERE
    contestant_name IS NULL;
    
#Checking age column: no error nor null values
SELECT 
    *
FROM
   contestant_table
WHERE
    LENGTH(age) <> 2 OR NULL;

#Hometown: I'll remove the "" and the state, as there's a state column already
commit;

SELECT 
    *
FROM
    contestant_table
WHERE
    hometown IS NULL;

SELECT 
    SUBSTR(hometown,
        2,
        LENGTH(hometown) - 7)
FROM
    contestant_table;

UPDATE contestant_table 
SET 
    hometown = SUBSTR(hometown,
        2,
        LENGTH(hometown) - 7);
        
commit;

#Checking for NULL in profession: none

SELECT 
    *
FROM
    contestant_table
WHERE
    profession IS NULL;

#Checking for null and validity in num_season column: none
SELECT 
    *
FROM
    contestant_table
WHERE
    num_season IS NULL;
    
SELECT 
    num_season
FROM
    contestant_table
WHERE
    num_season > 43 OR num_season < 1;

#Checking for null and validity of finish column: all good

SELECT 
    MAX(finish),
    MIN(finish)
FROM
    contestant_table; -- the result was 9, that's when I noticed that all the data types of the columns where set as TEXT and I searched for new ways to import data

SELECT 
    *
FROM
    contestant_table
WHERE
    finish IS NULL;
    
#Gender column checking: all good
SELECT 
    *
FROM
    contestant_table
WHERE
    gender <> 'F' AND 'M';

#Checking minorities columns: values validated
SELECT 
    MAX(african_american),
    MIN(african_american),
    MAX(asian_american),
    MIN(asian_american),
    MAX(latin_american),
    MIN(latin_american),
    MAX(poc),
    MIN(poc),
    MAX(jewish),
    MIN(jewish),
    MAX(muslim),
    MIN(muslim),
    MAX(lgbt),
    MIN(lgbt)
FROM
    contestant_table;
    
SELECT 
    *
FROM
    contestant_table
WHERE
    african_american IS NULL
        OR asian_american IS NULL
        OR latin_american IS NULL
        OR poc IS NULL
        OR jewish IS NULL
        OR muslim IS NULL
        OR lgbt IS NULL;
        
#Checking state column
SELECT 
    *
FROM
    contestant_table
WHERE
    state IS NULL;
    
-- Washington DC is added in 3 different ways, therefore we'll select one value for all and update the fields    
SELECT DISTINCT 
    state
FROM
    contestant_table
ORDER BY state;

SELECT 
    *
FROM
    contestant_table
WHERE
    state = 'D.C.'
        OR state = 'District of Columbia'
        OR state = 'Washington DC';

Commit;

#Updating the state names
UPDATE contestant_table 
SET 
    state = 'District of Columbia'
WHERE
    state = 'D.C.' OR state = 'Washington DC';

Commit;

#Updating the hometowns of some fields where the values still have a coma
UPDATE contestant_table 
SET 
    hometown = 'Washington'
WHERE
    hometown = 'Washington, ';
    
#Checking country column
SELECT 
    *
FROM
    contestant_table
WHERE
    country IS NULL OR LENGTH(country) > 2;
    
-- 4 canadian contestants
SELECT 
    *
FROM
    contestant_table
WHERE
    country <> 'US';

#Checking num_appearance column
SELECT 
    *
FROM
    contestant_table
WHERE
    num_appearance IS NULL;
    
-- MIN and MAX    
SELECT 
    MAX(num_appearance), MIN(num_appearance)
FROM
    contestant_table;

#Check birthdate column: no nulls, max and min ok,
SELECT 
    *
FROM
    contestant_table
WHERE
    birthdate IS NULL;
-- max and min
SELECT 
    MAX(birthdate), MIN(birthdate)
FROM
    contestant_table;
    
-- checking num characters
SELECT 
    CHAR_LENGTH(birthdate)
FROM
    contestant_table
WHERE
    CHAR_LENGTH(birthdate) <> 10;

#Checking merge column: all good
SELECT 
    *
FROM
    contestant_table
WHERE
    merge <> 1 AND merge <> 0
        OR merge IS NULL;
        
#Checking jury column: all good
SELECT 
    *
FROM
    contestant_table
WHERE
    jury <> 1 AND jury <> 0 OR jury IS NULL;

#Checking ftc column: all good
SELECT 
    *
FROM
    contestant_table
WHERE
    ftc <> 1 AND ftc <> 0 OR ftc IS NULL;
    
#Votes_against column: all good
SELECT 
    MAX(votes_against), MIN(votes_against)
FROM
    contestant_table;
-- Karishma Patel holds the record of 22 votes against
SELECT 
    *
FROM
    contestant_table
WHERE
    votes_against = 22;
-- nulls: none
SELECT 
    *
FROM
    contestant_table
WHERE
    votes_against IS NULL;

#Checking num_boot column:

SELECT 
    MIN(num_boot), MAX(num_boot)
FROM
    contestant_table;
-- nulls: none
SELECT 
    *
FROM
    contestant_table
WHERE
    num_boot IS NULL;

#Checking tribe1 column

SELECT DISTINCT -- all look good, no mistakes, no nulls
    tribe1
FROM
    contestant_table
ORDER BY tribe1;

SELECT 
    *
FROM
    contestant_table
WHERE
    tribe1 IS NULL;

#Check tribe2 column: 
SELECT DISTINCT -- all look good, no mistakes, no nulls
    tribe2
FROM
    contestant_table
ORDER BY tribe2;

SELECT 
    *
FROM
    contestant_table
WHERE
    tribe2 IS NULL;
    
#Check tribe3 column: 
SELECT DISTINCT -- all look good, no mistakes, no nulls
    tribe3
FROM
    contestant_table
ORDER BY tribe3;

SELECT 
    *
FROM
    contestant_table
WHERE
    tribe3 IS NULL;
    
# Checking columns quit,evac,ejected,fmc: min and max OK,
SELECT 
    MAX(quit),
    MIN(quit),
    MAX(evac),
    MIN(evac),
    MAX(ejected),
    MIN(ejected),
    MAX(fmc),
    MIN(fmc)
FROM
    contestant_table;
    
-- Looking for nulls
SELECT 
    *
FROM
    contestant_table
WHERE
    quit IS NULL OR evac IS NULL
        OR ejected IS NULL
        OR fmc IS NULL;

#Checking num_jury_votes: all good, no nulls
SELECT 
    MIN(num_jury_votes), MAX(num_jury_votes)
FROM
    contestant_table;

SELECT 
    *
FROM
    contestant_table
WHERE
    num_jury_votes IS NULL;
    
#Checking normalizad_finish column: all good, no nulls
SELECT 
    *
FROM
    contestant_table
WHERE
    normalized_finish < 0
        OR normalized_finish > 1
        OR normalized_finish IS NULL;