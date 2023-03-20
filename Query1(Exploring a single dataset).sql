-- I have imported two datasets- Covid Vaccinations and Covid Deaths

-- Selecting the Data that I am going to be using from Covid Deaths Dataset and sorting it on the basis of location and death
select location, date, total_cases, new_cases, population, total_deaths
from PortfolioProjectA..CovidDeaths
order by 1,2

-- Looking into Total cases vs Total Deaths, i.e. how many cases were there in a country and out of that, how many people died. And what is the death percentage
-- For this I also need to cast the datatype of total_deaths and total_cases as float first because they are initially integers and the division will return 0 for all
-- This will only convert the datatype during runtime and the original column will remain the same
select location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
from PortfolioProjectA..CovidDeaths
order by 1,2

--OR I can first alter the columns total_cases and total_deaths as float values. This will alter the original column

-- alter table CovidDeaths alter column total_deaths int

--Now, looking at the Total cases vs Total Deaths and the Death percentage in Canada and Nepal

select location, date, total_cases, total_deaths, (cast(total_deaths as float)/ cast(total_cases as float)) * 100 as DeathPercentage
from PortfolioProjectA..CovidDeaths
where location like 'Can%' or location like 'Nepal'
order by 1, 2


-- Looking at Total Cases vs Population in Canada and the Percentage of population infected

select location, date, total_cases, population, (cast(total_cases as float)/cast(population as float))*100 as CasePercentage
from PortfolioProjectA..CovidDeaths
where location like 'Canada'
order by 1,2


--Looking at the countries with the highest infected rate

select location, population, max(total_cases) as HighestInfectedCount, max(cast(total_cases as float)/cast(population as float)) as HighestInfectedPercentage
from PortfolioProjectA..CovidDeaths
group by location, population
order by HighestInfectedCount desc

--Looking at the countries with the highest death count per population

select location, max(total_deaths) as HighestDeathCount
from PortfolioProjectA..CovidDeaths
where continent is not Null
group by location
order by HighestDeathCount desc


--Looking at continents with the highest death counts

select continent, max(total_deaths) as HighestDeathCount
from PortfolioProjectA..CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc

--Global Counts
--Looking at data with the total new cases, total new deaths, and death percentage,

select date, sum(total_cases), sum(total_deaths), (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
from portfolioProjectA..CovidDeaths
where continent is not null
group by date 
order by 1,2

--Displaying the data of all the cases on particular dates

select sum(cast(new_cases as float)) as Total_Cases, sum(cast(new_deaths as float)) as Total_Deaths, sum(cast(new_deaths as float))/sum(cast(new_cases as float)) *100 as DeathPercentage
from PortfolioProjectA..CovidDeaths
where continent is not null and new_cases <>0
group by date
order by 1,2

--Displaying the overall cases, deaths and death percentage
select sum(cast(new_cases as float)) as Total_Cases, sum(cast(new_deaths as float)) as Total_Deaths, sum(cast(new_deaths as float))/sum(cast(new_cases as float)) *100 as DeathPercentage
from PortfolioProjectA..CovidDeaths
where continent is not null and new_cases <>0
--group by date
order by 1,2









