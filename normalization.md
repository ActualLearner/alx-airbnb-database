# Database Normalization

## First Normal Form (1NF)

**Objective:**  
Ensure all attributes are atomic (indivisible), and there are no repeating groups.

**Analysis:**
- All fields store single values (e.g., no arrays or comma-separated lists).
- No repeating groups or nested records exist in any table.

**Conclusion:**
- The initial ERD is in **First Normal Form (1NF)**.

## Second Normal Form (2NF)

**Objective:**  
Eliminate partial dependencies — where non-key attributes depend on only part of a composite primary key.

**Analysis:**
- All tables use simple (single-column) primary keys.
- No tables use composite keys, so partial dependencies are impossible.

**Conclusion:**
- The schema is already in **Second Normal Form (2NF)**.

## Third Normal Form (3NF)

**Objective:**  
Remove transitive dependencies — where non-key attributes depend on other non-key attributes instead of the primary key.

**Potential Issues:**
- Fields like `role` (in User), `status` (in Booking), and `payment_method` (in Payment) are stored as `ENUM` types.
- Technically, these could be separated into their own lookup tables to meet strict 3NF.

**Decision:**
- For this project, we intentionally **retain these ENUMs** for simplicity, readability, and maintainability.
- These fields have a **small, fixed set of values** that rarely change.
- Most relational databases support ENUMs efficiently and safely in practice.

### Conclusion:
- The schema satisfies **practical Third Normal Form (3NF)**.
- No further normalization is needed at this stage.

---

## Final Summary

The database design is clean, maintainable, and aligned with both normalization principles and practical development constraints.
