-- Data Expolration Portfolio--

select *
from coviddeaths
order by 3,4

select *
from covidvaccination
order by 3,4


-- Selecting data to use

select continent, location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
where continent is not null and date is not null
order by 1,2,3


-- Total Cases Vs Total Deaths-- (The probability of dying if infected)

select continent, location, date, total_cases AllCases, total_deaths Alldeaths, (total_deaths/total_cases)*100 percentageDeaths
from coviddeaths
where continent is not null and date is not null
order by 1,2,3

-- Total Cases Vs Total Deaths-- (The probability of dying if infecte in Nigeria)

select continent, location, date, total_cases AllCases, total_deaths Alldeaths, (total_deaths/total_cases)*100 percentageDeaths
from coviddeaths
where continent is not null and date is not null
and location = 'Nigeria'
order by 1,2,3


-- Total Cases Vs Total Deaths by location 

select continent, location,sum(total_cases) AllCases, sum(total_deaths) Alldeaths, ( sum(total_deaths)/sum(total_cases))*100 percentageDeaths
from coviddeaths
where continent is not null and date is not null
group by continent, location
order by 1,2

-- Total Cases Vs Population (percentage of people infected)

select continent,location, date, population, total_cases, (total_cases/population)*100 percentageInfection
from coviddeaths
where continent is not null and date is not null
--and location = 'Nigeria'
order by 1,2,3

-- Looking at countries with highest infection rate compared to population	

select continent, location, max(population) Population, sum(new_cases) AllCases, (sum(new_cases)/max(population))*100 InfectionRate
from coviddeaths
where continent is not null and date is not null
--and location = 'Nigeria'
group by continent, location
order by InfectionRate desc

-- or 

select continent, location, population, max(total_cases) HighestCases, max((total_cases)/population)*100 RateofInfection
from coviddeaths
where continent is not null and date is not null
--and location = 'Nigeria'
group by continent, location, population
order by RateofInfection desc


-- showing countries with the highest deaths

select continent, location, max(total_deaths) highestdeaths
from coviddeaths
where continent is not null and date is not null
--and location = 'Nigeria'
group by continent, location
order by highestdeaths desc

-- Breaking it down by Continent

select continent,max(total_deaths) ContinentalDeaths
from coviddeaths
where continent is not null
group by continent
order by ContinentalDeaths desc


-- continent with the highest death count per population

select continent, sum(population) TotalPopulation, sum(new_deaths) highestdeaths, (sum(total_deaths)/sum(population))*100 DeathPerContinent
from coviddeaths
where continent is not null
group by continent
order by DeathPerContinent desc

-- GLOBAL NUMBERS

-- Cases and Deaths per day
select date, sum(new_cases) globalcases, sum(new_deaths) globaldeaths--, sum(new_deaths)/sum(new_cases)*100 globalpercentage
from coviddeaths
where continent is not null
group by date
order by date

--- Total Golbal Cases and Deaths

select sum(new_cases) globalcases, sum(new_deaths) globaldeaths--, sum(new_deaths)/sum(new_cases)*100 globalpercentage
from coviddeaths
where continent is not null 
--group by date
--order by date


--Looking at total popuplation Vs vaccination

select CovD.continent, CovD.location, max(population) TotalPopulation, sum(new_vaccinations) as TotalVac, sum(new_vaccinations)/max(population)*100 as PopVac
from coviddeaths CovD
inner join covidvaccination CovV
on CovD.location = CovV.location
and CovD.date = CovV.date
where  CovD.continent is not null
group by CovD.continent,CovD.location
order by 1,2



select CovD.continent, CovD.location, CovD.date, CovD.population, CovV.new_vaccinations,
sum(CovV.new_vaccinations) over (partition by CovD.location order by CovD.location,CovD.date) CumVac 
from coviddeaths CovD
inner join covidvaccination CovV
on CovD.location = CovV.location
and CovD.date = CovV.date
where  CovD.continent is not null
order by 2,3

-- Looking at Cummulative percentage of people vaccinated	

-- Using CTE

with PopVsVac (continent,location,date,population,new_vaccination,CumVac)
as
(select CovD.continent, CovD.location, CovD.date, CovD.population, CovV.new_vaccinations,
sum(CovV.new_vaccinations) over (partition by CovD.location order by CovD.location,CovD.date) CumVac 
from coviddeaths CovD
inner join covidvaccination CovV
on CovD.location = CovV.location
and CovD.date = CovV.date
where  CovD.continent is not null
--order by 2,3
)
select *, CumVac/population*100
from PopVsVac

--And using tempTable

drop table if exists #PopVac
create table #PopVac
(continent nvarchar(50),
location nvarchar(50),
date datetime,
population numeric,
new_vaccination numeric,
CumVac numeric)

insert into #PopVac
select CovD.continent, CovD.location, CovD.date, CovD.population, CovV.new_vaccinations,
sum(CovV.new_vaccinations) over (partition by CovD.location order by CovD.location,CovD.date) CumVac 
from coviddeaths CovD
inner join covidvaccination CovV
on CovD.location = CovV.location
and CovD.date = CovV.date
where  CovD.continent is not null
--order by 2,3

select *, CumVac/population*100
from #PopVac

--Creating views to store data for later visualization

create view PopVacGlobal as
select CovD.continent, CovD.location, CovD.date, CovD.population, CovV.new_vaccinations,
sum(CovV.new_vaccinations) over (partition by CovD.location order by CovD.location,CovD.date) CumVac 
from coviddeaths CovD
inner join covidvaccination CovV
on CovD.location = CovV.location
and CovD.date = CovV.date
where  CovD.continent is not null

select *
from PopVacGlobal

create view GlobalCovDeaths as
select continent, sum(population) TotalPopulation, sum(new_deaths) highestdeaths, (sum(total_deaths)/sum(population))*100 DeathPerContinent
from coviddeaths
where continent is not null
group by continent
--order by DeathPerContinent desc

select *
from GlobalCovDeaths
order by DeathPerContinent desc
