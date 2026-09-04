select char_length('SQL');

select lower('SQL');

select upper('SQL');

select left('SQL', 2);

select right('SQL', 2);

select substring('SQL', 2, 1);

select concat('SQL', '-', 'Functions');

select 'SQL' || '-' || 'Functions';

select trim(' sql ');

select replace('SQL', 'Q', '_');

select regexp_replace('data.nerd@gmail.com', '^.*(@)', '\1');

-- final exaple - clean up this using Text Functions
with title_lower as (
    select
        job_title,
        lower(trim(job_title)) as job_title_clean
    from data_jobs.job_postings_fact
)

select
    job_title,
    case
        when job_title_clean like '%data'
        and job_title_clean like '%analyst%' then ' Data Analyst'
        when job_title_clean like '%data'
        and job_title_clean like '%scientist%' then ' Data Analyst'
        when job_title_clean like '%data'
        and job_title_clean like '%engineer%' then ' Data Engineer'
        else 'other'
    end as job_title_category
from
    title_lower
order by
    random()
limit 30;

-- Text Null Functions
select nullif(5+5, 20);

select
    nullif(salary_year_avg, 0),
    nullif(salary_hour_avg, 0)
from 
    data_jobs.job_postings_fact
where
    salary_hour_avg is not null or salary_year_avg is not null
limit 10;

-- COALESCE
select coalesce(null, null, 2);

select
    salary_year_avg,
    salary_hour_avg,
    coalesce(salary_year_avg, salary_hour_avg * 2_080)
from 
    data_jobs.job_postings_fact
where
    salary_hour_avg is not null or salary_year_avg is not null
limit 10;

-- Final example: Simplify with Coalesce
select
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
        coalesce(salary_year_avg, salary_hour_avg * 2_080) as standardized_salary,
    case
        when coalesce(salary_year_avg, salary_hour_avg * 2_080) is null then 'missing'
        when coalesce(salary_year_avg, salary_hour_avg * 2_080) < 75_000 then 'low'
        when coalesce(salary_year_avg, salary_hour_avg * 2_080) < 150_000 then 'mid'
        else 'high'
    end as salary_bucket
from data_jobs.job_postings_fact
order by
    standardized_salary desc;