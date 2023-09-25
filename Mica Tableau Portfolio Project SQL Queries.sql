-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From public."CovidDeaths"
--Where location_ like '%states%'
where continent is not null 
--Group By date_
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From public."CovidDeaths"
----Where location_ like '%states%'
--where location_ = 'World'
----Group By date_
--order by 1,2


-- 2. 

-- We take these out as they are not included in the above queries and want to stay consistent
-- European Union is part of Europe

Select location_, SUM(cast(new_deaths as int)) as TotalDeathCount
From public."CovidDeaths"
--Where location_ like '%states%'
Where continent is null 
and location_ not in ('World', 'European Union', 'International')
Group by location_
order by TotalDeathCount desc


-- 3.

Select Location_, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From public."CovidDeaths"
--Where locationL like '%states%'
Group by Location_, Population
order by PercentPopulationInfected desc


-- 4.


Select Location_, Population,date_, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From public."CovidDeaths"
--Where location_ like '%states%'
Group by Location_, Population, date_
order by PercentPopulationInfected desc


