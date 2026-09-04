-- sample data
select
    job_posted_date,
    job_posted_date::date as date,
    job_posted_date::time as time,
    job_posted_date::timestamp as timestamp,
    job_posted_date::timestamptz as timestampz
from data_jobs.job_postings_fact
limit 10;


-- use case 1
select
--    job_posted_date,
    extract(year from job_posted_date) as job_posted_year,
    extract(month from job_posted_date) as job_posted_month,
--    extract(day from job_posted_date) as job_posted_day
    count(job_id) as job_count
from 
    data_jobs.job_postings_fact
where job_title_short = 'Data Engineer'
group by
    job_posted_year,
    job_posted_month
order by
    job_posted_year,
    job_posted_month;

-- date_trunc
select
    date_trunc('month', job_posted_date) as job_posted_month,
    count(job_id) as job_count
    -- date_trunc('year', job_posted_date) as truncated_year,
    -- date_trunc('quarter', job_posted_date) as truncated_quarter,
    -- date_trunc('month', job_posted_date) as truncated_month,
    -- date_trunc('week', job_posted_date) as truncated_week,
    -- date_trunc('day', job_posted_date) as truncated_day,
    -- date_trunc('hour', job_posted_date) as truncated_hour
from data_jobs.job_postings_fact
where 
    job_title_short = 'Data Engineer'
    and extract(year from job_posted_date) = 2024
--    and date_trunc('year', job_posted_date) = '2024-01-01'
group by
    date_trunc('month', job_posted_date)
order by
    job_posted_month;

-- timezone
-- select
--     '2026-01-01 00:00:00':: timestamptz at time zone 'est';

select
--    job_posted_date at time zone 'est'
    extract(hour from job_posted_date at time zone 'utc' at time zone 'est') as job_posted_hour,
    count(job_id)
from
    data_jobs.job_postings_fact
where
    job_location like 'New York, NY'
group by
        extract(hour from job_posted_date at time zone 'utc' at time zone 'est')
order by
    job_posted_hour;