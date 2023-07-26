/* 

COVID-19 Data Exploration 

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views

*/

select *
from `portfolioproject-393816.CovidDeaths.Deaths`
where continent is not null
order by location,date;

-- Selection of initial data for Data Exploration

select location, date, new_cases, total_cases,total_deaths, population
from `portfolioproject-393816.CovidDeaths.Deaths`
order by location,date;

-- total cases vs total deaths 
-- Showing the likelihood of dying by COVID-19 by country and date

select location,date, total_cases,total_deaths, round((total_deaths/total_cases)*100,2) as death_percentage
from `portfolioproject-393816.CovidDeaths.Deaths`
where continent is not null
order by location,date;

-- total cases vs total deaths in Argentina
-- -- Showing the likelihood of dying by COVID-19 in Argentina by date

select location,date, total_cases,total_deaths, round((total_deaths/total_cases)*100,2) as death_percentage
from `portfolioproject-393816.CovidDeaths.Deaths`
where location = "Argentina"
order by location,date;

-- total cases vs population 
-- Showing what percentage of population got COVID by country

select location,date, total_cases,population, round((total_cases/population)*100,6) as cases_percentage
from `portfolioproject-393816.CovidDeaths.Deaths`
where continent is not null
order by location,date;

-- Infection percentage of the population by country

select location, population, max(total_cases) as total_cases_count, max(round((total_cases/population)*100,2)) as infection_rate
from `portfolioproject-393816.CovidDeaths.Deaths`
where continent is not null
group by location, population
order by infection_rate desc;

-- Looking at countries with the highest death rate compared to population

select location, population, max(total_deaths) as total_deaths_count, max(round((total_deaths/population)*100,2)) as death_rate
from `portfolioproject-393816.CovidDeaths.Deaths`
where continent is not null
group by location, population
order by death_rate desc;

-- Countries with the highest death count

select location, population, max(total_deaths) as total_deaths_count
from `portfolioproject-393816.CovidDeaths.Deaths`
where continent is not null
group by location, population
order by total_deaths_count desc;

-- Death count by continent

select location, max(total_deaths) as total_death_count
from `portfolioproject-393816.CovidDeaths.Deaths`
where continent is null and location not like("%income%") and location not in("European Union","World")
group by location
order by total_death_count desc;

-- Number of cases vs population_density

select
deaths.continent,deaths.location, max(deaths.total_cases) as total_cases, max(vaccs.population_density) as population_density
from
`portfolioproject-393816.CovidDeaths.Deaths` as deaths
join 
`portfolioproject-393816.CovidDeaths.Vaccinations`as vaccs
on deaths.location = vaccs.location
AND deaths.date = vaccs.date
where deaths.continent is not null
group by deaths.continent,deaths.location
order by total_cases desc;

-- Number of deaths vs gdp per capita

select
deaths.continent,deaths.location, max(deaths.total_deaths) as total_deaths,max(vaccs.gdp_per_capita) as gdp_per_capita
from
`portfolioproject-393816.CovidDeaths.Deaths` as deaths
join 
`portfolioproject-393816.CovidDeaths.Vaccinations`as vaccs
on deaths.location = vaccs.location
AND deaths.date = vaccs.date
where deaths.continent is not null
group by deaths.continent,deaths.location
order by total_deaths desc;

--Global numbers daily
--Total cases, deaths and global death percentage 

select
date,sum(new_cases) as count_cases,sum(new_deaths) as count_deaths,concat(Round(safe_divide(sum(new_deaths),sum(new_cases))*100,2),"%") as death_percentage
from
`portfolioproject-393816.CovidDeaths.Deaths`
where continent is not null
group by date
order by date asc;

-- View of Global numbers daily

drop view if exists CovidDeaths.GlobalNumbersDaily;
create view CovidDeaths.GlobalNumbersDaily as
select
date,sum(new_cases) as count_cases,sum(new_deaths) as count_deaths,concat(Round(safe_divide(sum(new_deaths),sum(new_cases))*100,2),"%") as death_percentage
from
`portfolioproject-393816.CovidDeaths.Deaths`
where continent is not null
group by date
order by date asc;

-- Global numbers total

select
sum(new_cases) as count_cases,sum(new_deaths) as count_deaths,concat(Round(safe_divide(sum(new_deaths),sum(new_cases))*100,2),"%") as death_percentage
from
`portfolioproject-393816.CovidDeaths.Deaths`
where continent is not null;

-- Total population vs daily vaccinations applied vs people vaccinated with at least 1 shot by country

select 
deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations, vaccs.people_vaccinated
from
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
on deaths.location = vaccs.location and deaths.date = vaccs.date
where deaths.continent is not null 
order by 2,3;


-- Looking at total population vs daily vaccinations by country

select 
deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations, sum(vaccs.new_vaccinations) over (partition by deaths.location order by deaths.location, deaths.date) as vaccination_count
from
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
on deaths.location = vaccs.location and deaths.date = vaccs.date
where deaths.continent is not null
order by 2,3;

-- vaccination application rate by population 
-- Amount of vaccination dosis applied compared to the population
-- CTE from previous query

with vaccs_people 
as
(
select 
deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations, sum(vaccs.new_vaccinations) over (partition by deaths.location order by deaths.location, deaths.date) as vaccination_count
from
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
on deaths.location = vaccs.location and deaths.date = vaccs.date
)
select *, (vaccination_count/population) as vacc_application_rate from vaccs_people order by 2,3;

-- People vaccinated percentage with at least 1 shot by population

SELECT
deaths.continent, deaths.location, deaths.date, deaths.population,vaccs.people_vaccinated, Round((vaccs.people_vaccinated/deaths.population)*100,2) as people_vaccinated_percentage
FROM
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
on deaths.location = vaccs.location and deaths.date = vaccs.date
where deaths.continent is not null
order by 2,3;

-- Countries ranked by highest percentage of people vaccinated with at least 1 dosis (minimum population of 100k )

with rank_vaccs
as
(SELECT
deaths.continent, deaths.location, deaths.date, deaths.population,vaccs.people_vaccinated, Round((vaccs.people_vaccinated/deaths.population)*100,2) as people_vaccinated_percentage
FROM
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
on deaths.location = vaccs.location and deaths.date = vaccs.date
where deaths.continent is not null
)
select location,max(population) as population, max(people_vaccinated_percentage) as people_vaccinated_percentage
from
rank_vaccs
where population >=100000
group by location
order by people_vaccinated_percentage desc;
