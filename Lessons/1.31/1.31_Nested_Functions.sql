-- Array introduction
select [1, 2, 3];

select ['python', 'sql', 'r'] as skills_array;


--
with skills as (
 select 'python' as skill
 union all
 select 'sql'
 union all
 select 'r'
), skills_array as (
select array_agg(skill order by skill) as skills
from skills
)
select
    skills[1] as first_skill,
    skills[2] as second_skill,
    skills[3] as third_skill
from skills_array;

-- struct
select {skill: 'python', type: 'programming'} as skill_struct;

with skill_struct as (
select
    struct_pack(
        skill := 'python',
        type := 'programming'
    ) as s
)
select
    s.skill,
    s.type
from skill_struct;

-- 
 with skill_table as (
    select 'python' as skills, 'programming' as types
    union all
    select 'sql', 'query_language'
    union all
    select 'r', 'programming'
 )
 select
    struct_pack(
        skill := skills,
        type := types
    )
from skill_table;

-- array of structs
select [
    {skill: 'python', type: 'programming'},
    {skill: 'sql', type: 'query_language'}
] as skills_array_of_structs;

-- 
 with skill_table as (
    select 'python' as skills, 'programming' as types
    union all
    select 'sql', 'query_language'
    union all
    select 'r', 'programming'
 ), skills_array_struct as (
    select
        array_agg(
        struct_pack(
            skill := skills,
            type := types
        )
    ) as array_struct
from skill_table
 )
 select
    array_struct[1].skill,
    array_struct[2].type,
    array_struct[3]
 from skills_array_struct;

 -- map
 with skill_map as (
    select map {'skill' : 'python', 'type': 'programming'} as skill_type
 )
 select
    skill_type['skill'],
    skill_type['type']
 from skill_map;

 -- JSON
 with raw_skill_json as (
 select
    '{"skill":"python", "type":"programming"}' :: json as skill_json
 )
 select
    struct_pack(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
from raw_skill_json;

-- json to array of structs
with raw_json as (
    select
    '[
        {"skill":"python","type":"programming"},
        {"skill":"sql","type":"query_language"},
        {"skill":"r","type":"programming"},
    ]' :: json as skills_json
)
select
    array_agg(
        struct_pack(
            skill := json_extract_string(e.value, '$.skill'),
            type := json_extract_string(e.value, '$.type')
        )
        order by json_extract_string(e.value, '$.skill')
    ) as skills
from raw_json, json_each(skills_json) as e;

-- array: final example
-- build a flat skill table for co-workers to access job titles, salary info, and skills in one table
create or replace temp table job_skills_array as
select
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    array_agg(sd.skills) as skills_array
from data_jobs.job_postings_fact as jpf
left join data_jobs.skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
left join data_jobs.skills_dim as sd
    on sd.skill_id = sjd.skill_id
group by all;

-- from the perspective of da data analyst, analyze the median salary per skill
with flat_skills as (
    select
        job_id,
        job_title_short,
        salary_year_avg,
        unnest(skills_array) as skill
    from job_skills_array
)
select
    skill, 
    median(salary_year_avg) as median_salary
from flat_skills
group by skill
order by median_salary desc
limit 50;

-- array of structs - final example
-- build a flat skill & type table for co-workers to access job titles, salary info, skills, and type in one table

create or replace temp table job_skills_array_struct as
select
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    array_agg(
        struct_pack(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) as skills_type
from data_jobs.job_postings_fact as jpf
left join data_jobs.skills_job_dim as sjd
    on jpf.job_id = sjd.job_id
left join data_jobs.skills_dim as sd
    on sd.skill_id = sjd.skill_id
group by all;

-- from the perspective of da data analyst, analyze the median salary per type of skill

with flat_skills as (
    select
        job_id,
        job_title_short,
        salary_year_avg,
        unnest(skills_type).skill_type as skill_type,
        unnest(skills_type).skill_name as skill_name
    from
    job_skills_array_struct
)
select
    skill_type, 
    median(salary_year_avg) as median_salary
from flat_skills
group by skill_type
order by median_salary desc;