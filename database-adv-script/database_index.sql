-- Indexes for the `users` table
-- Improve filtering and permission checks by user role
CREATE INDEX idx_users_role ON users(role);

-- Indexes for the `property` table
-- Improve searches by price and location
CREATE INDEX idx_property_price ON property(pricepernight);
CREATE INDEX idx_property_location ON property(location);

-- Indexes for the `booking` table
-- Improve availability filtering and status lookups
CREATE INDEX idx_booking_status ON booking(status);
-- Composite index for efficient availability search
CREATE INDEX idx_booking_availability ON booking(property_id, start_date, end_date);

-- Indexes for the `review` table
-- Improve filtering by rating
CREATE INDEX idx_review_rating ON review(rating);

-- Indexes for the `message` table
-- Support inbox functionality (messages by recipient and time)
CREATE INDEX idx_message_inbox ON message(recipient_id, sent_at);


-- Example query to test:
EXPLAIN ANALYZE SELECT * FROM property WHERE location = 'Paris' AND pricepernight < 150;

-- Or
EXPLAIN ANALYZE SELECT * FROM booking WHERE property_id = 5 AND start_date >= '2024-08-01' AND end_date <= '2024-08-10';

-- Or
EXPLAIN ANALYZE SELECT * FROM users WHERE role = 'admin';
