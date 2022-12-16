Select *
From PortfolioProject..CovidDeaths
Where continent is not null

--Select *
--From dbo.CovidVaccinations
--Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null

--Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null
Order by 1,2

--data shows the likelihood of drying if contract covid

--Next, total cases vs population

Select Location, date, population, total_cases,(total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Order by 1,2

--Countries with highest infection rate campared to population

Select Location, population, MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as percentpopulationinfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by location, population
Order by percentpopulationinfected desc

--MAX Total Death 

Select Location, MAX(cast(total_deaths as int)) as TotalDeath
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by location
Order by TotalDeath desc

--Continent

Select continent, MAX(cast(total_deaths as int)) as TotalDeath
FROM PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeath desc


Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null
Order by 1,2


Select date, Sum(new_cases), SUM(cast(new_deaths as int))--total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by date
Order by 1,2

Select Sum(new_cases) as totalcases, SUM(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
--Group by date
Order by 1,2

---CovidVaccinations
with PopvsVac (Continent, Location, Date, Population, new_vaccinations, rolling_people_vac)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rolling_people_vac
--(rolling_people_vac/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null 
--order by 2,3
)
Select *, (rolling_people_vac/Population)*100
From PopvsVac

--Table

drop table if exists PercentPopulationVaccinated

Create Table PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
rolling_people_vac numeric
)

insert into PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rolling_people_vac
--(rolling_people_vac/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--Where dea.continent is not null 
--order by 2,3

Select *, (rolling_people_vac/Population)*100
From PercentPopulationVaccinated




--creating data for visualiztion



Create view PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int, vac.new_vaccinations)) over(partition by dea.location order by dea.location, dea.date) as rolling_people_vac
--(rolling_people_vac/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null 
--order by 2,3

-----------

Select *
From PercentPopulationVaccinated


---Tableau 1 

Select Sum(new_cases) as totalcases, SUM(cast(new_deaths as int)) as totaldeaths, sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
--Group by date
Order by 1,2

--Tableau 2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


--Tableau 3

Select Location, population, MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as percentpopulationinfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by location, population
Order by percentpopulationinfected desc

---Tableau 4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

