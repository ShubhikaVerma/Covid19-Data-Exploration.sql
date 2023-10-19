--SELECT *
--FROM PortfolioProject..CovidDeaths$
--ORDER BY location desc

--SELECT *
--FROM PortfolioProject..CovidVaccinations$
--ORDER BY 3,4

SELECT location,date,total_cases,new_cases,total_deaths
FROM PortfolioProject..CovidDeaths$
ORDER BY 1,2

--Total Cases vs Total Deaths
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths$
WHERE location LIKE '%ndia'
ORDER BY 1,2

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths$
WHERE location LIKE '%dia'
ORDER BY 1,2

 --Countries with Highest Infection Rate
 Select Location,  MAX(total_cases) as HighestInfectionCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
WHERE continent is  not null
GROUP by Location
ORDER BY location

--Continents with highest infection rate
Select Location,  MAX(total_cases) as HighestInfectionCount
From PortfolioProject..CovidDeaths$
WHERE continent is   null
GROUP by Location
ORDER BY location

--CASES ANALYSIS ACROSS THE WORLD BY DATE
SELECT date,SUM(new_cases) AS Total_case,SUM(CAST(new_deaths as int))AS Total_death,(SUM(CAST(new_deaths as int))/SUM(new_cases))*100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

---ACROSS THE WORLD
SELECT SUM(new_cases) AS Total_case,SUM(CAST(new_deaths as int))AS Total_death,(SUM(CAST(new_deaths as int))/SUM(new_cases))*100 AS Death_Percentage
FROM PortfolioProject..CovidDeaths$
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2



--SELECT *
--FROM PortfolioProject..CovidVaccinations$
--ORDER BY 3,4


---Combined Stats
Select *
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


---- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date,vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


---CREATE TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date,  vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date


	Select *
From #PercentPopulationVaccinated
