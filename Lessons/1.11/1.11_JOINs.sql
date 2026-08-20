select
    jpf.*,
    cd.*
from
    job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id;

--

select
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
from
    job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id
limit 10;

--

select
    count(*)
from job_postings_fact;

--

select
from
    job_postings_fact as jpf
left join company_dim as cd
    on jpf.company_id = cd.company_id;

--
explain
select
    cd.name as company_name,
    count(jpf.job_id) as postings_count
from 
    job_postings_fact as jpf
    left join company_dim as cd
    on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by
    cd.name
having count(jpf.job_id) > 3000
order by postings_count desc;
