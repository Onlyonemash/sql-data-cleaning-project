-- SECTION 1 - SET UP
-- =========================================================
-- DATA CLEANING PROJECT: Layoffs Dataset (2022)
-- Source: Kaggle - https://www.kaggle.com/datasets/swaptr/layoffs-2022
-- Tools: MySQL Workbench
-- =========================================================

SELECT * 
FROM world_layoffs.layoffs;

-- =========================================================
-- SECTION 2 - CREATE STAGING TABLE
-- Create staging table to preserve raw data
-- =========================================================

CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT INTO world_layoffs.layoffs_staging
SELECT * FROM world_layoffs.layoffs;

-- =========================================================
-- SECTION 3: REMOVE DUPLICATES
-- =========================================================

-- NOTE:
-- We use backticks `` around `date` because DATE is a reserved keyword in SQL.
-- Without backticks, MySQL may confuse it with the DATE data type or throw a syntax error.
-- Backticks tell MySQL to treat it as a column name.


SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off,
                     percentage_laid_off, `date`, stage, country,
                     funds_raised_millions
    ) AS row_num
FROM world_layoffs.layoffs_staging;

-- View duplicate records

SELECT *
FROM (
	SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions
		) AS row_num
	FROM world_layoffs.layoffs_staging
) layoffs_staging
WHERE row_num > 1;

-- Create CTE to isolate duplicates

WITH duplicate_cte AS (
    SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country,funds_raised_millions
           ) AS row_num
    FROM world_layoffs.layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;


-- =========================================================
-- SECTION 3B: ALTERNATIVE STAGING TABLE (STAGING 2)
-- =========================================================

-- This table was created to safely store cleaned data with row numbers
-- before performing deletion operations.

CREATE TABLE world_layoffs.layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT,
    row_num INT
);

-- Insert data into staging2 with ROW_NUMBER() to identify duplicates

INSERT INTO world_layoffs.layoffs_staging2
SELECT 
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off,
                     percentage_laid_off, `date`, stage, country,
                     funds_raised_millions
    ) AS row_num
FROM world_layoffs.layoffs_staging;

SELECT *
FROM world_layoffs.layoffs_staging2;

SELECT *
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;

DELETE
FROM world_layoffs.layoffs_staging2
WHERE row_num > 1;

-- =========================================================
-- SECTION 4: STANDARDISE DATA
-- Standardise industry values
-- =========================================================

UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

UPDATE world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Standardise Crypto naming
UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Clean country field
UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

DESCRIBE world_layoffs.layoffs_staging2;

-- Convert date format
UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` LIKE '%/%/%';

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;

-- =========================================================
-- SECTION 5: REMOVE UNNECESSARY DATA
-- Remove rows with no meaningful data
-- =========================================================

DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- =========================================================
-- SECTION 6: FINAL CLEANUP
-- Drop helper columns if any exist
-- =========================================================

-- ALTER TABLE world_layoffs.layoffs_staging2
-- DROP COLUMN row_num;

SELECT *
FROM world_layoffs.layoffs_staging2;