-- This dataset contains a 'location' column that primarily includes country names, but in some cases, it groups
-- them by continents or income. To distinguish between countries and other groups, a 'continent' column is 
-- provided. For country entries in the 'location' column, the corresponding 'continent' value indicates the 
-- continent. However, when multiple countries are grouped together, the 'continent' value is NULL. 
-- To retrieve specific information only for countries, a WHERE statement can be added to filter for cases 
-- where the 'continent' value is NOT NULL.

-- 1. Countries reporting the highest number of COVID-19 cases.

SELECT location, MAX(CAST(total_cases AS bigint)) AS TotalCasesOverall
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalCasesOverall DESC;

-- 2. Countries recording the highest number of COVID-19 deaths.

SELECT location, MAX(CAST(total_deaths AS bigint)) AS TotalDeathsOverall
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathsOverall DESC;

-- 3. Countries conducting the greatest number of COVID-19 tests.

SELECT location, MAX(CAST(total_tests AS bigint)) AS TotalTestsOverall
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalTestsOverall DESC;

-- 4. Highest number of COVID-19 cases grouped by continents.

SELECT location, MAX(CAST(total_cases AS bigint)) AS TotalCasesOverall
FROM Covid19Data..CovidStats
WHERE continent IS NULL AND location IN ('Africa', 'Asia', 'Europe', 'North America', 'South America', 'Oceania')
GROUP BY location
ORDER BY TotalCasesOverall DESC;

-- 5. Highest number of COVID-19 deaths grouped by continents.

SELECT location, MAX(CAST(total_deaths AS bigint)) AS TotalDeathsOverall
FROM Covid19Data..CovidStats
WHERE continent IS NULL AND location IN ('Africa', 'Asia', 'Europe', 'North America', 'South America', 'Oceania')
GROUP BY location
ORDER BY TotalDeathsOverall DESC;

-- 6. COVID-19 case fatality rate (total_deaths / total_cases) trend over time in all countries.
-- Likelihood of dying if a person contracts COVID-19.
SELECT location, date, total_deaths, total_cases, ROUND((CAST(total_deaths AS float) / CAST(total_cases AS float))*100, 2) AS case_fatality_rate
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL
ORDER BY location, date;

-- 7. Countries with the highest COVID-19 case fatality rates and the corresponding dates.
-- Highest likelihood of dying ordered by country and date.

SELECT location, date, total_deaths, total_cases, ROUND((CAST(total_deaths AS float) / CAST(total_cases AS float))*100, 2) AS case_fatality_rate
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL
ORDER BY case_fatality_rate DESC, date;

-- 8. Percentage of all countries' population infected with COVID-19 over time.

SELECT location, date, total_cases, population, ROUND((CAST(total_cases AS float) / population)*100, 3) AS percentage_population_infected
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL
ORDER BY location, date;

-- 9. Countries with the highest COVID-19 death rate per population.
-- Percentage of population that died from COVID-19 from highest to lowest.

SELECT location, 
MAX(CAST(total_deaths AS bigint)) AS total_deaths_overall, 
MAX(CAST(population AS bigint)) AS population_overall, 
ROUND((MAX(CAST(total_deaths AS float))/MAX(population))*100, 2) AS death_rate_per_population
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_rate_per_population DESC;

-- 10. Countries with highest COVID-19 infection rate per population.
-- Percentage of population that was infected by COVID-19 from highest to lowest.
-- This information may be innacurate because a single person may have been infected more than once.

SELECT location, 
MAX(CAST(total_cases AS bigint)) AS total_cases_overall, 
MAX(CAST(population AS bigint)) AS population_overall, 
ROUND((MAX(CAST(total_cases AS float))/MAX(population))*100, 2) AS infection_rate_per_population
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY infection_rate_per_population DESC;

-- 11. Countries that have conducted the most COVID-19 testing relative to their population size.
-- For the countries that have a higher rate than 100: it does not mean all the population was tested, but it
-- is a great indicator that a great number of tests was conducted to track the spread of the disease.
-- In this query, I also added the columns 'death_rate_per_capita' and 'infection_rate_per_capita' so we are able
-- to analyze how much the effort of a country to track the spread of the disease impacted on those rates.

SELECT location, 
MAX(CAST(population AS bigint)) AS population_overall,
MAX(CAST(total_tests AS bigint)) AS total_tests_overall, 
MAX(CAST(total_cases AS bigint)) AS total_cases_overall,
MAX(CAST(total_deaths AS bigint)) AS total_deaths_overall,
ROUND((MAX(CAST(total_tests AS float))/MAX(population))*100, 2) AS testing_rate_per_population,
ROUND((MAX(CAST(total_deaths AS float))/MAX(population))*100, 2) AS death_rate_per_population,
ROUND((MAX(CAST(total_cases AS float))/MAX(population))*100, 2) AS infection_rate_per_population
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY testing_rate_per_population DESC;

-- 12. Progression of COVID-19 cases within each country to understand their relative contribution 
-- to the overall cases over time.

SELECT location, date, total_cases,
    SUM(CAST(total_cases AS bigint)) OVER (PARTITION BY location ORDER BY date) AS cumulative_cases,
    (CAST(total_cases AS float) / SUM(CAST(total_cases AS float)) OVER (PARTITION BY date)) * 100 AS percentage_contribution
FROM Covid19Data..CovidStats
WHERE continent IS NOT NULL;