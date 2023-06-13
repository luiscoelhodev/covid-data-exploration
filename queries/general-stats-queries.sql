SELECT *
FROM Covid19Data..GeneralStats
WHERE location LIKE '%STATES'
ORDER BY location, date