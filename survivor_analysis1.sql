/*

Survivor Show Data Exploration

Skills used: Subqueries, Joins, If and Case Statement, CTE's, Temp Tables, Aggregate Functions

*/


SELECT 
    *
FROM
    survivor.contestant_table;



-- Looking for contestant with most times on show 
SELECT 
    contestant_name, COUNT(contestant_name) AS times_on_show
FROM
    contestant_table
GROUP BY contestant_name
ORDER BY times_on_show DESC;

-- Counts of Female and male 
SELECT 
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'M') count_male,
    (SELECT 
            COUNT(gender) AS count_female
        FROM
            contestant_table
        WHERE
            gender = 'F') count_female,
    COUNT(gender) AS total
FROM
    contestant_table;
    
-- Winners by gender 
SELECT 
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'M' AND finish = 1) male_winners,
    (SELECT 
            COUNT(gender) AS count_female
        FROM
            contestant_table
        WHERE
            gender = 'F' AND finish = 1) female_winners,
    COUNT(finish) AS total_winners
FROM
    contestant_table
WHERE
    finish = 1;
    
-- Final tribal council by gender 
SELECT 
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'M' AND ftc = 1) AS male_finalists,
    (SELECT 
            COUNT(gender) AS count_female
        FROM
            contestant_table
        WHERE
            gender = 'F' AND ftc = 1) female_finalists,
    COUNT(ftc) AS total_finalists
FROM
    contestant_table
WHERE
    ftc = 1;

-- Final 4 by gender 
SELECT 
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'M' AND finish <= 4) count_male,
    (SELECT 
            COUNT(gender) AS count_female
        FROM
            contestant_table
        WHERE
            gender = 'F' AND finish <= 4) count_female,
    COUNT(finish) AS total
FROM
    contestant_table
WHERE
    finish <= 4;
    
    
-- Winners, finalists, final 4 and total participants by Gender
SELECT 
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'M') count_male,
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'M' AND finish <= 4) male_final4,
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'M' AND ftc = 1) AS male_finalists,
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'M' AND finish = 1) male_winners,
    (SELECT 
            COUNT(gender) AS count_female
        FROM
            contestant_table
        WHERE
            gender = 'F') count_female,
    (SELECT 
            COUNT(gender) AS count_female
        FROM
            contestant_table
        WHERE
            gender = 'F' AND finish <= 4) female_final4,
    (SELECT 
            COUNT(gender) AS count_female
        FROM
            contestant_table
        WHERE
            gender = 'F' AND ftc = 1) female_finalists,
    (SELECT 
            COUNT(gender) AS count_female
        FROM
            contestant_table
        WHERE
            gender = 'F' AND finish = 1) female_winners,
    COUNT(gender) AS total_players,
    (SELECT 
            COUNT(finish) AS total_winners
        FROM
            contestant_table
        WHERE
            finish = 1) AS total_winners
FROM
    contestant_table;


-- Gender winnning rate 

SELECT 
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'M' AND finish = 1) male_winners,
    26 / (SELECT 
            COUNT(finish) AS total_winners
        FROM
            contestant_table
        WHERE
            finish = 1) AS male_winners_rate,
    (SELECT 
            COUNT(gender) AS count
        FROM
            contestant_table
        WHERE
            gender = 'F' AND finish = 1) female_winners,
    17 / (SELECT 
            COUNT(finish) AS total_winners
        FROM
            contestant_table
        WHERE
            finish = 1) AS female_winners_rate
FROM
    contestant_table
LIMIT 1;

#gender by season: pretty equal

SELECT 
    COUNT(gender) AS num_gender, num_season
FROM
    contestant_table
GROUP BY num_season , gender;


-- Winners by state 
SELECT 
    state, SUM(finish) AS winnings
FROM
    contestant_table
WHERE
    finish = 1
GROUP BY state
ORDER BY winnings DESC;

-- Finalists by state --
SELECT 
    state, SUM(ftc) AS finalists
FROM
    contestant_table
WHERE
    ftc = 1
GROUP BY state
ORDER BY finalists DESC;

-- Participants by state: total players, finalists and winners 
SELECT 
    ct.state,
    COUNT(ct.state) AS num_players,
    f.finalists,
    w.winnings AS winners,
    w.winnings / COUNT(ct.state) AS winning_rate
FROM
    contestant_table ct
        JOIN
    (SELECT 
        state, SUM(ftc) AS finalists
    FROM
        contestant_table
    WHERE
        ftc = 1
    GROUP BY state) f ON ct.state = f.state
        JOIN
    (SELECT 
        state, SUM(finish) AS winnings
    FROM
        contestant_table
    WHERE
        finish = 1
    GROUP BY state) w ON ct.state = w.state
GROUP BY ct.state
ORDER BY COUNT(ct.state) DESC;

-- Count participants by age
SELECT 
    age, COUNT(age) AS count
FROM
    contestant_table
GROUP BY age
ORDER BY age;

-- Count by age range    
SELECT 
    SUM(IF(age < 20, 1, 0)) AS 'Under 20',
    SUM(IF(age BETWEEN 20 AND 29, 1, 0)) AS '20 - 29',
    SUM(IF(age BETWEEN 30 AND 39, 1, 0)) AS '30 - 39',
    SUM(IF(age BETWEEN 40 AND 49, 1, 0)) AS '40 - 49',
    SUM(IF(age BETWEEN 50 AND 59, 1, 0)) AS '50 - 59',
    SUM(IF(age >= 60, 1, 0)) AS 'Above 60'
FROM
    contestant_table;

-- Winners by age: higiher chance to win if you are between 20 and 39 years 
SELECT 
    age, COUNT(age) AS count
FROM
    contestant_table
WHERE
    finish = 1
GROUP BY age
ORDER BY age;

-- winner by age range
SELECT 
    SUM(IF(age < 20, 1, 0)) AS 'Under 20',
    SUM(IF(age BETWEEN 20 AND 29, 1, 0)) AS '20 - 29',
    SUM(IF(age BETWEEN 30 AND 39, 1, 0)) AS '30 - 39',
    SUM(IF(age BETWEEN 40 AND 49, 1, 0)) AS '40 - 49',
    SUM(IF(age BETWEEN 50 AND 59, 1, 0)) AS '50 - 59',
    SUM(IF(age >= 60, 1, 0)) AS 'Above 60'
FROM
    contestant_table
WHERE
    finish = 1;

-- Final tribal council by age
SELECT 
    SUM(IF(age < 20, 1, 0)) AS 'Under 20',
    SUM(IF(age BETWEEN 20 AND 29, 1, 0)) AS '20 - 29',
    SUM(IF(age BETWEEN 30 AND 39, 1, 0)) AS '30 - 39',
    SUM(IF(age BETWEEN 40 AND 49, 1, 0)) AS '40 - 49',
    SUM(IF(age BETWEEN 50 AND 59, 1, 0)) AS '50 - 59',
    SUM(IF(age >= 60, 1, 0)) AS 'Above 60'
FROM
    contestant_table
WHERE
    ftc = 1;

-- final 4 by age
SELECT 
    SUM(IF(age < 20, 1, 0)) AS 'Under 20',
    SUM(IF(age BETWEEN 20 AND 29, 1, 0)) AS '20 - 29',
    SUM(IF(age BETWEEN 30 AND 39, 1, 0)) AS '30 - 39',
    SUM(IF(age BETWEEN 40 AND 49, 1, 0)) AS '40 - 49',
    SUM(IF(age BETWEEN 50 AND 59, 1, 0)) AS '50 - 59',
    SUM(IF(age >= 60, 1, 0)) AS 'Above 60'
FROM
    contestant_table
WHERE
    finish <= 4;
-- Minorities all seasons
SELECT 
    SUM(african_american) AS num_african_american,
    SUM(asian_american) AS num_asian_american,
    SUM(latin_american) AS num_latin_american,
    SUM(jewish) AS num_jewish,
    SUM(muslim) AS num_muslim,
    SUM(lgbt) AS num_lgbt
FROM
    contestant_table;

-- Minorities by season
SELECT 
    num_season,
    SUM(african_american) AS num_african_american,
    SUM(asian_american) AS num_asian_american,
    SUM(latin_american) AS num_latin_american,
    SUM(jewish) AS num_jewish,
    SUM(muslim) AS num_muslim,
    SUM(lgbt) AS num_lgbt
FROM
    contestant_table
GROUP BY num_season;

-- Minorities winners: 16 out of 43 champions are minorities
SELECT 
    SUM(african_american) AS num_african_american,
    SUM(asian_american) AS num_asian_american,
    SUM(latin_american) AS num_latin_american,
    SUM(jewish) AS num_jewish,
    SUM(muslim) AS num_muslim,
    SUM(lgbt) AS num_lgbt
FROM
    contestant_table
WHERE
    finish = 1;

-- Minorities final tribal council: 
SELECT 
    SUM(african_american) AS num_african_american,
    SUM(asian_american) AS num_asian_american,
    SUM(latin_american) AS num_latin_american,
    SUM(jewish) AS num_jewish,
    SUM(muslim) AS num_muslim,
    SUM(lgbt) AS num_lgbt
FROM
    contestant_table
WHERE
    ftc = 1;

-- Minorities final 4:
SELECT 
    SUM(african_american) AS num_african_american,
    SUM(asian_american) AS num_asian_american,
    SUM(latin_american) AS num_latin_american,
    SUM(jewish) AS num_jewish,
    SUM(muslim) AS num_muslim,
    SUM(lgbt) AS num_lgbt
FROM
    contestant_table
WHERE
    finish <= 4;
    
-- What type of people gets voted out faster?
SELECT 
    age, COUNT(age) AS num_times
FROM
    contestant_table
WHERE
    num_boot < 6
GROUP BY age
ORDER BY num_times DESC;

#Considerally the players between 20 and 29 nine are more likely to get voted out 
SELECT 
    SUM(IF(age < 20, 1, 0)) AS 'Under 20',
    SUM(IF(age BETWEEN 20 AND 29, 1, 0)) AS '20 - 29',
    SUM(IF(age BETWEEN 30 AND 39, 1, 0)) AS '30 - 39',
    SUM(IF(age BETWEEN 40 AND 49, 1, 0)) AS '40 - 49',
    SUM(IF(age BETWEEN 50 AND 59, 1, 0)) AS '50 - 59',
    SUM(IF(age >= 60, 1, 0)) AS 'Above 60'
FROM
    contestant_table
WHERE
    num_boot < 6;
    
#Gender: higher chance to get voted out first if you are a female
SELECT 
    gender, COUNT(gender) number
FROM
    contestant_table
WHERE
    num_boot < 6
GROUP BY gender;

#South Carolina contestants has the worst voted out rate: considering more than 10 participations only.
SELECT 
    ct.state,
    COUNT(ct.state) AS num,
    s.count,
    COUNT(ct.state) / s.count AS voted_out_rate
FROM
    contestant_table ct
        JOIN
    (SELECT 
        state, COUNT(state) AS count
    FROM
        contestant_table
    GROUP BY state) s ON s.state = ct.state
WHERE
    num_boot < 6 AND s.count > 9
GROUP BY ct.state
ORDER BY voted_out_rate DESC;

-- How many have quit, been evacuated or expelled from the show

SELECT 
    SUM(quit), SUM(evac), SUM(ejected)
FROM
    contestant_table
GROUP BY quit , evac , ejected;

-- When tribes merge, which players have a better chance, those from the bigger or those from the smaller tribe?
  
#Winning tribe by season
SELECT 
    ct.num_season,
    CASE
        WHEN tribe3 <> '' THEN tribe3
        WHEN tribe3 = '' AND tribe2 <> '' THEN tribe2
        ELSE tribe1
    END AS winning_tribe,
    st.num_merge
FROM
    contestant_table ct
        JOIN
    season_table st ON ct.num_season = st.num_season
WHERE
    finish = 1;
    
#Temporary table
Drop Table if exists winning_tribe_season;
create temporary table winning_tribe_season
SELECT 
    ct.num_season,
    CASE
        WHEN tribe3 <> '' THEN tribe3
        WHEN tribe3 = '' AND tribe2 <> '' THEN tribe2
        ELSE tribe1
    END AS winning_tribe,
    st.num_merge
FROM
    contestant_table ct
        JOIN
    season_table st ON ct.num_season = st.num_season
WHERE
    finish = 1;
    
#Tribes with advantage won 60% of the times
SELECT 
    wt.num_season,
    wt.winning_tribe,
    t.num_tribes,
    wt.num_merge,
    s.num_merged AS winning_tribe_num,
    CASE
        WHEN s.num_merged > wt.num_merge / t.num_tribes THEN 'advantage'
        WHEN s.num_merged < wt.num_merge / t.num_tribes THEN 'underdog'
        ELSE 'tied'
    END AS position_
FROM
    winning_tribe_season wt
        JOIN
    (SELECT 
        num_season,
            COUNT(contestant_name) AS num_merged,
            CASE
                WHEN tribe3 <> '' THEN tribe3
                WHEN tribe3 = '' AND tribe2 <> '' THEN tribe2
                ELSE tribe1
            END AS tribe
    FROM
        contestant_table
    WHERE
        merge = 1
    GROUP BY num_season , tribe) s ON s.tribe = wt.winning_tribe
        JOIN
    (SELECT 
        num_season,
            COUNT(DISTINCT CASE
                WHEN tribe3 <> '' THEN tribe3
                WHEN tribe3 = '' AND tribe2 <> '' THEN tribe2
                ELSE tribe1
            END) AS num_tribes
    FROM
        contestant_table
    WHERE
        merge = 1
    GROUP BY num_season) t ON t.num_season = wt.num_season;

    
