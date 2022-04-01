*/
This will be a COVID 19 Data Exploration 
The skills used are: Joins,CTE, Temptables, windows Function, Aggregate functions, creating views, Converting data types 
*/
select *
from portfolioproject..coviddeaths
where continent is not null 
order by 3,4

--select *
--from portfolioproject..covidvaccinations
--order by 3,4

-- we will be selecting the data that we are going to be using 

select location, date, total_cases, new_cases, total_deaths, population 
from portfolioproject..coviddeaths
where continent is not null 
order by 1,2

-- Observing the total cases Vs total deaths 
-- This shows the likelihood of dying if you contract Covid within your country. 

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolioproject..coviddeaths
where location like '%states%'
and continent is not null 
order by 1,2

-- Looking at the total Cases Vs Population
-- Shows what percentage of populaion reviced Covid

select location, date, total_cases,population, (total_cases/population)*100 as PercentPopulationInfected
from portfolioproject..coviddeaths
--where location like '%states%'
where continent is not null 
order by 1,2

--- Obeserving at what Countires with the Highest Infection rate compared to Population.


select location, population, max(total_cases) as Highestinfectioncount, max((total_cases/population))*100 as PercentPopulationInfected
from portfolioproject..coviddeaths
--where location like '%states%'
where continent is not null 
group by contient, population
order by PercentPopulationInfected desc

--- The data will convey the highest Death Count per population 

select location,  max(cast(total_cases as int)) as TotalDeathsCount
from portfolioproject..coviddeaths
--where location like '%states%'
where continent is not null 
group by continent
order by TotalDeathsCount desc

--- We will be breaking down the data by Continent 



-- Reveal the Continents with the highest death count per population 

select Continent,  max(cast(total_cases as int)) as TotalDeathsCount
from portfolioproject..coviddeaths
--where location like '%states%'
where continent is not null 
group by Continent
order by TotalDeathsCount desc

-- This Data will indicate the Global Numbers 

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage 
from portfolioproject..coviddeaths
where continent is not null 
group by date 
order by 1,2

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage 
from portfolioproject..coviddeaths
where continent is not null 
--group by date 
order by 1,2

select*
from portfolioproject..covideaths dea 
join protfolioproject..covidvaccinations vac
on dea.loaction = vac. loaction 
and dea.date = vac.date 

-- Focusing at total Population vs Vaccinations
-- Shows The Prentage of population that has recieved at least one COVID vaccine 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea. date = vac.date 
where dea.continent is not null 
order by 2,3

-- We will be using CTE to perform calcualtions on partition by the previous query 

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

-- We will be creating a Temp Table form the previous query 

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)
 insert into #PercentPopulationVaccinated
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea. date = vac.date 
--where dea.continent is not null 
--order by 2,3

Select *, (rollingpeoplevaccinated/population)*100
from #PercentPopulationVaccinated

--- We will be creating view to store data for later visualizations 

create view percentpopualtionvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated
--, (rollingpeoplevaccinated/population)*100
from portfolioproject..coviddeaths dea
join portfolioproject..covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select * 
from percentpopualtionvaccinated
