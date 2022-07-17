-- Pull deaths data that we're using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `coursera-1-352723.covid_data.covid_deaths`
ORDER BY 1,2;

-- Look at total cases vs deaths
-- Shows the likelihood of the avg American dying
SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) AS death_percentage
FROM `coursera-1-352723.covid_data.covid_deaths`
WHERE location = "United States"
ORDER BY 1,2;

--Look at the total cases vs the population
-- Shows the percentage of American population that got covid
SELECT location, date, total_cases, population, ROUND((total_cases/population)*100, 2) AS case_percentage
FROM `coursera-1-352723.covid_data.covid_deaths`
WHERE location = "United States"
ORDER BY 1,2;

--Look at countries with highest infection rate
SELECT location, MAX(total_cases) AS highest_infection_count, population, MAX(ROUND((total_cases/population)*100, 2)) AS infection_percentage
FROM `coursera-1-352723.covid_data.covid_deaths`
GROUP BY location, population
ORDER BY infection_percentage DESC;

-- Showing countries with highest death count per population
SELECT location, MAX(total_deaths) AS death_count
FROM `coursera-1-352723.covid_data.covid_deaths`
WHERE continent is not null
GROUP BY location 
ORDER BY death_count DESC;

-- Showing continents with highest death count per population
SELECT location, MAX(total_deaths) AS death_count
FROM `coursera-1-352723.covid_data.covid_deaths`
WHERE continent is null
GROUP BY location 
ORDER BY death_count DESC;

-- Global numbers by day
SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM `coursera-1-352723.covid_data.covid_deaths`
WHERE continent is not null
GROUP BY date
ORDER BY 1,2;

-- Global numbers updated
SELECT  SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM `coursera-1-352723.covid_data.covid_deaths`
WHERE continent is not null
ORDER BY 1,2;

-- Join vaccination and death data
SELECT *
FROM coursera-1-352723.covid_data.covid_deaths dth
JOIN coursera-1-352723.covid_data.covid_vaccinations vax
  ON dth.location = vax.location
  AND dth.date = vax.date;

-- Looking at total population vs vaccinations
SELECT dth.continent, dth.location, dth.date, dth.population, vax.new_vaccinations
, SUM(CAST(vax.new_vaccinations as int)) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date)
as rolling_people_vaccinated
FROM coursera-1-352723.covid_data.covid_deaths dth
JOIN coursera-1-352723.covid_data.covid_vaccinations vax
  ON dth.location = vax.location
  AND dth.date = vax.date
WHERE dth.continent is not null
ORDER BY 2,3;

-- Use CTE
WITH pop_vs_vax as (
  SELECT dth.continent, dth.location, dth.date, dth.population, vax.new_vaccinations
, SUM(CAST(vax.new_vaccinations as int)) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date)
as rolling_people_vaccinated
FROM coursera-1-352723.covid_data.covid_deaths dth
JOIN coursera-1-352723.covid_data.covid_vaccinations vax
  ON dth.location = vax.location
  AND dth.date = vax.date
WHERE dth.continent is not null
--ORDER BY 2,3
)
SELECT *, (rolling_people_vaccinated/population)*100 AS rolling_vax_percentage
FROM pop_vs_vax




















