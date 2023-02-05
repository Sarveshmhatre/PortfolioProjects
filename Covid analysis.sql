Select *
From dbo.['covidDeaths]         
where continent is not null     ---- covid death table

select *
From dbo.['covidvaccination]    ---- covid vaccination table 


Select location, date, total_cases, new_cases, total_deaths ,population
From Portfolioproject..['covidDeaths]
where location = 'india'                    ---- overall exploration in india
order by 1,2;

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
From Portfolioproject..['covidDeaths]
where location like '%india%'
order by 1,2;                               ---- total deaths vs total cases in india

Select location, date, total_cases,population, (total_cases/population)*100 as deathpercentage
From Portfolioproject..['covidDeaths]
where location like '%india%'
order by 1,2;                               ---- total cases vs population in india 

Select location, max(total_cases) as Highestcovidcount,population, max((total_cases/population))*100 as Percentpopulationinfected
From ['covidDeaths]
--where location like '%india%
group by location, population 
order by Percentpopulationinfected desc          ---- Countries with highest infected rate compared to population

Select location, max(cast(total_deaths as int)) as Totaldeathcount
From ['covidDeaths]
--where location like '%india%
where continent is not null
group by location 
order by Totaldeathcount desc                   ---- Countries with highest death count per population  
 
Select continent, max(cast(total_deaths as int)) as Totaldeathcount
From ['covidDeaths]
--where location like '%india%
where continent is not null
group by continent
order by Totaldeathcount desc                   ---- total death count by continent 


Select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(New_cases)*100 as Deathpercentage
From ['covidDeaths]
--where location like '%india%
where continent is not null
--group by continent
order by 1,2                                   ---- Global numbers



select ['covidDeaths].continent, ['covidDeaths].location, ['covidDeaths].date, ['covidDeaths].population, ['covidvaccination].new_vaccinations
From ['covidDeaths]
join ['covidvaccination]
  on ['covidDeaths].location = ['covidvaccination].location
  and ['covidDeaths].date = ['covidvaccination].date
where ['covidDeaths].continent is not null
order by 2,3                                                     ---- Total population vs Vaccinations


Create view PercentPopulationvaccinated as
Select ['covidDeaths].continent, ['covidDeaths].location, ['covidDeaths].date, ['covidDeaths].population, ['covidvaccination].new_vaccinations
, SUM(CONVERT(BIGINT, ['covidvaccination].new_vaccinations)) OVER (Partition by ['covidDeaths].location Order by ['covidDeaths].location, 
['covidDeaths].date) as RollingPeopleVaccinated
From ['covidDeaths]
join ['covidvaccination] 
on ['covidDeaths].location = ['covidvaccination].location
and ['covidDeaths].date = ['covidvaccination].date
where ['covidDeaths].continent  is not null                       ---- Created View as  PercentPopulationvaccinated


SELECT TOP (1000) [continent]
      ,[location]
      ,[date]
      ,[population]
      ,[new_vaccinations]
      ,[RollingPeopleVaccinated]
  FROM [Portfolioproject].[dbo].[PercentPopulationvaccinated]     ---- checking VIEW table 


