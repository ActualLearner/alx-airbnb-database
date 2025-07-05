## Optimization Report

### Objective

Refactor complex queries to improve performance.

---

### Instructions

* Write an initial query that retrieves all bookings along with the user details, property details, and payment details in `performance.sql`.
* Analyze the query’s performance using `EXPLAIN` and identify any inefficiencies.
* Refactor the query to reduce execution time, such as reducing unnecessary joins or using indexing.

---

### Performance Analysis

First, we retrieved all bookings along with user details, property details, and payment details using the query from `performance.sql`:

```sql
SELECT *
FROM payment p
JOIN booking b ON p.booking_id = b.booking_id
JOIN property pr ON b.property_id = pr.property_id
JOIN users u ON u.user_id = b.user_id;
```

Then, we identified inefficiencies by analyzing the query with:

```sql
EXPLAIN
SELECT *
FROM payment p
JOIN booking b ON p.booking_id = b.booking_id
JOIN property pr ON b.property_id = pr.property_id
JOIN users u ON u.user_id = b.user_id;
```

**The results were:**

| id | select\_type | table | type    | possible\_keys                | key     | key\_len | ref                   | rows | filtered | Extra |
| -- | ------------ | ----- | ------- | ----------------------------- | ------- | -------- | --------------------- | ---- | -------- | ----- |
| 1  | SIMPLE       | p     | ALL     | booking\_id                   | NULL    | NULL     | NULL                  | 4    | 100.00   |       |
| 1  | SIMPLE       | b     | eq\_ref | PRIMARY,property\_id,user\_id | PRIMARY | 144      | airbnb.p.booking\_id  | 1    | 100.00   |       |
| 1  | SIMPLE       | pr    | eq\_ref | PRIMARY                       | PRIMARY | 144      | airbnb.b.property\_id | 1    | 100.00   |       |
| 1  | SIMPLE       | u     | eq\_ref | PRIMARY                       | PRIMARY | 144      | airbnb.b.user\_id     | 1    | 100.00   |       |

---

### Observation

We observed that a full table scan takes place when querying for `booking_id` inside the `payment` (`p`) table. No other inefficiencies were identified on this query.

---

### Optimization Steps

1. **Added index on `payment(booking_id)` to avoid a full table scan:**

```sql
CREATE INDEX idx_payment_booking_id ON payment(booking_id);
```

2. **Limited columns in the SELECT statement to maximize speed:**

```sql
SELECT 
  p.payment_id, p.amount, p.payment_date,
  b.booking_id, b.start_date, b.end_date, b.total_price, b.status,
  pr.property_id, pr.name, pr.location, pr.pricepernight,
  u.user_id, u.first_name, u.last_name, u.email
FROM payment p
JOIN booking b ON p.booking_id = b.booking_id
JOIN property pr ON b.property_id = pr.property_id
JOIN users u ON u.user_id = b.user_id;
```

---

### Post-Optimization Analysis

We analyzed the query again using `EXPLAIN` to observe improvements:

```sql
EXPLAIN
SELECT 
  p.payment_id, p.amount, p.payment_date,
  b.booking_id, b.start_date, b.end_date, b.total_price, b.status,
  pr.property_id, pr.name, pr.location, pr.pricepernight,
  u.user_id, u.first_name, u.last_name, u.email
FROM payment p
JOIN booking b ON p.booking_id = b.booking_id
JOIN property pr ON b.property_id = pr.property_id
JOIN users u ON u.user_id = b.user_id;
```

**The results:**

| id | select\_type | table | type    | possible\_keys                | key     | key\_len | ref                   | rows | filtered | Extra |
| -- | ------------ | ----- | ------- | ----------------------------- | ------- | -------- | --------------------- | ---- | -------- | ----- |
| 1  | SIMPLE       | p     | ALL     | idx\_payment\_booking\_id     | NULL    | NULL     | NULL                  | 4    | 100.00   |       |
| 1  | SIMPLE       | b     | eq\_ref | PRIMARY,property\_id,user\_id | PRIMARY | 144      | airbnb.p.booking\_id  | 1    | 100.00   |       |
| 1  | SIMPLE       | pr    | eq\_ref | PRIMARY                       | PRIMARY | 144      | airbnb.b.property\_id | 1    | 100.00   |       |
| 1  | SIMPLE       | u     | eq\_ref | PRIMARY                       | PRIMARY | 144      | airbnb.b.user\_id     | 1    | 100.00   |       |

---

### Conclusion

Our index is not being used, most likely due to the small size of the `payment` table (only 4 rows), which makes the optimizer choose a full table scan over an index since it is cheaper. However, we keep this index because it will become crucial as our dataset grows.
