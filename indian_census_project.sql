show databases;
SHOW TABLES; 
SELECT * FROM indian_census_project.dataset1; 
SELECT * FROM indian_census_project.dataset2;
select count(*) FROM indian_census_project.dataset2; 
select sum(population) as Population from indian_census_project.dataset2;

 select state,round(avg(sex_ratio),0) avg_sex_ratio  
               from indian_census_project.dataset1 
               group by state 
               order by avg_sex_ratio desc;
               
               select state,round(avg(literacy),0) avg_literacy_ratio 
               from indian_census_project.dataset1 
               group by state having round(avg(literacy),0)>90 
               order by avg_literacy_ratio desc;
               
select state,avg(growth)*100 avg_growth 
from indian_census_project.dataset1 
group by state order by avg_growth desc limit 3; 

select d.state,sum(d.males) total_males,sum(d.females) total_females from 
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from 
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population 
from indian_census_project.dataset1 a inner join indian_census_project.dataset2 b on a.district=b.district ) c) d 
group by d.state ; 

select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people, 
round((1-d.literacy_ratio)* d.population,0) illiterate_people from 
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from indian_census_project.dataset1 a 
inner join indian_census_project.dataset2 b on a.district=b.district) d) c 
group by c.state;


select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from 
(select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population 
                     from 
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population 
                     from 
(select a.district,a.state,a.growth growth,b.population from indian_census_project.dataset1 a inner join indian_census_project.dataset2 b on a.district=b.district) d) e  
group by e.state)m; 


select (g.total_area/g.previous_census_population)  as previous_census_population_vs_area, (g.total_area/g.current_census_population) as 
current_census_population_vs_area from
(select q.*,r.total_area from (

select '1' as keyy,n.* from
(select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from indian_census_project.dataset1 a inner join indian_census_project.dataset2 b on a.district=b.district) d) e
group by e.state)m) n) q inner join (

select '1' as keyy,z.* from (
select sum(area_km2) total_area from indian_census_project.dataset2)z) r on q.keyy=r.keyy)g;  


select a.* from 
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from indian_census_project.dataset1) a 
where a.rnk in (1,2,3) order by state


