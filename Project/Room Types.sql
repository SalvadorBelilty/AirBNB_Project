select room_type,format(count(*)/cast((select count(room_type) from Airbnb_NYC) as float),'P') as 'Room Types'
from Airbnb_NYC
group by room_type