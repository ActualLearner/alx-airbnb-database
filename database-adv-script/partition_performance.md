# Partition Performance Report

## Performance Analysis

### Before Partitioning

**Query Used:**

```sql
SELECT *
FROM booking
WHERE start_date < '2025-08-01';
```

**Results with `EXPLAIN`:**

```
1	SIMPLE	booking	ALL					7	33.33	Using where
```

**Results with `EXPLAIN ANALYZE`:**

```
-> Filter: (booking.start_date < DATE'2025-08-01')  
   (cost=0.95 rows=2.33)  
   (actual time=0.0613..0.0717 rows=4 loops=1)
-> Table scan on booking  
   (cost=0.95 rows=7)  
   (actual time=0.059..0.0682 rows=7 loops=1)
```

**Observations:**

* A full table scan is used (`ALL`), which becomes inefficient as the dataset grows.
* Time spent filtering: approximately 0.0613 seconds
* Time scanning the table: approximately 0.059 seconds

---

### After Partitioning

#### Complications Encountered

* MySQL does not support foreign keys in partitioned tables.
* As a result, we created a new table `booking_partitioned`, removed foreign keys, and defined a composite primary key `(booking_id, start_date)` to comply with MySQL’s partitioning rules.

#### New Table Schema

```sql
CREATE TABLE booking_partitioned (
  booking_id CHAR(36) NOT NULL,
  property_id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (booking_id, start_date)
)
PARTITION BY RANGE COLUMNS(start_date) (
  PARTITION p_2025_01 VALUES LESS THAN ('2025-02-01'),
  PARTITION p_2025_02 VALUES LESS THAN ('2025-03-01'),
  PARTITION p_2025_03 VALUES LESS THAN ('2025-04-01'),
  PARTITION p_2025_04 VALUES LESS THAN ('2025-05-01'),
  PARTITION p_2025_05 VALUES LESS THAN ('2025-06-01'),
  PARTITION p_2025_06 VALUES LESS THAN ('2025-07-01'),
  PARTITION p_2025_07 VALUES LESS THAN ('2025-08-01'),
  PARTITION p_2025_08 VALUES LESS THAN ('2025-09-01'),
  PARTITION p_2025_09 VALUES LESS THAN ('2025-10-01'),
  PARTITION p_2025_10 VALUES LESS THAN ('2025-11-01'),
  PARTITION p_2025_11 VALUES LESS THAN ('2025-12-01'),
  PARTITION p_2025_12 VALUES LESS THAN ('2026-01-01'),
  PARTITION p_after_2025 VALUES LESS THAN MAXVALUE
);
```

**Query Used:**

```sql
SELECT *
FROM booking_partitioned
WHERE start_date < '2025-08-01';
```

**Results with `EXPLAIN`:**

```
1	SIMPLE	booking_partitioned	p_2025_01 ... p_2025_07	ALL		4	Using where	33.33
```

**Results with `EXPLAIN ANALYZE`:**

```
-> Filter: (booking_partitioned.start_date < DATE'2025-08-01')  
   (cost=2.15 rows=1.33)  
   (actual time=0.0381..0.0801 rows=4 loops=1)
-> Table scan on booking_partitioned  
   (cost=2.15 rows=4)  
   (actual time=0.0366..0.0778 rows=4 loops=1)
```

**Improvements Observed:**

* Filtering time dropped from 0.0613 → 0.0381 seconds

* Table scan time dropped from 0.059 → 0.0366 seconds

* Only relevant partitions (7 of them) were scanned, rather than the entire table

---

## Conclusion

Partitioning the table by `start_date` improved query efficiency for date-based filters. Although the dataset used was small, the structure now scales much better for larger volumes of data.

| Metric               | Before     | After        | Improvement        |
| -------------------- | ---------- | ------------ | ------------------ |
| Filtering Time       | 0.0613 sec | 0.0381 sec   | \~38% faster       |
| Full Table Scan Time | 0.0590 sec | 0.0366 sec   | \~38% faster       |
| Scan Scope           | All rows   | 7 partitions | Reduced scan scope |
