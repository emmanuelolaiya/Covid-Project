--This is a covid19 data/dashboard project.
--Step 1: Dowbload the covid19 data
--Step 2: Load the covid19 data to a database (SQL Server)
--Step 3: Create dashboard and publish it!

--converting data type 
  ALTER TABLE [Emade].[dbo].[CovidDeaths]
  ALTER COLUMN total_deaths FLOAT


--create view to fix the null value and change data types for varchar to int or float
CREATE VIEW vw_TotalDeaths
as  SELECT   [location],
  CASE WHEN total_deaths IS NULL THEN 0 ELSE total_deaths END AS TotalDeathCount
  --MAX(COALESCE (total_deaths, 0)) AS TotalDeathCount
  FROM [Emade].[dbo].[CovidDeaths]




  --Looking at countries with highest infection rate compared to population by dates
SELECT LOCATION, POPULATION, date, MAX(TOTAL_CASES) AS HighestInfectionCount, MAX(Total_Cases/Population)* 100 as PercentPopulationInfected
From CovidDeaths
group by location, population, [date]
order by PercentPopulationInfected desc;

  --Looking at countries with highest infection rate compared to population
SELECT LOCATION, POPULATION,  MAX(TOTAL_CASES) AS HighestInfectionCount, MAX(Total_Cases/Population)* 100 as PercentPopulationInfected
From CovidDeaths
group by location, population
order by PercentPopulationInfected desc;
 

   --Looking at continent with highest infection rate compared to population
SELECT LOCATION,
 SUM(CASE WHEN NEW_DEATHS IS NULL THEN 0 ELSE NEW_DEATHS END) AS TotalDeathCount
From CovidDeaths
where continent is null 
and location not in ('World','European_Union','International')
group by location
order by TotalDeathCount desc;


   --Looking at GLOBAL
SELECT SUM(new_cases) AS Total_New_Cases
  ,SUM(new_deaths) AS Total_New_Deaths
  ,SUM(new_deaths)/SUM(new_cases) * 100 as DeathPercentage
From CovidDeaths
where continent is not null;
