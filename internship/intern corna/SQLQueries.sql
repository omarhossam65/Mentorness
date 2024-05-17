SELECT *
FROM [dbo].[Corona Virus Dataset]
WHERE Province IS NULL
   OR Country IS NULL
   OR Latitude IS NULL
   OR Longitude IS NULL
   OR Date IS NULL
   OR Confirmed IS NULL
   OR Deaths IS NULL
   OR Recovered IS NULL;



Update [corona intern],[dbo].[Corona Virus Dataset]
SET Province = COALESCE(Province, '0'),
Country_Region = COALESCE(Country_Region, '0'),
Latitude = COALESCE(Latitude, '0'),
Longitude = COALESCE(Longitude, '0'),
Date = COALESCE(Date, '0'),
Confirmed = COALESCE(Confirmed, '0'),
Deaths = COALESCE(Deaths, '0'),
Recovered = COALESCE(Recovered, '0');



SELECT count(*) as total_rows
FROM
          [dbo].[Corona Virus Dataset];



SELECT MIN(Date) as start_date, MAX(Date) as end_date
FROM
          [dbo].[Corona Virus Dataset];



SELECT COUNT(DISTINCT MONTH(Date)) AS number_of_unique_months
FROM
          [dbo].[Corona Virus Dataset]
WHERE ISDATE(Date) = 1;



SELECT
          MONTH(Date) AS Month
          SUM(CONVERT(INT, Confirmed)) / COUNT(*) AS AVG_Confirmed,
          SUM(CONVERT(INT, Deaths)) / COUNT(*) AS AVG_Deaths,
          SUM(CONVERT(INT, Recovered)) / COUNT(*) AS AVG_Recovered
FROM
          [dbo].[Corona Virus Dataset]
GROUP BY
         MONTH(Date)
ORDER BY
         MONTH(Date);



SELECT
          MONTH(Date) AS Month
          MAX(CONFIRMED) AS MostFrequentConfirmed,
          MAX(DEATHS) AS MostFrequentDeaths,
          MAX(RECOVERED) AS MostFrequentRecovered
FROM
          [dbo].[Corona Virus Dataset]
GROUP BY
         MONTH(Date)
ORDER BY
         MONTH(Date);



SELECT
          YEAR(Date) AS Year,
          MIN(CONFIRMED) AS MinimumConfirmed,
          MIN(DEATHS) AS MinimumDeaths,
          MIN(RECOVERED) AS MinimumRecovered
FROM
         [dbo].[Corona Virus Dataset]
GROUP BY
        YEAR(Date);



SELECT
          YEAR(Date) AS Year,
          MAX(CONFIRMED) AS MaximumConfirmed,
          MAX(DEATHS) AS MaximumDeaths,
          MAX(RECOVERED) AS MaximumRecovered
FROM
         [dbo].[Corona Virus Dataset]
GROUP BY
        YEAR(Date);



SELECT 
    MONTH(Date) AS Month,
    SUM(CAST(CONFIRMED AS INT)) AS TotalConfirmed,
    SUM(CAST(DEATHS AS INT)) AS TotalDeaths,
    SUM(CAST(RECOVERED AS INT)) AS TotalRecovered
FROM 
    [dbo].[Corona Virus Dataset]
GROUP BY 
    MONTH(Date)
ORDER BY 
    MONTH(Date);



SELECT 
    COUNT(CONFIRMED) AS TotalConfirmedCases,
    AVG(CAST(CONFIRMED AS FLOAT)) AS AverageConfirmedCases,
    (
        (
            SUM(CASE WHEN ISNUMERIC(CONFIRMED) = 1 THEN CAST(CONFIRMED AS FLOAT) ELSE 0 END * 
            CASE WHEN ISNUMERIC(CONFIRMED) = 1 THEN CAST(CONFIRMED AS FLOAT) ELSE 0 END)
            / COUNT(CONFIRMED)
        )
        - AVG(CAST(CONFIRMED AS FLOAT)) * AVG(CAST(CONFIRMED AS FLOAT))
    ) AS VarianceConfirmedCases,
    SQRT(
        (
            (
                SUM(CASE WHEN ISNUMERIC(CONFIRMED) = 1 THEN CAST(CONFIRMED AS FLOAT) ELSE 0 END * 
                CASE WHEN ISNUMERIC(CONFIRMED) = 1 THEN CAST(CONFIRMED AS FLOAT) ELSE 0 END)
                / COUNT(CONFIRMED)
            )
            - AVG(CAST(CONFIRMED AS FLOAT)) * AVG(CAST(CONFIRMED AS FLOAT))
        )
    ) AS StandardDeviationConfirmedCases
FROM 
    [dbo].[Corona Virus Dataset];




SELECT 
    COUNT(Deaths) AS TotalDeathsCases,
    AVG(CAST(Deaths AS FLOAT)) AS AverageDeathsCases,
    (
        (
            SUM(CASE WHEN ISNUMERIC(Deaths) = 1 THEN CAST(Deaths AS FLOAT) ELSE 0 END * 
                CASE WHEN ISNUMERIC(Deaths) = 1 THEN CAST(Deaths AS FLOAT) ELSE 0 END)
            / COUNT(Deaths)
        )
        - AVG(CAST(Deaths AS FLOAT)) * AVG(CAST(Deaths AS FLOAT))
    ) AS VarianceDeathsCases,
    SQRT(
        (
            (
                SUM(CASE WHEN ISNUMERIC(Deaths) = 1 THEN CAST(Deaths AS FLOAT) ELSE 0 END * 
                    CASE WHEN ISNUMERIC(Deaths) = 1 THEN CAST(Deaths AS FLOAT) ELSE 0 END)
                / COUNT(Deaths)
            )
            - AVG(CAST(Deaths AS FLOAT)) * AVG(CAST(Deaths AS FLOAT))
        )
    ) AS StandardDeviationDeathsCases
FROM 
    [dbo].[Corona Virus Dataset];




SELECT 
    COUNT(RECOVERED) AS TotalRECOVEREDCases,
    AVG(CAST(RECOVERED AS FLOAT)) AS AverageRECOVEREDCases,
    (
        (
            SUM(CASE WHEN ISNUMERIC(RECOVERED) = 1 THEN CAST(RECOVERED AS FLOAT) ELSE 0 END * 
                CASE WHEN ISNUMERIC(RECOVERED) = 1 THEN CAST(RECOVERED AS FLOAT) ELSE 0 END)
            / COUNT(RECOVERED)
        )
        - AVG(CAST(RECOVERED AS FLOAT)) * AVG(CAST(RECOVERED AS FLOAT))
    ) AS VarianceRECOVEREDCases,
    SQRT(
        (
            (
                SUM(CASE WHEN ISNUMERIC(RECOVERED) = 1 THEN CAST(RECOVERED AS FLOAT) ELSE 0 END * 
                    CASE WHEN ISNUMERIC(RECOVERED) = 1 THEN CAST(RECOVERED AS FLOAT) ELSE 0 END)
                / COUNT(RECOVERED)
            )
            - AVG(CAST(RECOVERED AS FLOAT)) * AVG(CAST(RECOVERED AS FLOAT))
        )
    ) AS StandardDeviationRECOVEREDCases
FROM 
    [dbo].[Corona Virus Dataset];




SELECT Country_Region, SUM(CAST(Confirmed AS INT)) AS total_confirmed_cases
FROM [dbo].[Corona Virus Dataset]
GROUP BY Country_Region
HAVING SUM(CAST(Confirmed AS INT)) = (
    SELECT MAX(total_confirmed_cases)
    FROM (
        SELECT SUM(CAST(Confirmed AS INT)) AS total_confirmed_cases
        FROM [dbo].[Corona Virus Dataset]
        GROUP BY Country_Region
    ) AS subquery
);



SELECT Country_Region, SUM(CAST(Deaths AS INT)) AS total_deaths
FROM [dbo].[Corona Virus Dataset]
GROUP BY Country_Region
HAVING SUM(CAST(Deaths AS INT)) = (
    SELECT MIN(total_deaths)
    FROM (
        SELECT SUM(CAST(Deaths AS INT)) AS total_deaths
        FROM [dbo].[Corona Virus Dataset]
        GROUP BY Country_Region
    ) AS subquery
);



SELECT TOP 5
    Country_Region,
    SUM(CAST(Recovered AS INT)) AS recovered_cases,
    ROW_NUMBER() OVER (ORDER BY SUM(CAST(Recovered AS INT)) DESC) AS rank_of_top_5_countries
FROM [dbo].[Corona Virus Dataset]
GROUP BY Country_Region
ORDER BY recovered_cases DESC;