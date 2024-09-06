

select *
from COVID..CovidDeaths$
where continent is not null
order by 3,4

--select *
--from COVID..CovidVaccinations$
--order by 3,4


--select data we are going to use

select location, date, total_cases, new_cases, total_deaths, population
from COVID..CovidDeaths$
where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths(Percentage)
--Likelyhood of dying if you contract COVID in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from COVID..CovidDeaths$
where location like '%South Africa%'
order by 1,2

--Total cases versus Total population
--Percentage of population got COVID
select location, date, total_cases, population, (total_cases/population)*100 as InfectedPopulationPercentage
from COVID..CovidDeaths$
where location like '%South Africa%'
order by 1,2

--Country with highest infection rate compared to population

select location,Population ,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as InfectedPopulationPercentage
from COVID..CovidDeaths$
--where location like '%South Africa%'
where continent is not null
Group by location, population
order by InfectedPopulationPercentage desc

--Continets with highest death count per population
select continent, MAX(cast(total_deaths as int)) as TotaDeathCount
from COVID..CovidDeaths$
--where location like '%South Africa%'
where continent is not null
Group by continent
order by TotaDeathCount desc


--GLOBAL NUMBERS

select SUM(new_cases) as total_cases, SUM(cast( new_cases as int)) as total_deaths, SUM(cast( new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from COVID..CovidDeaths$
--where location like '%South Africa%'
where continent is not null
--Group by date
order by 1,2


--Looking at Total population versus vaccination
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from COVID..CovidDeaths$ dea
join COVID..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null
Order by 2,3
