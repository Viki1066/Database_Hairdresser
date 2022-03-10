
-- SMRTNOST U ODNOSU NA SLUČAJEVE COVIDA-19 U HRVATSKOJ

SELECT location,date,total_cases,total_deaths,(cast(total_deaths as float)/cast(total_cases as float)*100) as DeathPercentage
FROM [dbo].[CovidDeaths$]
where location = 'croatia'
ORDER BY 1,2

-- uKUPNO SLUČAJEVA U ODNOSU NA POPULACIJU

SELECT 
location, date, total_cases,population, (cast(total_cases as float) / cast(population as float) *100) as PopulationPercentage
from [dbo].[CovidDeaths$]
--WHERE location = 'croatia'
order by 1,2

-- TRAŽIMO ZEMLJE S NAJVEĆIM POSTOTKO ZARAZA U ODNOSU NA POPULACIJU

SELECT 
location,population,max(cast(total_cases as float)) AS HighetsnfesctionCount, 
Max((cast(total_cases as float) / cast(population as float) *100)) as PopulationPercentage
from [dbo].[CovidDeaths$]
group by location,population
order by PopulationPercentage desc

--Kontinenti s najvećim brojem smrtnih slučajeva

SELECT 
continent,max(cast(total_deaths as float)) AS TotalDeathCount
from [dbo].[CovidDeaths$]
where continent is not null
group by continent
order by TotalDeathCount desc


-- zemlje s najveći brojem smrtnosti u odnosu na populaciju

SELECT 
location,max(cast(total_deaths as float)) AS TotalDeathCount
from [dbo].[CovidDeaths$]
where continent is not null
group by location
order by TotalDeathCount desc

--globalne brojke

SELECT 
SUM(cast(new_cases as float)) as TotaNewCase,
SUM(cast(new_deaths as float)) as TotalDeath,sum(cast(new_deaths as float))/sum(cast(new_cases as float)) *100 as Percentage--total_cases,total_deaths,(cast(total_deaths as float)/cast(total_cases as float)*100) as DeathPercentage
FROM [dbo].[CovidDeaths$]
--where location = 'croatia'
where continent is not null
--GROUP BY date
ORDER BY 1,2 

--- ukupn populacija vs cijepljena populacija

Select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations, SUM(cast(vac.new_vaccinations as FLOAT)) OVER (PARTITION BY DEA.LOCATION order by dea.location ,dea.date) as RollingPeopleVacc
from
[dbo].[CovidDeaths$] dea
join [dbo].[CovidVactiantions$] vac
ON
dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

With PopvsVac (Continet,Location,date,population,RollingPeopleVacc,new_vaccinations)
as
(
Select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations, SUM(cast(vac.new_vaccinations as FLOAT)) OVER (PARTITION BY DEA.LOCATION order by dea.location ,dea.date) as RollingPeopleVacc
from
[dbo].[CovidDeaths$] dea
join [dbo].[CovidVactiantions$] vac
ON
dea.location = vac.location
and dea.date = vac.date
where dea.continent is NOT NULL
--order by 2,3
)

select *,(RollingPeopleVacc)/cast(population as float)*100 from PopvsVac

--tem table

create Table #PercentPopulationVaccinated

(
Continent nvarchar(255),
Loacation nvarchar (255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVacc numeric
)
insert into #PercentPopulationVaccinated

Select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations, SUM(cast(vac.new_vaccinations as FLOAT)) OVER (PARTITION BY DEA.LOCATION order by dea.location ,dea.date) as RollingPeopleVacc
from
[dbo].[CovidDeaths$] dea
join [dbo].[CovidVactiantions$] vac
ON
dea.location = vac.location
and dea.date = vac.date
where dea.continent is NOT NULL
--order by 2,3
select *,(RollingPeopleVacc)/cast(population as float)*100 from #PercentPopulationVaccinated

--Creatina view

Create View PercentPopulationVaccinated
as
Select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations, SUM(cast(vac.new_vaccinations as FLOAT)) OVER (PARTITION BY DEA.LOCATION order by dea.location ,dea.date) as RollingPeopleVacc
from
[dbo].[CovidDeaths$] dea
join [dbo].[CovidVactiantions$] vac
ON
dea.location = vac.location
and dea.date = vac.date
where dea.continent is NOT NULL
--order by 2,3

