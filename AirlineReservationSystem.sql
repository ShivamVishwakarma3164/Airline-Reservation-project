-- Airline Reservation System - Complete SQL Project

-- Step 1: Create Database
CREATE DATABASE AirlineDB;
USE AirlineDB;

-- Step 2: Create Tables

-- Flights Table
CREATE TABLE Flights (
    flight_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_number VARCHAR(10) NOT NULL UNIQUE,
    source VARCHAR(50),
    destination VARCHAR(50),
    departure_time DATETIME,
    arrival_time DATETIME
);

-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- Seats Table
CREATE TABLE Seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    flight_id INT,
    seat_number VARCHAR(5),
    is_booked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

-- Bookings Table
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    seat_id INT,
    booking_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('CONFIRMED', 'CANCELLED') DEFAULT 'CONFIRMED',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id)
);

-- Step 3: Insert Sample Data

-- Flights
INSERT INTO Flights (flight_number, source, destination, departure_time, arrival_time)
VALUES 
('AI101', 'Mumbai', 'Delhi', '2025-07-01 10:00:00', '2025-07-01 12:00:00'),
('AI102', 'Delhi', 'Bangalore', '2025-07-02 14:00:00', '2025-07-02 16:30:00'),
('AI103', 'Chennai', 'Kolkata', '2025-07-03 08:00:00', '2025-07-03 11:00:00'),
('AI104', 'Mumbai', 'Chennai', '2025-07-04 09:30:00', '2025-07-04 12:15:00'),
('AI105', 'Delhi', 'Hyderabad', '2025-07-05 13:00:00', '2025-07-05 15:45:00'),
('AI106', 'Bangalore', 'Delhi', '2025-07-06 06:00:00', '2025-07-06 08:30:00');

-- Customers
INSERT INTO Customers (name, email, phone)
VALUES 
('Shivam Vishwakarma', 'shivamv@example.com', '9876543210'),
('Aman Mehra', 'aman@example.com', '9123456789'),
('Sana Khan', 'sana.khan@example.com', '9812345678'),
('Ravi Patel', 'ravi.patel@example.com', '9001122334'),
('Priya Desai', 'priya.d@example.com', '9998877665'),
('Ankit Sharma', 'ankit.sharma@example.com', '8080707060');

-- Seats
INSERT INTO Seats (flight_id, seat_number)
VALUES 
(1, '1A'), (1, '1B'), (1, '1C'), (1, '2A'), (1, '2B'),
(1, '2C'), (1, '3A'), (1, '3B'), (1, '3C'), (1, '4A'),
(2, '1A'), (2, '1B'), (2, '1C'), (2, '2A'), (2, '2B'),
(2, '2C'), (2, '3A'), (2, '3B'), (2, '3C'), (2, '4A'),
(3, '1A'), (3, '1B'), (3, '1C'), (3, '2A'), (3, '2B'),
(3, '2C'), (3, '3A'), (3, '3B'), (3, '3C'), (3, '4A');

-- Bookings
INSERT INTO Bookings (customer_id, seat_id)
VALUES 
(1, 1),
(2, 6),
(3, 11),
(4, 15),
(5, 25);

-- Update seat status after bookings
UPDATE Seats SET is_booked = TRUE WHERE seat_id IN (1, 6, 11, 15, 25);

-- Step 4: Views

-- Available Seats View
CREATE VIEW AvailableSeats AS
SELECT f.flight_number, s.seat_number
FROM Flights f
JOIN Seats s ON f.flight_id = s.flight_id
WHERE s.is_booked = FALSE;

-- Booking Summary View
CREATE VIEW BookingSummary AS
SELECT b.booking_id, c.name, f.flight_number, s.seat_number, b.status
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Seats s ON b.seat_id = s.seat_id
JOIN Flights f ON s.flight_id = f.flight_id;

-- Step 5: Triggers

-- Auto-update seat status on booking
DELIMITER $$
CREATE TRIGGER after_booking
AFTER INSERT ON Bookings
FOR EACH ROW
BEGIN
    UPDATE Seats SET is_booked = TRUE WHERE seat_id = NEW.seat_id;
END $$
DELIMITER ;

-- Auto-free seat on cancellation
DELIMITER $$
CREATE TRIGGER after_cancel
AFTER UPDATE ON Bookings
FOR EACH ROW
BEGIN
    IF NEW.status = 'CANCELLED' THEN
        UPDATE Seats SET is_booked = FALSE WHERE seat_id = NEW.seat_id;
    END IF;
END $$
DELIMITER ;

SELECT * FROM AvailableSeats;
SELECT * FROM BookingSummary;

SHOW TRIGGERS FROM AirlineDB;


