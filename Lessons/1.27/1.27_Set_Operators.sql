select unnest([1, 1, 1, 2])
except all
select unnest([1, 1, 3]);

-- create y2023
create temp table jobs_2023 as
select * exclude (job_id, job_posted_date)
from data_jobs.job_postings_fact
where extract(year from job_posted_date) = 2023;

select * from jobs_2023;

-- create y2024
create temp table jobs_2024 as
select * exclude (job_id, job_posted_date)
from data_jobs.job_postings_fact
where extract(year from job_posted_date) = 2024;

select * from jobs_2024;

-- exercise 1: which unique job postings appeared in either 2023 or 2024?
select 
    'job_2023' as table_name,
    count(*) as record_count
from jobs_2023
union
select 
    'job_2024' as table_name,
    count(*) as record_count
from jobs_2024;

select * from jobs_2023
union
select * from jobs_2024;

-- exercise 2: which job posting appeared across both years, counting duplicates?
select * from jobs_2023
union all
select * from jobs_2024;

-- excercise 3: which job postings appeared in 2-23 but not in 2024?
select * from jobs_2023
except
select * from jobs_2024;

-- exercise 4: which job posting from 2023 remain after subtracting matching 2024 postings, one-for-one?
select * from jobs_2023
except all
select * from jobs_2024;

-- exercise 5: which job posting appeared in both 2023 and 2024?
select * from jobs_2023
intersect
select * from jobs_2024;

-- exercise 6: which job postings appeared in both years, preserving duplicate counts?
select * from jobs_2023
intersect all
select * from jobs_2024;