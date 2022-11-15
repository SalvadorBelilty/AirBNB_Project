WITH cte_top10 AS (select top 10 neighbourhood,count(neighbourhood) 'Top_10_neighbourhood'
						from Airbnb_NYC	
						group by neighbourhood
						order by count(neighbourhood) desc )

select room_type,neighbourhood_group,neighbourhood,count(room_type) as 'Quantity'
from Airbnb_NYC
where neighbourhood in (select neighbourhood from cte_top10 )
group by room_type,neighbourhood,neighbourhood_group
order by room_type,2,3

