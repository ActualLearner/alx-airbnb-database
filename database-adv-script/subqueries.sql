
/* Find all properties where the average rating is greater than 4.0 */

SELECT *
FROM property p
JOIN review r
ON p.property_id = r.property_id
WHERE r.rating > 4.0

/* Find users who have made more than 3 bookings */

SELECT user_id, first_name, COUNT(b.booking_id) AS bookings
FROM users u
JOIN booking b
ON u.user_id = b.user_id
GROUP BY user_id, first_name
HAVING COUNT(b.booking_id) > 3
