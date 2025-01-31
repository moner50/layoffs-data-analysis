USE world_layoffs;
SELECT *
FROM layoffs;
-- remove duplicates 
CREATE TABLE layoffs_staging
LIKE layoffs;
SELECT * 
FROM layoffs_staging;
INSERT  layoffs_staging 
SELECT * 
FROM layoffs;
-- look to unique value 
SELECT * , row_number() OVER(
PARTITION BY  company ,location, industry , total_laid_off , percentage_laid_off , `date`
, stage , country ,funds_raised_millions ) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT * , row_number() OVER(
PARTITION BY  company , industry , total_laid_off , percentage_laid_off , `date`) AS row_num
FROM layoffs_staging
)
select * 
from duplicate_cte 
where row_num > 1 ;
-- insure of duplicate 
select * 
from  layoffs	
where company = 'Casper';
 
-- remove duplicate 
delete 
from duplicate_cte
where row_num > 1;


CREATE TABLE `layoffs_staging3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs_staging3;

insert into layoffs_staging3
SELECT * , row_number() OVER(
PARTITION BY  company ,location, industry , total_laid_off , percentage_laid_off , `date`
, stage , country ,funds_raised_millions ) AS row_num
FROM layoffs_staging;


select *
from layoffs_staging3
where row_num>1;

-- remove duplicate 

-- SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_staging3 WHERE row_num > 1;


select *
from layoffs_staging3;

-- standardizing data
-- remoce spaces  
select  company , TRIM(company)
from layoffs_staging3;

update layoffs_staging3
set company = TRIM(company);

select distinct industry
from layoffs_staging3
order by 1;

update layoffs_staging3
set industry = 'Crypto'
where industry like 'Crypto%';

select  distinct country 
from layoffs_staging3 ;


update layoffs_staging3
set country = TRIM(TRAILING '.' from country )
where country like 'United States%';


-- work on date column 

select `date`,
str_to_date(`date` , '%m/%d/%Y')
from layoffs_staging3;

update layoffs_staging3
set `date` = str_to_date(`date` , '%m/%d/%Y');

select * from layoffs_staging3;

-- change data type 
alter table layoffs_staging3
modify column `date` date; 


select *
from layoffs_staging3
where total_laid_off is NULL
and percentage_laid_off is NULL;


select * 
from layoffs_staging3 
where industry is null
or industry = '';

select * 
from layoffs_staging3
where company = 'Airbnb' ;

update layoffs_staging3
set industry = null
where industry = '';

select t1.industry , t2.industry
from layoffs_staging3  t1
join layoffs_staging3 t2
	on t1.company = t2.company
    and t1.location = t2.location
where (t1.industry  is null or t1.industry = '')
and t2.industry is NOT null;


update layoffs_staging3 t1
join layoffs_staging3 t2
	on t1.company = t2.company
    and t1.location = t2.location
set t1.industry = t2.industry
where (t1.industry  is null or t1.industry = '')
and t2.industry is NOT null;

select industry
from layoffs_staging3
where industry = '' or industry is null ;


select *
from layoffs_staging3
where total_laid_off is NULL
and percentage_laid_off is NULL;

-- remove all null total_laid_off & percentage_laid_off

delete 
from layoffs_staging3
where total_laid_off is NULL
and percentage_laid_off is NULL;

select * from layoffs_staging3;

-- remove row_num
alter table layoffs_staging3
drop column row_num;


