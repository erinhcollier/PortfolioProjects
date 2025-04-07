
-- DRIVER ANALYSIS --

/* Q1. Driver Performance: points, podiums and wins: - case */ 

SELECT TOP 25
    CONCAT(d.forename, ' ', d.surname) AS Driver,
    SUM(rs.points) AS TotalPoints,
    COUNT(CASE WHEN rs.position = 1 THEN 1 END) AS Wins, 
    COUNT(CASE WHEN rs.position <= 3 THEN 1 END) AS Podiums 
FROM 
    results rs  
    JOIN drivers d ON rs.driverId = d.driverId
GROUP BY 
    d.driverId, CONCAT(d.forename, ' ', d.surname)
ORDER BY 
    TotalPoints DESC;


/* Q2. Fastest Driver: fastest lap time per circuit - subquery */ 

SELECT 
    CONCAT(d.forename, ' ', d.surname) AS Driver,
    MIN(rs.fastestLapTime) AS FastestLapTime,
    c.name AS Circuit,
    CONCAT(c.location, ', ', c.country) AS Location
FROM 
    results rs
    JOIN races r ON rs.raceId = r.raceId
    JOIN circuits c ON r.circuitId = c.circuitId
    JOIN drivers d ON rs.driverId = d.driverId  
WHERE 
    rs.fastestLapTime = (
	SELECT MIN(rs2.fastestLapTime)
    FROM results rs2
    JOIN races r2 ON rs2.raceId = r2.raceId
    WHERE r2.circuitId = c.circuitId AND rs2.fastestLapTime IS NOT NULL
    )
GROUP BY 
    c.circuitId, c.name, d.driverId, CONCAT(d.forename, ' ', d.surname), c.location, c.country
ORDER BY 
    FastestLapTime ASC;


/* Q3. Driver Demographics: nationality share - percentage */ 

SELECT 
    nationality, 
    COUNT(driverId) AS TotalDrivers,
    CAST(ROUND((COUNT(driverId) * 100.0 /(SELECT COUNT(*) FROM drivers)), 2)
	AS DECIMAL(5, 2)) AS [Percentage]
FROM 
    drivers
GROUP BY 
    nationality
ORDER BY 
    [Percentage] DESC;






-- CONSTRUCTOR ANALYSIS --

/* Query 1. Constructor Dominance: rank over seasons - Partition by / CTE */

WITH ConstructorRank AS (
    SELECT 
        c.name AS Constructor,
        YEAR(r.date) AS Season,
        SUM(rs.points) AS TotalPoints,
        RANK() OVER (PARTITION BY YEAR(r.date) ORDER BY SUM(rs.points) DESC) AS Rank   
    FROM 
        results rs
        JOIN constructors c ON rs.constructorId = c.constructorId
        JOIN races r ON rs.raceId = r.raceId
    WHERE 
        YEAR(r.date) BETWEEN 2020 AND 2024  
    GROUP BY 
        c.constructorId, c.name, YEAR(r.date)
)
SELECT 
    Constructor,
    Season,
	TotalPoints,
    Rank,
    COALESCE(Rank - LAG(Rank) OVER (PARTITION BY Constructor ORDER BY Season), 0) AS RankChange
FROM 
    ConstructorRank
ORDER BY 
    Season DESC, 
	Rank ASC;


/* Query 2. driver retention: Years spent with constructor - joins / CTE */ 

WITH DriverRaceYears AS (
    SELECT 
        rs.driverId,
        CONCAT(d.forename, ' ', d.surname) AS Driver,
        rs.constructorId,
        c.name AS Constructor,
        MIN(r.year) AS FirstRace,
        MAX(r.year) AS LastRace
    FROM 
        results rs
        JOIN races r ON rs.raceId = r.raceId
        JOIN drivers d ON rs.driverId = d.driverId
        JOIN constructors c ON rs.constructorId = c.constructorId
    GROUP BY 
        rs.driverId, d.forename, d.surname, rs.constructorId, c.[name]
)
SELECT 
    Constructor,
    Driver,
    FirstRace,
    LastRace,
    LastRace - FirstRace AS YearsWithConstructor
FROM 
    DriverRaceYears
ORDER BY 
    YearsWithConstructor DESC;


/* Query 3. Constructor pit stops: pit stop duration & consistency (seconds) - Average, Variance*/

SELECT 
    c.name AS Constructor,
    ROUND(CAST(AVG(ps.milliseconds / 10000.0) AS DECIMAL(10, 2)), 2) AS AvgPitStop,
    ROUND(CAST(STDEV(ps.milliseconds / 10000.0) AS DECIMAL(10, 2)), 2) AS PitStopSD
FROM 
    pit_stops ps
    JOIN results rs ON ps.raceId = rs.raceId AND ps.driverId = rs.driverId
    JOIN constructors c ON rs.constructorId = c.constructorId
WHERE 
    ps.duration IS NOT NULL
GROUP BY 
    c.[name]
ORDER BY 
    AvgPitStop ASC;










