
## Weekday vs Weekend total flights
select if(weekday(flight_date)>4,"Weekend","Weekday") as weekly_status,count(airline)Total_flights from flights group by 1;


## Cancelled flights of Jetblue Airline on start date of every month
select flight_date,month_name,Total_flights from(
select month(f.flight_date)m, day(f.flight_date)df, monthname(f.flight_date)month_name, f.flight_date,count(f.airline)Total_flights, a.airline 
from flights as f inner join airlines as a on f.airline = a.iata_code
where day(f.flight_date)=1 and  f.cancelled = 1 and a.airline="jetblue airways" group by 2,3,4 order by 1 asc)a; 

## week wise top 5 airline delay of flights
select Week_num, airline, Delay from(
select week(f.flight_date)Week_num, a.airline,count(a.airline)Delay, dense_rank() over(partition by week(f.flight_date) order by count(a.airline) desc)as drnk 
from flights as f inner join airlines as a on f.airline = a.iata_code where f.departure_delay > 0 and f.arrival_delay > 0  group by 1,2)a where drnk <=5;


## state wise top 5 airline flight delay
select State, airline, Delay from(
select ai.state, a.airline,count(a.airline)Delay, dense_rank() over(partition by ai.state order by count(a.airline) desc)as drnk 
from flights as f inner join airports as ai on f.origin_airport = ai.iata_code
inner join airlines as a on f.airline = a.iata_code where f.departure_delay > 0 and f.arrival_delay > 0  group by 1,2)a where drnk <=5;


## city wise top 5 airline flight delay
select City, airline, Delay  from(
select ai.city, a.airline,count(a.airline)Delay, dense_rank() over(partition by ai.city order by count(a.airline) desc)as drnk 
from flights as f inner join airports as ai on f.origin_airport = ai.iata_code
inner join airlines as a on f.airline = a.iata_code where f.departure_delay > 0 and f.arrival_delay > 0  group by 1,2)a where drnk <=5;


## Airlines with no delay within the distance 2500 and 3000
select  a.airline, count(a.airline)No_of_Airlines from flights as f inner join airlines as a on f.airline = a.iata_code 
where f.departure_delay < 0 and f.arrival_delay < 0 and f.distance between 2500 and 3000 group by 1 order by 2 desc;
