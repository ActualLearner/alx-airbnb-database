## Overview of `seed.sql`

This script populates the AirBnB database with sample data to help with development and testing.

---

## What it inserts

* Sample **users** with different roles (guest, host, admin).
* **Properties** owned by hosts.
* **Bookings** made by users for properties.
* **Payments** for confirmed bookings.
* **Reviews** of properties by users.
* **Messages** exchanged between users.

---

## Usage

Run the seed script after creating the schema:

```bash
mysql -u your_user -p your_database < seed.sql
```

* UUIDs are generated using `UUID()` for unique IDs.
* The script uses variables (e.g., `@alice_id`) to reference inserted rows for foreign keys.
* If your SQL client does not support variables, you can manually replace UUIDs with actual values.

---

## Notes

* Replace the placeholder password hashes with real hashed passwords before use.
* Modify sample data such as dates, amounts, and texts as needed.

---
