## `Index Implementation`

### Objective

To optimize database query performance by creating targeted indexes on frequently queried columns in the **users**, **property**, **booking**, **review**, and **message** tables.

---

### 🔍 Indexes Implemented

| Table      | Index Name                 | Column(s) Indexed                       | Purpose                                                             |
| ---------- | -------------------------- | --------------------------------------- | ------------------------------------------------------------------- |
| `users`    | `idx_users_role`           | `role`                                  | Speeds up filtering users by role (e.g., admin, guest).             |
| `property` | `idx_property_price`       | `pricepernight`                         | Optimizes price-based property search.                              |
| `property` | `idx_property_location`    | `location`                              | Enhances location-based property queries.                           |
| `booking`  | `idx_booking_status`       | `status`                                | Improves filtering bookings by status (e.g., confirmed, cancelled). |
| `booking`  | `idx_booking_availability` | `property_id`, `start_date`, `end_date` | Enables fast range scans for availability search.                   |
| `review`   | `idx_review_rating`        | `rating`                                | Helps with filtering or ordering reviews by rating.                 |
| `message`  | `idx_message_inbox`        | `recipient_id`, `sent_at`               | Speeds up inbox queries by user and date.                           |
