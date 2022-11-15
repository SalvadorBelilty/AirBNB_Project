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
where  Rank1 = 1   and room_type != 'Hotel room'
order by 1