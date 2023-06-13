-- 1. A summary of COVID-19 vaccination data for each country, including:
-- Total Doses Administered: The overall number of COVID-19 vaccine doses given (total_vaccinations).
-- People Vaccinated: The number of individuals who received at least one vaccine dose (people_vaccinated).
-- Fully Vaccinated: The count of individuals who completed the recommended vaccine regimen (people_fully_vaccinated).

SELECT location, 
MAX(CAST(total_vaccinations AS bigint)) AS total_vaccinations,
MAX(CAST(people_vaccinated AS bigint)) AS people_vaccinated,
MAX(CAST(people_fully_vaccinated AS bigint)) AS people_fully_vaccinated
FROM Covid19Data..CovidVaccinationStats
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY location;

-- 2. Vaccination rate over population for all countries, encompassing individuals who have received at least 
-- one COVID-19 vaccine dose and those who are fully vaccinated.
-- I also included the death rate for all countries so it is possible to analyze the impact vaccination had on deaths.

WITH CTE_TotalDeaths AS (
	SELECT location, 
	ROUND(MAX(CAST(total_deaths AS float))/MAX(population)*100, 2) AS total_deaths_per_population
	FROM Covid19Data..CovidStats
	WHERE continent IS NOT NULL
	GROUP BY location
	)
SELECT vac.location, 
ROUND(MAX(CAST(people_vaccinated AS float))/MAX(vac.population)*100, 2) AS people_vaccinated_rate_per_population,
ROUND(MAX(CAST(people_fully_vaccinated AS float))/MAX(vac.population)*100, 2) AS people_fully_vaccinated_rate_per_population,
ctd.total_deaths_per_population
FROM Covid19Data..CovidVaccinationStats vac
JOIN CTE_TotalDeaths ctd
ON vac.location = ctd.location
WHERE vac.continent IS NOT NULL
GROUP BY vac.location, ctd.total_deaths_per_population
ORDER BY ctd.total_deaths_per_population;

-- 3. Countries that administered COVID-19 vaccine doses per day, considering the new_vaccinations 
-- per population percentage, from FASTEST to SLOWEST over time.

SELECT location, date, new_vaccinations, population, 
ROUND((CAST(new_vaccinations AS float)/population)*100, 2) AS new_doses_population_percentage
FROM Covid19Data..CovidVaccinationStats
WHERE continent IS NOT NULL AND new_vaccinations IS NOT NULL
ORDER BY new_doses_population_percentage DESC;

-- 4. Comparing each country in terms of their fully vaccinated population with the global average.

DROP TABLE IF EXISTS #TempPopulationVaccinatedPercentage
CREATE TABLE #TempPopulationVaccinatedPercentage (
location nvarchar(255),
population_vaccinated_percentage float
)

INSERT INTO #TempPopulationVaccinatedPercentage
SELECT location,
ROUND((MAX(CAST(people_fully_vaccinated AS float)) / MAX(population))*100, 2) AS population_vaccinated_percentage
FROM Covid19Data..CovidVaccinationStats
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY population_vaccinated_percentage DESC

SELECT vac.location,
ROUND((MAX(CAST(people_fully_vaccinated AS float)) / MAX(population))*100, 2) AS population_vaccinated_percentage,
(SELECT ROUND(AVG(population_vaccinated_percentage), 2)
FROM #TempPopulationVaccinatedPercentage) AS avg_percentage_population_vaccinated,
    CASE
        WHEN ROUND((MAX(CAST(people_fully_vaccinated AS float)) / MAX(population)) * 100, 2) > (SELECT ROUND(AVG(population_vaccinated_percentage), 2)
                                                                                              FROM #TempPopulationVaccinatedPercentage)
            THEN 'HIGHER than average'
        WHEN ROUND((MAX(CAST(people_fully_vaccinated AS float)) / MAX(population)) * 100, 2) < (SELECT ROUND(AVG(population_vaccinated_percentage), 2)
                                                                                              FROM #TempPopulationVaccinatedPercentage)
            THEN 'LOWER than average'
		WHEN ROUND((MAX(CAST(people_fully_vaccinated AS float)) / MAX(population)) * 100, 2) IS NULL
			THEN 'No data to compare!'
        ELSE 'Equal to average'
    END AS comparison_with_average
FROM Covid19Data..CovidVaccinationStats vac
JOIN #TempPopulationVaccinatedPercentage popper
ON vac.location = popper.location
WHERE continent IS NOT NULL
GROUP BY vac.location
ORDER BY vac.location

-- 5. Rolling average of new vaccinations per day in the USA, considering the previous 7 days. 
SELECT location, date, new_vaccinations,
    AVG(CAST(new_vaccinations AS int)) OVER (PARTITION BY location ORDER BY date ROWS BETWEEN 7 PRECEDING AND CURRENT ROW) AS rolling_average
FROM Covid19Data..CovidVaccinationStats
WHERE continent IS NOT NULL AND location LIKE '%states'
ORDER BY location;

-- 6. Exploring the daily vaccination progress for the USA by calculating the percentage of people 
-- vaccinated on each day compared to the total number of people vaccinated in that country.
SELECT location, date, people_vaccinated,
    (CAST(people_vaccinated AS float) / SUM(CAST(people_vaccinated AS float)) OVER (PARTITION BY location)) * 100 AS vaccination_percentage
FROM Covid19Data..CovidVaccinationStats
WHERE continent IS NOT NULL AND location LIKE '%states';
