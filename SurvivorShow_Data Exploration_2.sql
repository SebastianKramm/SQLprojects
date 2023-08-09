/*

Survivor Show Data Exploration

Skills used: Subqueries, Joins, Windows Functions, Aggregate Functions

*/

SELECT 
    *
FROM
    individual_challenges;
    
# pid column = contestant number, season = show season, finish = contestant finishing position, inicw = individual challenge won

-- cleaning and validation
SELECT 
    pid, season, finish, inicw
FROM
    individual_challenges
ORDER BY season;

SELECT 
    MAX(season),
    MIN(season),
    MAX(finish),
    MIN(finish),
    MAX(inicw),
    MIN(inicw)
FROM
    survivor.individual_challenges;
    
-- Reviewing those players who won immunity and finished before the 10 final players --
SELECT 
    *
FROM
    individual_challenges
WHERE
    finish > 10 AND inicw <> 0
ORDER BY season;
    
SELECT 
    num_season, COUNT(contestant_name), merge
FROM
    contestant_table
WHERE
    merge = 1
GROUP BY num_season;
    
-- Challenges winned by survivor winner by season 
SELECT 
    i.PID,
    i.season,
    i.INICW,
    i.finish,
    c.num_challenges,
    i.inicw / c.num_challenges AS percentage_won
FROM
    individual_challenges i
        JOIN
    (SELECT 
        season, SUM(inicw) AS num_challenges
    FROM
        individual_challenges
    GROUP BY season
    ORDER BY season) c ON i.season = c.season
WHERE
    finish = 1
ORDER BY season , INICW DESC;

-- Looking at the winner's distribiution by amount of individual challenges won
SELECT 
    (SELECT 
            COUNT(inicw) AS winner_with_no_ic_won
        FROM
            individual_challenges
        WHERE
            finish = 1 AND inicw = 0 and season <> 44) AS winner_with_no_ic_won,
    (SELECT 
            COUNT(inicw) AS winner_with_1_ic_won
        FROM
            individual_challenges
        WHERE
            finish = 1 AND inicw = 1 and season <> 44) AS winner_with_1_ic_won,
    (SELECT 
            COUNT(inicw) AS winner_with_2_ic_won
        FROM
            individual_challenges
        WHERE
            finish = 1 AND inicw = 2 and season <> 44) AS winner_with_2_ic_won,
    (SELECT 
            COUNT(inicw) AS winner_with_2_or_more_ic_won
        FROM
            individual_challenges
        WHERE
            finish = 1 AND inicw > 2 and season <> 44) AS winner_with_2_or_more_ic_won
FROM
    individual_challenges
LIMIT 1;


-- Challenges won by final 3 players by season 
SELECT 
    PID, season, INICW, finish
FROM
    individual_challenges
WHERE
    finish = 1 OR finish = 2 OR finish = 3
ORDER BY season , INICW DESC;

-- Amount of challenges by season 
SELECT 
    season, SUM(inicw) AS num_challenges
FROM
    individual_challenges
GROUP BY season
ORDER BY season;

-- Looking at the contestant with the most amount of ICs won by season 
select 
pid,season,finish, inicw as ic_won,  dense_rank () over (partition by season order by inicw desc) as ic_won_rank, dense_rank () over (partition by season order by finish) as finish_rank
from
individual_challenges
order by season, finish;

select 
pid,season,finish, inicw as ic_won,  dense_rank () over (partition by season order by inicw desc) as ic_won_rank, dense_rank () over (partition by season order by finish) as finish_rank
from
individual_challenges
order by season, finish;

