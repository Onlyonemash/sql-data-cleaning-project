-- =========================================================
-- EXPLORATORY DATA ANALYSIS (EDA)
-- GLOBAL LAYOFFS DATASET
-- =========================================================
-- Objective:
-- Explore layoffs data to identify trends, patterns,
-- outliers, and business insights across industries,
-- companies, countries, and time periods.
--
-- Tools Used:
-- - MySQL Workbench
-- - SQL
--
-- Skills Demonstrated:
-- - Aggregate Functions
-- - GROUP BY
-- - CTEs
-- - Window Functions
-- - DENSE_RANK()
-- - Rolling Calculations
-- - Date Functions
-- =========================================================



-- =========================================================
-- SECTION 1: INITIAL DATA EXPLORATION
-- =========================================================

SELECT *
FROM world_layoffs.layoffs_staging2;



-- =========================================================
-- SECTION 2: MAXIMUM LAYOFF VALUES
-- =========================================================

-- Highest number of employees laid off in a single event

SELECT MAX(total_laid_off) AS highest_single_layoff
FROM world_layoffs.layoffs_staging2;


-- Highest and lowest layoff percentages recorded

SELECT 
    MAX(percentage_laid_off) AS highest_percentage_laid_off,
    MIN(percentage_laid_off) AS lowest_percentage_laid_off
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off IS NOT NULL;



-- =========================================================
-- SECTION 3: COMPANIES WITH 100% LAYOFFS
-- =========================================================

-- Companies where the entire workforce was laid off

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1;


-- Insight:
-- Many companies with 100% layoffs appear to be startups
-- or companies that shut down operations completely.


-- Companies with 100% layoffs ordered by funding raised

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;



-- =========================================================
-- SECTION 4: COMPANY LAYOFF ANALYSIS
-- =========================================================

-- Companies with the largest single layoff events

SELECT 
    company,
    total_laid_off
FROM world_layoffs.layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 5;

-- Companies with the highest total layoffs overall

SELECT 
    company,
    SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;



-- =========================================================
-- SECTION 5: LOCATION AND COUNTRY ANALYSIS
-- =========================================================

-- Locations with the highest total layoffs

SELECT 
    location,
    SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY total_layoffs DESC
LIMIT 10;


-- Countries with the highest layoffs

SELECT 
    country,
    SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total_layoffs DESC;


-- Insight:
-- The United States recorded the highest total layoffs
-- across the dataset period.



-- =========================================================
-- SECTION 6: YEARLY LAYOFF TRENDS
-- =========================================================

-- Total layoffs per year

SELECT 
    YEAR(`date`) AS layoff_year,
    SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY layoff_year
ORDER BY layoff_year ASC;


-- Insight:
-- Layoffs increased significantly during 2022,
-- reflecting broader economic uncertainty.



-- =========================================================
-- SECTION 7: INDUSTRY AND COMPANY STAGE ANALYSIS
-- =========================================================

-- Industries with the highest layoffs

SELECT 
    industry,
    SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_layoffs DESC;


-- Company stages with the highest layoffs

SELECT 
    stage,
    SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total_layoffs DESC;



-- =========================================================
-- SECTION 8: TOP COMPANIES BY YEAR
-- =========================================================

-- Identify the top 3 companies with the highest layoffs
-- in each year using DENSE_RANK()

WITH company_year AS (
    SELECT 
        company,
        YEAR(`date`) AS layoff_year,
        SUM(total_laid_off) AS total_layoffs
    FROM world_layoffs.layoffs_staging2
    GROUP BY company, YEAR(`date`)
),

company_year_rank AS (
    SELECT 
        company,
        layoff_year,
        total_layoffs,
        DENSE_RANK() OVER (
            PARTITION BY layoff_year
            ORDER BY total_layoffs DESC
        ) AS ranking
    FROM company_year
)

SELECT 
    company,
    layoff_year,
    total_layoffs,
    ranking
FROM company_year_rank
WHERE ranking <= 3
AND layoff_year IS NOT NULL
ORDER BY layoff_year ASC, total_layoffs DESC;



-- =========================================================
-- SECTION 9: MONTHLY LAYOFF TREND
-- =========================================================

-- Monthly layoffs trend over time

SELECT 
    DATE_FORMAT(`date`, '%Y-%m') AS layoff_month,
    SUM(total_laid_off) AS total_layoffs
FROM world_layoffs.layoffs_staging2
GROUP BY layoff_month
ORDER BY layoff_month ASC;



-- =========================================================
-- SECTION 10: ROLLING TOTAL OF LAYOFFS
-- =========================================================

-- Calculate cumulative layoffs over time

WITH monthly_layoffs AS (
    SELECT 
        DATE_FORMAT(`date`, '%Y-%m') AS layoff_month,
        SUM(total_laid_off) AS total_layoffs
    FROM world_layoffs.layoffs_staging2
    GROUP BY layoff_month
)

SELECT 
    layoff_month,
    total_layoffs,
    SUM(total_layoffs) OVER (
        ORDER BY layoff_month ASC
    ) AS rolling_total_layoffs
FROM monthly_layoffs
ORDER BY layoff_month ASC;

