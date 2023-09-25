-- CREATE TABLE CovidDeaths
CREATE TABLE CovidDeaths (
iso_code	varchar	,
continent	varchar	,
location_	varchar	,
date_	date	,
population	int	,
total_cases	int	,
new_cases	int	,
new_cases_smoothed	int	,
total_deaths	int	,
new_deaths	int	,
new_deaths_smoothed	int	,
total_cases_per_million	int	,
new_cases_per_million	int	,
new_cases_smoothed_per_million	int	,
total_deaths_per_million	int	,
new_deaths_per_million	int	,
new_deaths_smoothed_per_million	int	,
reproduction_rate	int	,
icu_patients	int	,
icu_patients_per_million	int	,
hosp_patients	int	,
hosp_patients_per_million	int	,
weekly_icu_admissions	int	,
weekly_icu_admissions_per_million	int	,
weekly_hosp_admissions	int	,
weekly_hosp_admissions_per_million	int	,
total_tests	int
);


-- Change the data types of the specified CovidDeaths to numeric
ALTER TABLE public."CovidDeaths"
ALTER COLUMN population TYPE numeric,
ALTER COLUMN total_cases TYPE numeric,
ALTER COLUMN new_cases TYPE numeric,
ALTER COLUMN new_cases_smoothed TYPE numeric,
ALTER COLUMN total_deaths TYPE numeric,
ALTER COLUMN new_deaths TYPE numeric,
ALTER COLUMN new_deaths_smoothed TYPE numeric,
ALTER COLUMN total_cases_per_million TYPE numeric,
ALTER COLUMN new_cases_per_million TYPE numeric,
ALTER COLUMN new_cases_smoothed_per_million TYPE numeric,
ALTER COLUMN total_deaths_per_million TYPE numeric,
ALTER COLUMN new_deaths_per_million TYPE numeric,
ALTER COLUMN new_deaths_smoothed_per_million TYPE numeric,
ALTER COLUMN reproduction_rate TYPE numeric,
ALTER COLUMN icu_patients TYPE numeric,
ALTER COLUMN icu_patients_per_million TYPE numeric,
ALTER COLUMN hosp_patients TYPE numeric,
ALTER COLUMN hosp_patients_per_million TYPE numeric,
ALTER COLUMN weekly_icu_admissions TYPE numeric,
ALTER COLUMN weekly_icu_admissions_per_million TYPE numeric,
ALTER COLUMN weekly_hosp_admissions TYPE numeric,
ALTER COLUMN weekly_hosp_admissions_per_million TYPE numeric,
ALTER COLUMN total_tests TYPE numeric;


-- Verify CovidDeaths Data import
SELECT * 
FROM public."CovidDeaths"
LIMIT 100


--CREATE TABLE CovidVaccinations
CREATE TABLE CovidVaccinations (
iso_code	varchar	,
continent	varchar	,
location_	varchar	,
date_	date	,
new_tests	numeric	,
total_tests_per_thousand	numeric	,
new_tests_per_thousand	numeric	,
new_tests_smoothed	numeric	,
new_tests_smoothed_per_thousand	numeric	,
positive_rate	numeric	,
tests_per_case	numeric	,
tests_units	numeric	,
total_vaccinations	numeric	,
people_vaccinated	numeric	,
people_fully_vaccinated	numeric	,
total_boosters	numeric	,
new_vaccinations	numeric	,
new_vaccinations_smoothed	numeric	,
total_vaccinations_per_hundred	numeric	,
people_vaccinated_per_hundred	numeric	,
people_fully_vaccinated_per_hundred	numeric	,
total_boosters_per_hundred	numeric	,
new_vaccinations_smoothed_per_million	numeric	,
new_people_vaccinated_smoothed	numeric	,
new_people_vaccinated_smoothed_per_hundred	numeric	,
stringency_index	numeric	,
population_density	numeric	,
median_age	numeric	,
aged_65_older	numeric	,
aged_70_older	numeric	,
gdp_per_capita	numeric	,
extreme_poverty	numeric	,
cardiovasc_death_rate	numeric	,
diabetes_prevalence	numeric	,
female_smokers	numeric	,
male_smokers	numeric	,
handwashing_facilities	numeric	,
hospital_beds_per_thousand	numeric	,
life_expectancy	numeric	,
human_development_index	numeric	,
excess_mortality_cumulative_absolute	numeric	,
excess_mortality_cumulative	numeric	,
excess_mortality	numeric	,
excess_mortality_cumulative_per_million	numeric	
);


--Verify CovidVaccinations Data import
SELECT * 
FROM public."CovidVaccinations"
LIMIT 100 


-- Change the data types of the specified columns in CovidVaccinations to varchar
ALTER TABLE public."CovidVaccinations"
ALTER COLUMN tests_units TYPE varchar;


--Verify CovidVaccinations Data import
SELECT * 
FROM public."CovidVaccinations"
LIMIT 800 

------------------------------------------------------------------------------------------------

-- Check and order data
SELECT *
FROM public."CovidDeaths"
ORDER BY 3,4

SELECT *
FROM public."CovidVaccinations"
ORDER BY 3,4


--Select the Data that we are going to be using
SELECT location_, date_, total_cases, new_cases, total_deaths, population
FROM public."CovidDeaths"
ORDER BY 1,2


--Total cases vs Total Deaths
SELECT location_, date_, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
FROM public."CovidDeaths"
ORDER BY 1,2


--Total cases vs Total Deaths in the UK
-- Shows likelihood of dying if someone contrated Covid in the UK at various stages of the pandemic
SELECT location_, date_, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
FROM public."CovidDeaths"
Where location_ like '%United Kingdom%'
ORDER BY 1,2


-- Looking at the total cases vs the population
-- Shows what percentage of population got Covid
SELECT location_, date_, population, total_cases, (total_cases/population)*100 as Percent_Population_Infected
FROM public."CovidDeaths"
Where location_ like '%United Kingdom%'
ORDER BY 1,2


-- Looking at countries with highest infection rate compared with population
SELECT location_, population, MAX(total_cases) as Higest_Infection_Count, MAX((total_cases/population))*100 as Percent_Population_Infected
FROM public."CovidDeaths"
WHERE continent is not null
Group by location_, population
ORDER BY Percent_Population_Infected desc


-- showing the countries with the highest death count per population
SELECT location_, MAX(cast(total_deaths as int)) as Total_death_count
FROM public."CovidDeaths"
WHERE continent is not null 
Group by location_
ORDER BY Total_death_count desc


--Breaking data down by continent
---Showing the continent with the highest death count per population
SELECT location_, MAX(cast(total_deaths as int)) as Total_death_count
FROM public."CovidDeaths"
WHERE continent is null 
AND location_ not like '%income%'
Group by location_
ORDER BY Total_death_count desc


-- GLOBAL NUMBERS

--Global by date
SELECT date_, 
	SUM(new_cases) as Total_new_cases, 
	SUM(cast(new_deaths as int)) as Total_new_deaths, 
	(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as deathsVSnewPercentage
FROM public."CovidDeaths"
WHERE continent is null 
AND location_ not like '%income%'
AND new_cases <> 0
Group by date_
ORDER BY 1,2


--Global Grouped 
SELECT  
	SUM(new_cases) as Total_new_cases, 
	SUM(cast(new_deaths as int)) as Total_new_deaths, 
	(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as deathsVSnewPercentage
FROM public."CovidDeaths"
WHERE continent is null 
AND location_ not like '%income%'
AND new_cases <> 0
ORDER BY 1,2


-- Looking at Total Population vs Vaccinations
SELECT 
	dea.continent, 
	dea.location_, 
	dea.date_, 
	dea.population, 
	vac.new_vaccinations
FROM public."CovidDeaths" AS dea
JOIN public."CovidVaccinations" AS vac
	ON dea.location_ = vac.location_
	AND dea.date_ = vac.date_
WHERE dea.continent is not null 
AND dea.location_ not like '%income%'
order by 2,3


-- Looking at Total Population vs Vaccinations
--use CTE
with popVSvac (continent, location_, date_, population, New_Vaccinations, ROlling_Vaccinations)
as
(
SELECT 
	dea.continent, dea.location_, dea.date_, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (Partition by dea.location_ ORDER by dea.location_, dea.date_) as ROlling_Vaccinations
FROM public."CovidDeaths" AS dea
JOIN public."CovidVaccinations" AS vac
	ON dea.location_ = vac.location_
	AND dea.date_ = vac.date_
WHERE dea.continent is not null 
AND dea.location_ not like '%income%'
)
Select *,	(ROlling_Vaccinations/population)*100 as rolling_Total
FROM popVSvac


--Temp table

DROP Table if exists PercentPopulationVaccinated;
CREATE TEMP TABLE PercentPopulationVaccinated
(
    Continent varchar(255),
    location_ varchar(255),
    date_ date,
    population numeric,
    new_vaccinations numeric,
    ROlling_Vaccinations numeric
);
INSERT INTO PercentPopulationVaccinated
SELECT 
	dea.continent, dea.location_, dea.date_, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (Partition by dea.location_ ORDER by dea.location_, dea.date_) as ROlling_Vaccinations
FROM public."CovidDeaths" AS dea
JOIN public."CovidVaccinations" AS vac
	ON dea.location_ = vac.location_
	AND dea.date_ = vac.date_
WHERE dea.continent is not null 
AND dea.location_ not like '%income%';

select *, (ROlling_Vaccinations/population)*100 as rolling_Total
from PercentPopulationVaccinated;


--Create View to store data for later visialisations

Create VIEW PercentPopulationVaccinated as
SELECT 
	dea.continent, dea.location_, dea.date_, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (Partition by dea.location_ ORDER by dea.location_, dea.date_) as ROlling_Vaccinations
FROM public."CovidDeaths" AS dea
JOIN public."CovidVaccinations" AS vac
	ON dea.location_ = vac.location_
	AND dea.date_ = vac.date_
WHERE dea.continent is not null 
AND dea.location_ not like '%income%';

select *
From PercentPopulationVaccinated
