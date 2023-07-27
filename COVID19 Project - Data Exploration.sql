/* 

COVID-19 Data Exploration 

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views

*/

Select *
From `portfolioproject-393816.CovidDeaths.Deaths`
Where continent is not null
Order by location,date;

-- Selection of initial data for Data Exploration

Select location, date, new_cases, total_cases,total_deaths, population
From `portfolioproject-393816.CovidDeaths.Deaths`
Order by location,date;

-- total cases vs total deaths 
-- Showing the likelihood of dying by COVID-19 by country and date

Select location,date, total_cases,total_deaths, round((total_deaths/total_cases)*100,2) as death_percentage
From `portfolioproject-393816.CovidDeaths.Deaths`
Where continent is not null
Order by location,date;

-- total cases vs total deaths in Argentina
-- -- Showing the likelihood of dying by COVID-19 in Argentina by date

Select location,date, total_cases,total_deaths, round((total_deaths/total_cases)*100,2) as death_percentage
From `portfolioproject-393816.CovidDeaths.Deaths`
Where location = "Argentina"
Order by location,date;

-- total cases vs population 
-- Showing what percentage of population got COVID by country

Select location,date, total_cases,population, round((total_cases/population)*100,6) as cases_percentage
From `portfolioproject-393816.CovidDeaths.Deaths`
Where continent is not null
Order by location,date;

-- Infection percentage of the population by country

Select location, population, max(total_cases) as total_cases_count, max(round((total_cases/population)*100,2)) as infection_rate
From `portfolioproject-393816.CovidDeaths.Deaths`
Where continent is not null
Group by location, population
Order by infection_rate desc;

-- Looking at countries with the highest death rate compared to population

Select location, population, max(total_deaths) as total_deaths_count, max(round((total_deaths/population)*100,2)) as death_rate
From `portfolioproject-393816.CovidDeaths.Deaths`
Where continent is not null
Group by location, population
Order by death_rate desc;

-- Countries with the highest death count

Select location, population, max(total_deaths) as total_deaths_count
From `portfolioproject-393816.CovidDeaths.Deaths`
Where continent is not null
Group by location, population
Order by total_deaths_count desc;

-- Death count by continent

Select location, max(total_deaths) as total_death_count
From `portfolioproject-393816.CovidDeaths.Deaths`
Where continent is null and location not like("%income%") and location not in("European Union","World")
Group by location
Order by total_death_count desc;

-- Number of cases vs population_density

Select
deaths.continent,deaths.location, max(deaths.total_cases) as total_cases, max(vaccs.population_density) as population_density
From
`portfolioproject-393816.CovidDeaths.Deaths` as deaths
Join 
`portfolioproject-393816.CovidDeaths.Vaccinations`as vaccs
On deaths.location = vaccs.location
And deaths.date = vaccs.date
Where deaths.continent is not null
Group by deaths.continent,deaths.location
Order by total_cases desc;

-- Number of deaths vs gdp per capita

Select
deaths.continent,deaths.location, max(deaths.total_deaths) as total_deaths,max(vaccs.gdp_per_capita) as gdp_per_capita
From
`portfolioproject-393816.CovidDeaths.Deaths` as deaths
Join 
`portfolioproject-393816.CovidDeaths.Vaccinations`as vaccs
On deaths.location = vaccs.location
And deaths.date = vaccs.date
Where deaths.continent is not null
Group by deaths.continent,deaths.location
Order by total_deaths desc;

--Global numbers daily
--Total cases, deaths and global death percentage 

Select
date,sum(new_cases) as count_cases,sum(new_deaths) as count_deaths,concat(Round(safe_divide(sum(new_deaths),sum(new_cases))*100,2),"%") as death_percentage
From
`portfolioproject-393816.CovidDeaths.Deaths`
Where continent is not null
Group by date
Order by date asc;

-- View of Global numbers daily

Drop view if exists CovidDeaths.GlobalNumbersDaily;
Create view CovidDeaths.GlobalNumbersDaily as
Select
date,sum(new_cases) as count_cases,sum(new_deaths) as count_deaths,concat(Round(safe_divide(sum(new_deaths),sum(new_cases))*100,2),"%") as death_percentage
From
`portfolioproject-393816.CovidDeaths.Deaths`
Where continent is not null
Group by date
Order by date asc;

-- Global numbers total

Select
sum(new_cases) as count_cases,sum(new_deaths) as count_deaths,concat(Round(safe_divide(sum(new_deaths),sum(new_cases))*100,2),"%") as death_percentage
From
`portfolioproject-393816.CovidDeaths.Deaths`
Where continent is not null;

-- Total population vs daily vaccinations applied vs people vaccinated with at least 1 shot by country

Select 
deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations, vaccs.people_vaccinated
From
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
Join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
On deaths.location = vaccs.location and deaths.date = vaccs.date
Where deaths.continent is not null 
Order by 2,3;


-- Looking at total population vs daily vaccinations by country

Select 
deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations, sum(vaccs.new_vaccinations) over (partition by deaths.location order by deaths.location, deaths.date) as vaccination_count
From
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
Join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
On deaths.location = vaccs.location and deaths.date = vaccs.date
Where deaths.continent is not null
Order by 2,3;

-- vaccination application rate by population 
-- Amount of vaccination dosis applied compared to the population
-- CTE from previous query

With vaccs_people 
as
(
Select 
deaths.continent, deaths.location, deaths.date, deaths.population, vaccs.new_vaccinations, sum(vaccs.new_vaccinations) over (partition by deaths.location order by deaths.location, deaths.date) as vaccination_count
From
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
Join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
On deaths.location = vaccs.location and deaths.date = vaccs.date
)
Select *, (vaccination_count/population) as vacc_application_rate From vaccs_people Order by 2,3;

-- People vaccinated percentage with at least 1 shot by population

Select
deaths.continent, deaths.location, deaths.date, deaths.population,vaccs.people_vaccinated, Round((vaccs.people_vaccinated/deaths.population)*100,2) as people_vaccinated_percentage
From
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
Join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
On deaths.location = vaccs.location and deaths.date = vaccs.date
Where deaths.continent is not null
Order by 2,3;

-- Countries ranked by highest percentage of people vaccinated with at least 1 dosis (minimum population of 100k )

With rank_vaccs
as
(Select
deaths.continent, deaths.location, deaths.date, deaths.population,vaccs.people_vaccinated, Round((vaccs.people_vaccinated/deaths.population)*100,2) as people_vaccinated_percentage
From
`portfolioproject-393816.CovidDeaths.Deaths` as deaths 
Join `portfolioproject-393816.CovidDeaths.Vaccinations` as vaccs 
On deaths.location = vaccs.location and deaths.date = vaccs.date
Where deaths.continent is not null
)
Select location,max(population) as population, max(people_vaccinated_percentage) as people_vaccinated_percentage
From
rank_vaccs
Where population >=100000
Group by location
Order by people_vaccinated_percentage desc;
