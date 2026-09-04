-- Subquery
select *
from (
    select *
    from data_jobs.job_postings_fact
    where salary_year_avg is not null
    or salary_hour_avg is not null
) as valid_salaries
limit 10;

-- subquery #1 in select
select
    job_title_short,
    salary_year_avg,
    (
        select median(salary_year_avg)
        from data_jobs.job_postings_fact
    ) as market_median_salary
    from data_jobs.job_postings_fact
    where salary_year_avg is not null
    limit 10;

-- subquery #2 in from
select
    job_title_short,
    median(salary_year_avg) as median_salary,
    (
        select median(salary_year_avg)
        from data_jobs.job_postings_fact
        where job_work_from_home = TRUE
    ) as market_median_salary
    from (
        select
            job_title_short,
            salary_year_avg
        from data_jobs.job_postings_fact
        where job_work_from_home = TRUE
        )    as clean_jobs
    where salary_year_avg is not null
    group by job_title_short
    limit 10;

-- subquery #3 in having
select
    job_title_short,
    median(salary_year_avg) as median_salary,
    (
        select median(salary_year_avg)
        from data_jobs.job_postings_fact
        where job_work_from_home = TRUE
    ) as market_remote_median_salary
    from (
        select
            job_title_short,
            salary_year_avg
        from data_jobs.job_postings_fact
        where job_work_from_home = TRUE
        )    as clean_jobs
    group by job_title_short
    having median(salary_year_avg) > (
        select median(salary_year_avg)
        from data_jobs.job_postings_fact
        where job_work_from_home = TRUE
    )
    limit 10;

-- CTE
with title_median as (
    select
        job_title_short,
        job_work_from_home,
        median(salary_year_avg):: int as median_salary
    from data_jobs.job_postings_fact
    where job_country = 'United States'
    group by
        job_title_short,
        job_work_from_home
)
select
    r.job_title_short,
    r.median_salary as remote_median_salary,
    o.median_salary as online_median_salary,
    (r.median_salary - o.median_salary) as remote_premium
from title_median as r
inner join title_median as o
    on r.job_title_short = o.job_title_short
where r.job_work_from_home = TRUE
    and o.job_work_from_home = FALSE
order by remote_premium desc
limit 10;

-- range
select *
from range(3) as src(key);

select *
from range(2) as tgt(key);

select *
from range(3) as src(key)
where exists (
    select 1
    from range(2) as tgt(key)
    where tgt.key = src.key
);

select *
from range(3) as src(key)
where not exists (
    select 1
    from range(2) as tgt(key)
    where tgt.key = src.key
);

-- final example
select *
from data_jobs.job_postings_fact
order by job_id
limit 10;

select *
from data_jobs.skills_job_dim
order by job_id
limit 40;

select *
from data_jobs.job_postings_fact as tgt
where not exists (
    select *
    from data_jobs.skills_job_dim as src
    where tgt.job_id = src.job_id
)
order by job_id;