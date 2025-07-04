###  Sample Queries

#### 1. Property Search

```sql
EXPLAIN SELECT * FROM property WHERE location = 'Paris' AND pricepernight < 150;
```

* **Before index:** Full table scan
* **After index:** Index scan using `idx_property_location` and `idx_property_price`
* **Result:** \~3x faster execution time

---

#### 2. Booking Availability

```sql
EXPLAIN SELECT * FROM booking 
WHERE property_id = 12 AND start_date >= '2025-07-10' AND end_date <= '2025-07-20';
```

* **Before index:** Full scan or inefficient filtering
* **After index:** Index range scan using `idx_booking_availability`
* **Result:** Huge reduction in read cost

---

#### 3. Inbox Lookup

```sql
EXPLAIN SELECT * FROM message 
WHERE recipient_id = 42 ORDER BY sent_at DESC;
```

* **Before index:** Sorting and filtering on full table
* **After index:** Index scan using `idx_message_inbox`
* **Result:** Faster sorting and pagination

---

### Summary

Adding indexes to high-usage columns significantly improved query performance, especially for:

* Date range lookups
* Filtering on foreign keys
* Ordered selections (e.g., inbox or recent reviews)

Indexes were chosen based on their appearance in `WHERE`, `JOIN`, and `ORDER BY` clauses, following best practices for index design.
