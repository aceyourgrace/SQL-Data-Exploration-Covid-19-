
-- Looking at the data from Covid Vaccinations

select * from CovidVaccinations

--Let's join the two datasets on location and date

select * from CovidDeaths Dea
join CovidVaccinations Vacc
on Dea.location = Vacc.location
and Dea.date = Vacc.date


--Selecting specific columns from both the datasets where continent is not null

select Dea.date, Dea.location, Dea.continent, Dea.population, Vacc.new_vaccinations
from CovidDeaths Dea join CovidVaccinations Vacc
on Dea.location = Vacc.location
and Dea.date=Vacc.date
where Dea.continent is not null
order by 2,1

--Creating a new column that gives the cumulative sum of the new vaccinations based on location

select Dea.location, Dea.date, Dea.continent, Dea.population, Vacc.new_vaccinations
, Sum(cast(Vacc.new_vaccinations as float)) over (partition by Dea.location order by Dea.location, Dea.Date) as RollingPeopleVaccinated
from CovidDeaths Dea join CovidVaccinations Vacc
on Dea.location = Vacc.location
and Dea.date=Vacc.date
where Dea.continent is not null
order by 1,2

--Creating a Percentage column that shows the percentage of the people vaccinated in a certain location/country. For this, we need to create a temp table or a CTE

--Using CTE

with PopvsVacc (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select Dea.continent, Dea.location, Dea.date, Dea.population, Vacc.new_vaccinations
, sum(cast(Vacc.new_vaccinations as float)) over (partition by Dea.location order by Dea.location, Dea.Date) as RollingPeopleVaccinated
from CovidDeaths Dea join CovidVaccinations Vacc
on Dea.location = Vacc.location
and Dea.date = Vacc.date
where Dea.continent is not null
--order by 1,2
)
Select *, (RollingPeopleVaccinated/Population) * 100 as PercentageRolling
from PopvsVacc
order by 2,3


-- Using a temp table

Create Table #PercentVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingVaccinated numeric, 
)

insert into #PercentVaccinated
Select Dea.continent, Dea.location, Dea.date, Dea.population, Vacc.new_vaccinations
, sum(cast(Vacc.new_vaccinations as float)) over (partition by Dea.location order by Dea.location, Dea.date) as RollingPeopleVaccinated
from CovidDeaths Dea join CovidVaccinations Vacc
on Dea.location = Vacc.location and Dea.date = Vacc.date
where Dea.continent is not null
order by 2


select *, (RollingVaccinated/Population)*100 as PercentageVaccinated
from #PercentVaccinated
order by 2,3

drop table #PercentVaccinated