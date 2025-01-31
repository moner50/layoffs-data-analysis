USE world_layoffs;
SELECT *
FROM layoffs_staging3;

-- COMPANY LAID OFF ALL CUSTOMERS   WHEN PRECETAGE IS 1
SELECT * 
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- COMPANY WITH TOTAL LAID OFF 
SELECT company , SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company
ORDER BY 2 DESC;

-- KNOWING THE DATE 
-- IT SEMMIN START TO LAID WITH COIVED-19 2020 (MAY REASCON) TOTAL 3 YEARS 
SELECT MIN(`DATE`) , MAX(`DATE`)
FROM layoffs_staging3;

-- LET`S LOOK TO INDUSTRY
SELECT industry , SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 DESC;
-- INDUSTRY WITH MAX NUMBER AND LOWEST NUMBER TO LAID OFF 
-- NOTE THE MAX LAID OFF ('Consumer') AND MIN(Manufacturing)
SELECT industry , MAX(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 DESC;

-- LETS LOOK TO COUNTRY 
-- NOTED THE 1ST IS 'United States' AND THE LAST POLAND
SELECT country , SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY country
ORDER BY 2 DESC;

-- LET US KNOW THE MAXMIM YEAR THAT LAID OF 
-- IS 2023 
SELECT YEAR(`DATE`) ,SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY YEAR(`DATE`)
ORDER BY 1 DESC;

-- BT MONTH 
-- IT SEEMS DEC '12' FOR 20 & 21 & 22 & 23
SELECT substring(`date`,6,2) AS `month` ,SUM(total_laid_off)
FROM layoffs_staging3
WHERE substring(`date`,6,2) IS NOT NULL 
GROUP BY `MONTH`
ORDER BY 1 DESC;
-- MONTH FOR EACH YEAR ONLY
SELECT SUBSTRING(`date`, 1,7) AS month_per_year , SUM(total_laid_off)
FROM layoffs_staging3
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY month_per_year
ORDER BY 1 ASC ;
-- THE INCREASING OF LAID OFF MONTH BY MONTH 
-- BY THE END OF 2020 THE TOTAL LAID OF IS  80998 & 2021 IS 96821 & 2022 IS 257482
WITH monthly_total AS 
(
SELECT SUBSTRING(`date`, 1,7) AS month_per_year , SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging3
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY month_per_year
ORDER BY 1 ASC	
)
SELECT   month_per_year,total_laid_off , SUM(total_laid_off) OVER (ORDER BY month_per_year)
FROM monthly_total;
 -- AT EACH STAGE OF COMPANY THAT HAVE LAID OFF 
 SELECT stage ,SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY stage
ORDER BY 2 DESC;

-- TOTAL LAID OFF WITH COMPANY BY YEAR 
-- TREND FOR EACH YEAR FOR EACH COMPANY
SELECT company , YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC;
 
WITH Company_years (company , years ,total_laid_off) AS 
(	
SELECT company , YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company , YEAR(`date`)
),
TOP_COMPANY_LAID_OFF AS 
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years  ORDER BY total_laid_off DESC)  AS ranking
FROM Company_years
WHERE years IS NOT NULL
)
-- TOP FIVE OF EACH YEAR 
SELECT * 
FROM TOP_COMPANY_LAID_OFF
WHERE ranking <= 5;


-- WORK ON funds_raised_millions
SELECT 
  COUNT(funds_raised_millions) AS total_companies,
  AVG(funds_raised_millions) AS avg_funds_raised,
  MAX(funds_raised_millions) AS max_funds_raised,
  MIN(funds_raised_millions) AS min_funds_raised,
  SUM(funds_raised_millions) AS total_funds_raised
FROM layoffs_staging3;


-- Top Companies by Funding
SELECT DISTINCT company , industry , country , funds_raised_millions
FROM layoffs_staging3
ORDER BY funds_raised_millions DESC
LIMIT 10;


-- Trends Over Time
SELECT YEAR(`date`) AS years, AVG(funds_raised_millions) AS avg_funding_per_year,
SUM(funds_raised_millions) AS total_funding_per_year
FROM layoffs_staging3
WHERE `date` IS NOT NULL
GROUP BY years 
ORDER BY years;


-- HIGER Funding -> FEWER LAID OFF
-- FOR EACH MILLION THAT LAIED OF X 
SELECT  company , funds_raised_millions , total_laid_off,
(total_laid_off / funds_raised_millions) AS layoffs_per_million_raised
FROM layoffs_staging3
WHERE funds_raised_millions > 0 AND total_laid_off IS NOT NULL
ORDER BY layoffs_per_million_raised DESC;


 

