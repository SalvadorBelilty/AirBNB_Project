select neighbourhood_group,neighbourhood,count(*)  as 'Most Popular Neighbourhood' 
from [dbo].[Airbnb_NYC]
group by neighbourhood_group,neighbourhood
order by 1,3 desc