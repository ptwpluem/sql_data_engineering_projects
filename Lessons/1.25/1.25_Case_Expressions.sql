-- bucket salaries
-- < 25 = low
-- 25 - 50 = medium
-- > 50 = high

-- use case 1:
select
    job_title_short,
    salary_hour_avg,
    case
        when salary_hour_avg < 25 then 'low'
        when salary_hour_avg < 50 then 'medium'
        else 'high'
    end as salary_category
from data_jobs.job_postings_fact
where
    salary_hour_avg is not null
limit 10;

-- use case 2: handling missing data (nulls)
-- filter null salary values
select
    job_title_short,
    salary_hour_avg,
    case
        when salary_hour_avg is null then 'missing'
        when salary_hour_avg < 25 then 'low'
        when salary_hour_avg < 50 then 'medium'
        else 'high'
    end as salary_category
from data_jobs.job_postings_fact
limit 10;

-- use case 3
-- categorize categorial values
-- classify the `job_title` column values as:
    -- 'Data Analyst'
    -- 'Data Engineer'
    -- 'Data Scientist'

select
    job_title,
    case
        when job_title like '%Data%' and job_title like '%Analyst%' then 'Data Analyst'
        when job_title like '%Data%' and job_title like '%Engineer%' then 'Data Engineer'
        when job_title like '%Data%' and job_title like '%Scientist%' then 'Data Scientist'
        else 'Other'
    end as job_title_category,
    job_title_short
from data_jobs.job_postings_fact
order by random()
limit 20;

-- use case 4
-- condition aggregation

select
    job_title_short,
    count(*) as total_postings,
    median(
        case
            when salary_year_avg < 100_000 then salary_year_avg
        end
    ) as median_low_salary,
   median(
        case
            when salary_year_avg >= 100_000 then salary_year_avg
        end
    ) as median_high_salary
from data_jobs.job_postings_fact
where salary_year_avg is not null
group by job_title_short;

-- use case 5: conditional calculation
with salaries as (
    select
        job_title_short,
        salary_hour_avg,
        salary_year_avg,
        case
            when salary_year_avg is not null then salary_year_avg
            when salary_hour_avg is not null then salary_hour_avg*2000
            end as standardized_salary
    from
        data_jobs.job_postings_fact
    where
        salary_year_avg is not null
        or salary_hour_avg is not null
)

select *,
    case
        when standardized_salary < 75_000 then 'low'
        when standardized_salary < 15_000 then 'medium'
        else 'high'
        end as salary_budket
from salaries
-- order by standardized_salary
limit 10;