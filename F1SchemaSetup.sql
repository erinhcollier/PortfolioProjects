CREATE TABLE circuits (
    circuitId INT PRIMARY KEY, 
	circuitRef VARCHAR(50),             
    [name] VARCHAR(100),                  
    [location] VARCHAR(50),             
    country VARCHAR(50),                
    lat FLOAT,            
    lng FLOAT,           
    alt INT                        
);


CREATE TABLE constructor_results (
    constructorResultsId INT PRIMARY KEY,  
    raceId INT NOT NULL,                  
    constructorId INT NOT NULL,           
    points INT,                
    [status] VARCHAR(50)                    
);


CREATE TABLE constructor_standings (
	constructorStandingsId INT PRIMARY KEY,
	raceId INT NOT NULL,
	constructorId INT NOT NULL,
	points INT,
	position INT,
	positionText VARCHAR(50), 
	wins INT
	);

CREATE TABLE constructors (
	constructorId INT PRIMARY KEY,
	constructorRef VARCHAR(50),
	[name] VARCHAR(50),
	nationality VARCHAR(50)
); 

CREATE TABLE driver_standings (
	driverStandingsId INT PRIMARY KEY, 
	raceId INT NOT NULL,
	driverId INT NOT NULL,
	points INT,
	position INT,
	positionText VARCHAR(50),
	wins INT
	); 

CREATE TABLE drivers (
	driverId INT PRIMARY KEY,
	driverRef VARCHAR(50),
	number VARCHAR(50),  
	code VARCHAR(10),
	forename VARCHAR(50),
	surname VARCHAR(50), 
	dob DATE, 
	nationality VARCHAR(50),
	);


CREATE TABLE lap_times (
	raceId INT NOT NULL, 
	driverId INT NOT NULL, 
	lap INT,
	position INT,
	[time] VARCHAR(20),  
	milliseconds INT,
	); 

CREATE TABLE pit_stops (
	raceId INT NOT NULL,
	driverId INT NOT NULL,
	[stop] INT,
	lap INT, 
	[time] VARCHAR(20),
	duration VARCHAR(20),
	milliseconds INT, 
	); 


CREATE TABLE qualifying (
	qualifyId INT PRIMARY KEY,
	raceId INT NOT NULL,
	driverId INT NOT NULL,
	constructorID INT NOT NULL,
	number INT,
	position INT,
	q1 VARCHAR(20),
	q2 VARCHAR(20),
	q3 VARCHAR(20), 
	); 

CREATE TABLE races (
	raceId INT PRIMARY KEY,
	[year] INT,
	[round] INT,
	circuitID INT NOT NULL,
	[name] VARCHAR(100),
	[date] DATE,
	[time] VARCHAR(20), 
	fp1_date VARCHAR(20),
	fp1_time VARCHAR(20),
	fp2_date VARCHAR(20),
	fp2_time VARCHAR(20),
	fp3_date VARCHAR (20), 
	fp3_time VARCHAR(20),
	quali_date VARCHAR(20),
	quali_time VARCHAR(20), 
	sprint_date VARCHAR(20),
	sprint_time VARCHAR(20), 
	); 

UPDATE races (
SET
	[time] = NULL,
	fp1_date = NULL, 
	fp1_time = NULL,
	fp2_date = NULL,
	fp2_time = NULL,
	fp3_date = NULL,
	fp3_time = NULL,
	quali_date = NULL,
	quali_time = NULL,
	sprint_date = NULL,
	sprint_time = NULL
WHERE
	[time] = '\N' OR fp1_date = '\N' OR fp1_time = '\N' OR fp2_date = '\N' OR fp3_date = '\N' OR fp3_time = '\N' OR quali_date = '\N' OR quali_time = '\N' OR sprint_date = '\N' OR sprint_time = '\N' 
); 

CREATE TABLE results (
	resultId INT PRIMARY KEY,
	raceId INT NOT NULL,
	driverID INT NOT NULL,
	constructorID INT NOT NULL,
	number VARCHAR(10),
	grid INT,
	position VARCHAR(10),
	positionText VARCHAR(10),
	positionOrder INT,
	points INT,
	laps INT,
	[time] VARCHAR(50),
	milliseconds VARCHAR(10),
	fastestLap VARCHAR(10), -- INT
	[rank] VARCHAR(10),
	fastestLapTime VARCHAR(50),
	fastestLapSpeed VARCHAR(50), 
	statusId INT NOT NULL
	); 

UPDATE results
SET 
	position = NULL, 
	[time] = NULL,
	milliseconds = NULL,
	fastestLap = NULL, 
	[rank] = NULL,
	fastestLapTime = NULL,
	fastestLapSpeed = NULL 
WHERE 
	position = '\N' OR [time] = '\N' OR milliseconds = '\N' OR fastestLap = '\N' OR [rank] = '\N' OR fastestLapTime = '\N' or fastestLapSpeed = '\N'

ALTER TABLE results
ALTER COLUMN position INT;

SELECT * FROM results

CREATE TABLE sprint_results (
	resultId INT NOT NULL,
	raceID INT NOT NULL,
	driverID INT NOT NULL,
	constructorID INT NOT NULL,
	number VARCHAR(10),
	grid INT,
	position VARCHAR(10), 
	positionText VARCHAR(10),
	positionOrder INT,
	points INT, 
	laps INT, 
	[time] VARCHAR(50),
	milliseconds VARCHAR(10),
	fastestLap VARCHAR(10), 
	fastestLapTime VARCHAR(50),
	statusId INT NOT NULL
	); 

CREATE TABLE [status] (
	statusId INT PRIMARY KEY,
	[status] VARCHAR(50)
	);







