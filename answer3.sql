//The table creation:

CREATE TABLE States (
    StateAbbreviation CHAR(2) PRIMARY KEY,
    HasRegion BOOLEAN
);

CREATE TABLE Regions (
    RegionID SERIAL PRIMARY KEY,
    RegionName VARCHAR(255)
);

CREATE TABLE Markets (
    MarketID SERIAL PRIMARY KEY,
    MarketName VARCHAR(255),
    RegionID INT REFERENCES Regions(RegionID)
);

CREATE TABLE Submarkets (
    SubmarketID SERIAL PRIMARY KEY,
    SubmarketName VARCHAR(255),
    MarketID INT REFERENCES Markets(MarketID),
    Polygon GEOMETRY
);


//The tables are filled using the Insert statement.

//The search query is as below(lon and lat are longitude and latitude):

SELECT
    CASE
        WHEN ST_Within({lon, lat}, Submarkets.Polygon) THEN Submarkets.SubmarketName
        ELSE 'Other'
    END AS SubmarketName,
    CASE
        WHEN ST_Within({lon, lat}, Submarkets.Polygon) THEN Markets.MarketName
        ELSE 'Other'
    END AS MarketName,
    CASE
        WHEN ST_Within({lon, lat}, Submarkets.Polygon) THEN States.StateAbbreviation
        ELSE 'NY'  -- Replace with the default state abbreviation
    END AS StateAbbreviation,
    CASE
        WHEN ST_Within(ST_MakePoint(lon, lat), Submarkets.Polygon) THEN Regions.RegionName
        ELSE NULL
    END AS RegionName
FROM Submarkets
LEFT JOIN Markets ON Submarkets.MarketID = Markets.MarketID
LEFT JOIN Regions ON Markets.RegionID = Regions.RegionID
LEFT JOIN States ON States.StateAbbreviation = 'NY';  
