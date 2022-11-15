--1) Show the most popular neighbourhoods per borough

select neighbourhood_group,neighbourhood,count(*)  as 'Most Popular Neighbourhood' 
from [dbo].[Airbnb_NYC]
group by neighbourhood_group,neighbourhood
order by 1,3 desc


--2) Show the percantage of existing room types 
select room_type,format(count(*)/cast((select count(room_type) from Airbnb_NYC) as float),'P') as 'Room Types'
from Airbnb_NYC
group by room_type


--3	Disterbution of room types among TOP 10 neighbourhoods

WITH cte_top10 AS (select top 10 neighbourhood,count(neighbourhood) 'Top_10_neighbourhood'
						from Airbnb_NYC	
						group by neighbourhood
						order by count(neighbourhood) desc )

select room_type,neighbourhood_group,neighbourhood,count(room_type) as 'Quantity'
from Airbnb_NYC
where neighbourhood in (select neighbourhood from cte_top10 )
group by room_type,neighbourhood,neighbourhood_group
order by room_type,2,3


--4  Anual availability of top rated room per category,showing for top 3 neighbourhood per each borough

DROP TABLE IF EXISTS  #Temp_top3_per_borough
CREATE TABLE #Temp_top3_per_borough(
neighbourhood_group nvarchar(100),
neighbourhood		nvarchar(100),
Most_reviewed		float,
Rank int)

INSERT INTO #Temp_top3_per_borough
select neighbourhood_group,neighbourhood, sum(reviews_per_month*review_rate_number) as 'Most_reviewed '
					,ROW_NUMBER() OVER (PARTITION BY neighbourhood_group Order by sum(reviews_per_month*review_rate_number) DESC) as 'Rank'
					from Airbnb_NYC AS NYC
					join Airbnb_Reviews AS REV
					ON NYC.ID = REV.id
					group by neighbourhood_group,neighbourhood


					

;WITH cte_top1_per_category AS (  select NYC.neighbourhood_group, NYC.neighbourhood,room_type,NYC.availability_365,reviews_per_month*review_rate_number  as 'Most_Reviewd_By_Category'
								,ROW_NUMBER() OVER (PARTITION BY NYC.neighbourhood,room_type Order by reviews_per_month*review_rate_number DESC) as 'Rank1'
								from #Temp_top3_per_borough as temp,Airbnb_NYC AS NYC
								join Airbnb_Reviews as REV ON NYC.ID = REV.id 
								where NYC.neighbourhood in (temp.neighbourhood) and temp.Rank <= 3 )

select *
from  cte_top1_per_category
where  Rank1 = 1   and room_type != 'Hotel room'  --Hotel rooms exclouded due to low quantity(0.17% of total)
order by 1