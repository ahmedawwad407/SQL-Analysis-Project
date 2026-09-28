-- SQL LAYOFFS DATA CLEANING & EDA PROJECT
USE project_one;

select *
from layoffs_raw;

SELECT COUNT(*) AS total_rows
FROM layoffs_raw;

select company 
from layoffs_raw;

-- SECTION 1: DATA CLEANING
-- Create staging table 
CREATE TABLE layoffs_staging
LIKE layoffs_raw;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs_raw;

SELECT COUNT(*) AS total_rows
FROM layoffs_staging; 

SELECT *
FROM layoffs_staging;

-- Null values detection
SELECT
    COUNT(*) AS total_rows,
    COUNT(company) AS company,
    COUNT(location) AS location,
    COUNT(industry) AS industry,
    COUNT(total_laid_off) AS total_laid_off,
    COUNT(percentage_laid_off) AS percentage_laid_off,
    COUNT(date) AS date,
    COUNT(stage) AS stage,
    COUNT(country) AS country,
    COUNT(funds_raised_millions) AS funds_raised_millions
FROM layoffs_staging;

-- Duplicate detection 
SELECT
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    date,
    stage,
    country,
    funds_raised_millions,
    COUNT(*) AS duplicate_count
FROM layoffs_staging
GROUP BY
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    date,
    stage,
    country,
    funds_raised_millions
HAVING COUNT(*) > 1;

-- view duplicate value 
SELECT *
FROM layoffs_staging
WHERE company IN ('Airbnb', 'Stripe', 'Uber')
ORDER BY company;

-- CTE Remove duplicates 
WITH DuplicateRows AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY
                company,
                location,
                industry,
                total_laid_off,
                percentage_laid_off,
                date,
                stage,
                country,
                funds_raised_millions
            ORDER BY company
        ) AS row_num
    FROM layoffs_staging
)
 select * FROM DuplicateRows
# Delete from DuplicateRows
WHERE row_num > 1;

-- Remove duplicates After Error
DELETE FROM layoffs_staging
WHERE company = 'Airbnb'
  AND location = 'San Francisco'
  AND industry = 'Travel'
  AND total_laid_off = 1900
  AND percentage_laid_off = 0.25
  AND date = '2020-05-05'
  AND stage = 'Post-IPO'
  AND country = 'United States'
  AND funds_raised_millions = 6200
LIMIT 1;

DELETE FROM layoffs_staging
WHERE company = 'Uber'
  AND location = 'San Francisco'
  AND industry = 'Transportation'
  AND total_laid_off = 3700
  AND percentage_laid_off = 0.14
  AND date = '2020-05-18'
  AND stage = 'Post-IPO'
  AND country = 'United States'
  AND funds_raised_millions = 25000
LIMIT 1;

SELECT COUNT(*) AS total_rows
FROM layoffs_staging; 

-- Standardize data
SELECT DISTINCT industry
FROM layoffs_staging
ORDER BY industry;

SELECT *
FROM layoffs_staging
WHERE company = 'Stripe'
ORDER BY company; 

UPDATE layoffs_staging
SET industry = 'Fintech'
WHERE company = 'Stripe'
AND industry = 'FinTech';

DELETE FROM layoffs_staging
WHERE company = 'Stripe'
  AND location = 'San Francisco'
  AND industry = 'Fintech'
  AND total_laid_off = 300
  AND percentage_laid_off = 0.1
  AND date = '2020-04-08'
  AND stage = 'Series G'
  AND country = 'United States'
  AND funds_raised_millions = 2400
LIMIT 1;

SELECT COUNT(*) AS total_rows
FROM layoffs_staging;

-- check null and blank value (Missing values)
SELECT
    COUNT(*) AS total_rows,
    SUM(company IS NULL OR company = '') AS company_missing,
    SUM(location IS NULL OR location = '') AS location_missing,
    SUM(industry IS NULL OR industry = '') AS industry_missing,
    SUM(total_laid_off IS NULL) AS total_laid_off_missing,
    SUM(percentage_laid_off IS NULL) AS percentage_laid_off_missing,
    SUM(date IS NULL) AS date_missing,
    SUM(stage IS NULL OR stage = '') AS stage_missing,
    SUM(country IS NULL OR country = '') AS country_missing,
    SUM(funds_raised_millions IS NULL) AS funds_missing
FROM layoffs_staging;

-- check notLogical Value (Data validation)
SELECT
    MIN(total_laid_off) AS min_laid_off,
    MAX(total_laid_off) AS max_laid_off,
    MIN(percentage_laid_off) AS min_percentage,
    MAX(percentage_laid_off) AS max_percentage,
    MIN(funds_raised_millions) AS min_funds,
    MAX(funds_raised_millions) AS max_funds
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
WHERE total_laid_off < 0
   OR percentage_laid_off < 0
   OR percentage_laid_off > 1
   OR funds_raised_millions < 0;
   
-- Check initial Values 
SELECT DISTINCT industry
FROM layoffs_staging
ORDER BY industry;

SELECT DISTINCT stage
FROM layoffs_staging
ORDER BY stage;

SELECT DISTINCT country
FROM layoffs_staging
ORDER BY country;

-- Check date 
SELECT
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date
FROM layoffs_staging;

SELECT DISTINCT YEAR(date) AS year
FROM layoffs_staging
ORDER BY year;

-- SECTION 2: EXPLORATORY DATA ANALYSIS (EDA)

-- 1. Companies with highest layoffs
SELECT
    company,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging
GROUP BY company
ORDER BY total_employees_laid_off DESC
limit 5;

-- 2. Layoffs by year
SELECT
    YEAR(date) AS year,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging
GROUP BY year(date)
ORDER BY year desc; 

-- 3. Layoffs by country
SELECT
    country,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging
GROUP BY country
ORDER BY total_employees_laid_off DESC;

-- 4. Layoffs by industry
SELECT
    industry,
    COUNT(*) AS number_of_records,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging
GROUP BY industry
ORDER BY total_employees_laid_off DESC;

-- 5. Layoffs by company stage
SELECT
    stage,
    COUNT(*) AS number_of_records,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging
GROUP BY stage
ORDER BY total_employees_laid_off DESC;

-- 6. Highest layoff percentage
SELECT
    company,
    percentage_laid_off
FROM layoffs_staging
WHERE percentage_laid_off IS NOT NULL
ORDER BY percentage_laid_off DESC;

-- 7. Monthly layoffs trend
SELECT
    YEAR(date) AS year,
    MONTH(date) AS month,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging
GROUP BY YEAR(date), MONTH(date)
ORDER BY year, month;

-- 8. Average layoff percentage by industry
SELECT
    industry,
    AVG(percentage_laid_off) AS avg_percentage_laid_off
FROM layoffs_staging
WHERE percentage_laid_off IS NOT NULL
GROUP BY industry
ORDER BY avg_percentage_laid_off DESC;

-- 9. Top companies by layoff percentage
SELECT
    company,
    industry,
    percentage_laid_off,
    total_laid_off
FROM layoffs_staging
WHERE percentage_laid_off IS NOT NULL
ORDER BY percentage_laid_off DESC
LIMIT 5;

-- 10. Average layoffs per record by stage
SELECT
    stage,
    COUNT(*) AS number_of_records,
    SUM(total_laid_off) AS total_employees_laid_off,
    ROUND(AVG(total_laid_off), 0) AS avg_laid_off_per_record
FROM layoffs_staging
GROUP BY stage
ORDER BY avg_laid_off_per_record DESC;


-- Final Step 
CREATE TABLE layoffs_cleaned AS
SELECT *
FROM layoffs_staging;

SELECT COUNT(*) AS total_rows
FROM layoffs_cleaned;

select * from layoffs_cleaned