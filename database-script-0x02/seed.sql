-- Insert users
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  (UUID(), 'Alice', 'Smith', 'alice@example.com', 'hashedpwd1', '555-1234', 'guest'),
  (UUID(), 'Bob', 'Johnson', 'bob@example.com', 'hashedpwd2', '555-5678', 'host'),
  (UUID(), 'Carol', 'Williams', 'carol@example.com', 'hashedpwd3', NULL, 'admin');

-- For later use, capture UUIDs in variables if your SQL client supports it or you can manually replace UUIDs with actual values after inserting users.
-- Let's assume we know these UUIDs

SET @alice_id = (SELECT user_id FROM users WHERE email = 'alice@example.com');
SET @bob_id = (SELECT user_id FROM users WHERE email = 'bob@example.com');
SET @carol_id = (SELECT user_id FROM users WHERE email = 'carol@example.com');

-- Insert properties
INSERT INTO property (property_id, host_id, name, description, location, pricepernight)
VALUES
  (UUID(), @bob_id, 'Cozy Cottage', 'A cozy cottage in the countryside.', 'Green Valley', 120.00),
  (UUID(), @bob_id, 'City Apartment', 'Modern apartment in the city center.', 'Downtown', 150.00);

-- Insert bookings
INSERT INTO booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
  (UUID(), (SELECT property_id FROM property WHERE name = 'Cozy Cottage'), @alice_id, '2025-07-10', '2025-07-15', 600.00, 'confirmed'),
  (UUID(), (SELECT property_id FROM property WHERE name = 'City Apartment'), @alice_id, '2025-08-01', '2025-08-05', 600.00, 'pending');

-- Insert payments
INSERT INTO payment (payment_id, booking_id, amount, payment_method)
VALUES
  (UUID(), (SELECT booking_id FROM booking WHERE status = 'confirmed' LIMIT 1), 600.00, 'credit_card');

-- Insert reviews
INSERT INTO review (review_id, property_id, user_id, rating, comment)
VALUES
  (UUID(), (SELECT property_id FROM property WHERE name = 'Cozy Cottage'), @alice_id, 5, 'Lovely place, very clean and cozy!');

-- Insert messages
INSERT INTO message (message_id, sender_id, recipient_id, message_body)
VALUES
  (UUID(), @alice_id, @bob_id, 'Hi Bob, is the Cozy Cottage available next weekend?'),
  (UUID(), @bob_id, @alice_id, 'Hi Alice, yes it is available. Let me know if you want to book!');
