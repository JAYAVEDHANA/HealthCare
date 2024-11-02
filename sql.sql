CREATE DATABASE HealthCare;
use healthcare;
DESC healthcare;

ALTER TABLE `2016-2018_finale` RENAME TO `healthcare`;


use healthcare;


-- KPI 1 --

SELECT 
    LEFT(YEAR_QTR, 4) AS year,               -- Extract the year from the YEAR_QTR column
    SUM(DIS_TOT) AS total_discharges         -- Sum the total discharges for each year
FROM 
    healthcare
GROUP BY 
    LEFT(YEAR_QTR, 4)                        -- Group by the extracted year

UNION ALL

SELECT 
    'Total' AS year,                         -- Label for the total row
    SUM(DIS_TOT) AS total_discharges         -- Overall total discharges
FROM 
    healthcare

ORDER BY 
    CASE WHEN year = 'Total' THEN 1 ELSE 0 END,  -- Ensure 'Total' is last
    year;                                     -- Order remaining years in ascending order

    
    
-- KPI 2 --


SELECT 
    LEFT(YEAR_QTR, 4) AS year,                    -- Extract the year from the YEAR_QTR column
    SUM(PAT_DAY_TOT_CC) AS total_patient_days     -- Sum the total patient days for each year
FROM 
    healthcare
GROUP BY 
    LEFT(YEAR_QTR, 4)                             -- Group by the extracted year

UNION ALL

SELECT 
    'Total' AS year,                              -- Label for the total row
    SUM(PAT_DAY_TOT_CC) AS total_patient_days     -- Overall total patient days
FROM 
    healthcare

ORDER BY 
    CASE WHEN year = 'Total' THEN 1 ELSE 0 END,  -- Ensure 'Total' is last
    year;                                         -- Order remaining years in ascending order
                  -- Order the results with 'Total' at the bottom
                  
                  
                  
		
-- KPI 3 --
SELECT 
    LEFT(YEAR_QTR, 4) AS year,                             -- Extract the year from the YEAR_QTR column
    CONCAT(ROUND(SUM(NET_TOT) / 1000000, 2), ' M') AS total_net_revenue  -- Sum in millions with 'M' suffix
FROM 
    healthcare
GROUP BY 
    LEFT(YEAR_QTR, 4)                                      -- Group by the extracted year

UNION ALL

SELECT 
    'Total' AS year,                                       -- Label for the total row
    CONCAT(ROUND(SUM(NET_TOT) / 1000000, 2), ' M') AS total_net_revenue  -- Overall total in millions with 'M' suffix
FROM 
    healthcare

ORDER BY 
    CASE WHEN year = 'Total' THEN 1 ELSE 0 END,           -- Ensure 'Total' is last
    year;                                                  -- Order remaining years in ascending order


-- KPI 4 --

SELECT 
    LEFT(YEAR_QTR, 4) AS year,                             -- Extract the year from YEAR_QTR
    RIGHT(YEAR_QTR, 1) AS quarter,                         -- Extract the quarter from YEAR_QTR
    CONCAT(ROUND(SUM(NET_TOT) / 1000000, 1), ' M') AS total_net_revenue  -- Sum in millions with 'M' suffix
FROM 
    healthcare
GROUP BY 
    LEFT(YEAR_QTR, 4),                                   -- Group by the extracted year
    RIGHT(YEAR_QTR, 1)                                   -- Group by the extracted quarter
ORDER BY 
    year,                                               -- Order by year
    quarter;                                            -- Order by quarter
        
    -- KPI 5 --

SELECT 
    (SUM(DAY_TOT) + SUM(DAY_LTC)) AS TOTAL_PATIENT_DAYS,            -- Total patient days
    (SUM(DIS_TOT) + SUM(DIS_LTC)) AS TOTAL_HOSPITAL_DISCHARGE,             -- Total hospital discharges
    (SUM(DAY_TOT) + SUM(DAY_LTC)) - (SUM(DIS_TOT) + SUM(DIS_LTC)) AS patient_stays  -- Patient stays calculation
FROM 
    healthcare;  

-- KPI 6 --
SELECT 
    COUNTY_NAME AS state, 
    SUM(HSA) AS total_hospitals, 
    CONCAT(ROUND(SUM(NET_TOT) / 1000000), ' M') AS total_revenue
FROM 
    healthcare
WHERE 
    TYPE_CNTRL = 'State'  -- Filter to only include state-level data
GROUP BY 
    COUNTY_NAME;

-- Kpi 7 --

SELECT 
    TYPE_HOSP AS hospital_type, 
    CONCAT(ROUND(SUM(NET_TOT) / 1000000), ' M') AS total_revenue
FROM 
    healthcare
GROUP BY 
    TYPE_HOSP;
    
-- KPI 8 --
-- month wise total revenue --
SELECT 
    YEAR(STR_TO_DATE(BEG_DATE, '%m-%d-%Y')) AS year,
    MONTH(STR_TO_DATE(BEG_DATE, '%m-%d-%Y')) AS month,
    SUM(NET_TOT) AS monthly_revenue
FROM 
    healthcare
WHERE 
    BEG_DATE IS NOT NULL
GROUP BY 
    YEAR(STR_TO_DATE(BEG_DATE, '%m-%d-%Y')), 
    MONTH(STR_TO_DATE(BEG_DATE, '%m-%d-%Y'))
ORDER BY 
    year, month;

-- quarter wise total revenue --
SELECT 
    LEFT(YEAR_QTR, 4) AS year,
    RIGHT(YEAR_QTR, 1) AS quarter,
    SUM(NET_TOT) AS quarterly_revenue
FROM 
    healthcare
GROUP BY 
    LEFT(YEAR_QTR, 4), 
    RIGHT(YEAR_QTR, 1)
ORDER BY 
    year, quarter;

    
    -- year wise total revenue --
SELECT 
    LEFT(YEAR_QTR, 4) AS year,
    SUM(NET_TOT) AS YTD_revenue
FROM 
    healthcare
WHERE 
    RIGHT(YEAR_QTR, 1) <= '4'  -- Filter to include all quarters up to Q4
GROUP BY 
    LEFT(YEAR_QTR, 4)
ORDER BY 
    year;


-- KPI 9 --
-- total patient --
SELECT 
    (SELECT SUM(VIS_TOT) FROM healthcare) AS total_outpatients,
    (SELECT SUM(DIS_PIPS) FROM healthcare) AS total_inpatients,
    (SELECT SUM(VIS_TOT) FROM healthcare) + 
    (SELECT SUM(DIS_PIPS) FROM healthcare) AS total_patients;
    
    
-- total hospital  --
SELECT 
    TYPE_HOSP, 
    COUNT(HSA) AS total_hospitals
FROM 
    healthcare  
GROUP BY 
    TYPE_HOSP;
    
    
-- total doctors --

SELECT 
    TYPE_HOSP,                  -- Type of hospital
    COUNT(CEO) AS Total_Doctors  -- Total count of CEOs
FROM 
    healthcare
WHERE 
    CEO IS NOT NULL             -- Ensure CEO column is not null
GROUP BY 
    TYPE_HOSP

UNION ALL

SELECT 
    'Grand Total' AS TYPE_HOSP,  -- Label for grand total
    COUNT(CEO) AS Total_Doctors     -- Grand total count of DOC..
FROM 
    healthcare
WHERE 
    CEO IS NOT NULL              -- Ensure CEO column is not null

ORDER BY 
    CASE WHEN TYPE_HOSP = 'Grand Total' THEN 2 ELSE 1 END, -- Ensures 'Grand Total' comes last
    Total_Doctors DESC;             -- Sort by CEO count in descending order


















