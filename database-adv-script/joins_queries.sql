/* Retrieve all bookings and the respective users who made those bookings. */
SELECT * 
FROM booking b
JOIN users u
ON b.user_id = u.user_id

/* Retrieve all properties and their reviews, including properties that have no reviews. */

SELECT *
FROM property p
LEFT JOIN reviews r
ON p.property_id = r.property_id

/* Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user. */

SELECT *
FROM users u
FULL OUTER JOIN booking b
ON u.user_id = b.user_id
