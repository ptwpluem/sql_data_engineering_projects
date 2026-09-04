select
    table_name,
    column_name,
    data_type
from information_schema.columns
where table_name = 'job_postings_fact';

--- Template

select 
    job_id,
    job_work_from_home,
    job_posted_date,
    salary_year_avg
from job_postings_fact
limit 10;

---

select 
    job_id,
    cast(job_work_from_home as int),
    job_posted_date,
    salary_year_avg
from job_postings_fact
limit 10;