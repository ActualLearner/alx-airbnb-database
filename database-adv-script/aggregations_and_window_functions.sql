
/* find the total number of bookings made by each user */

SELECT u.user_id, u.first_name, COUNT(b.booking_id) AS bookings
FROM users u
JOIN booking b
ON u.user_id = b.user_id
GROUP BY user_id, first_name

/* Rank properties based on the total number of bookings they have received */

SELECT 
  property_id,
  total_bookings,
  RANK() OVER (ORDER BY total_bookings DESC) AS rank,
  ROW_NUMBER() OVER (PARTITION BY property_id) AS row_number
FROM (
  SELECT property_id, COUNT(*) AS total_bookings
  FROM booking
  GROUP BY property_id
) sub;

