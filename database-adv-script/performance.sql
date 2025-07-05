-- retrieves all bookings along with the user details, property details, and payment details

SELECT *
FROM payment p
JOIN booking b ON p.booking_id = b.booking_id
JOIN property pr ON b.property_id = pr.property_id
JOIN users u ON u.user_id = b.user_id

-- identify any inefficiencies.

EXPLAIN
SELECT *
FROM payment p
JOIN booking b ON p.booking_id = b.booking_id
JOIN property pr ON b.property_id = pr.property_id
JOIN users u ON u.user_id = b.user_id

/* Result: 1	SIMPLE	p		ALL	    booking_id				4	100.00	
           1	SIMPLE	b		eq_ref	PRIMARY,property_id,user_id	PRIMARY	144	airbnb.p.booking_id	1	100.00	
           1	SIMPLE	pr	eq_ref	PRIMARY	PRIMARY	144	airbnb.b.property_id	1	100.00	
           1	SIMPLE	u		eq_ref	PRIMARY	PRIMARY	144	airbnb.b.user_id	1	100.00	
We can observe that a full table scan takes place when querying for booking_id inside the p(payment) table.

*/

-- Improvements:


-- 1. Add index on payment(booking_id) to avoid a full table scan
CREATE INDEX idx_payment_booking_id ON payment(booking_id);

-- 2. Limit columns in the select to maximize speed
SELECT 
  p.payment_id, p.amount, p.payment_date,
  b.booking_id, b.start_date, b.end_date, b.total_price, b.status,
  pr.property_id, pr.name, pr.location, pr.pricepernight,
  u.user_id, u.first_name, u.last_name, u.email
FROM payment p
JOIN booking b ON p.booking_id = b.booking_id
JOIN property pr ON b.property_id = pr.property_id
JOIN users u ON u.user_id = b.user_id



/* Now let's analyze again using explain */
EXPLAIN
SELECT 
  p.payment_id, p.amount, p.payment_date,
  b.booking_id, b.start_date, b.end_date, b.total_price, b.status,
  pr.property_id, pr.name, pr.location, pr.pricepernight,
  u.user_id, u.first_name, u.last_name, u.email
FROM payment p
JOIN booking b ON p.booking_id = b.booking_id
JOIN property pr ON b.property_id = pr.property_id
JOIN users u ON u.user_id = b.user_id

/* 1	SIMPLE	p		ALL	idx_payment_booking_id				4	100.00	
   1	SIMPLE	b		eq_ref	PRIMARY,property_id,user_id	PRIMARY	144	airbnb.p.booking_id	1	100.00	
   1	SIMPLE	pr		eq_ref	PRIMARY	PRIMARY	144	airbnb.b.property_id	1	100.00	
   1	SIMPLE	u		eq_ref	PRIMARY	PRIMARY	144	airbnb.b.user_id	1	100.00	

Our index is not being used, most probably due to our payment table being of small size(which makes the compiler
choose a full table scan over an index since it's cheaper. However we keep this index since it will become 
crucial when our dataset grows.

*/
