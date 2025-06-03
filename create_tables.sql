-- First, fix the bookings table creation
CREATE TABLE bookings (
    booking_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    flight_id NUMBER NOT NULL,
    booking_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    passenger_count NUMBER NOT NULL,
    total_amount NUMBER(10,2) NOT NULL,
    status VARCHAR2(20) DEFAULT 'confirmed' CHECK (status IN ('confirmed', 'cancelled', 'completed')),
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_booking_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- Now create the trigger for bookings
CREATE OR REPLACE TRIGGER bookings_bir
BEFORE INSERT ON bookings
FOR EACH ROW
BEGIN
  SELECT bookings_seq.NEXTVAL
  INTO   :new.booking_id
  FROM   dual;
END;
/

-- Then create the passengers table
CREATE TABLE passengers (
    passenger_id NUMBER PRIMARY KEY,
    booking_id NUMBER NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone VARCHAR2(20) NOT NULL,
    passport_number VARCHAR2(20),
    date_of_birth DATE NOT NULL,
    address VARCHAR2(4000) NOT NULL,
    emergency_contact VARCHAR2(20) NOT NULL,
    special_assistance VARCHAR2(50),
    meal_preference VARCHAR2(50),
    seat_preference VARCHAR2(20),
    CONSTRAINT fk_passenger_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Create trigger for passengers
CREATE OR REPLACE TRIGGER passengers_bir
BEFORE INSERT ON passengers
FOR EACH ROW
BEGIN
  SELECT passengers_seq.NEXTVAL
  INTO   :new.passenger_id
  FROM   dual;
END;
/

-- Create Payments table with corrected syntax
CREATE TABLE payments (
    payment_id NUMBER PRIMARY KEY,
    booking_id NUMBER NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    payment_method VARCHAR2(20) NOT NULL CHECK (payment_method IN ('credit', 'debit', 'upi')),
    payment_status VARCHAR2(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed')),
    transaction_id VARCHAR2(100),
    payment_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Create trigger for payments
CREATE OR REPLACE TRIGGER payments_bir
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
  SELECT payments_seq.NEXTVAL
  INTO   :new.payment_id
  FROM   dual;
END;
/

-- Create sequences for ID generation
CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE flights_seq START WITH 1 INCREMENT BY 1;

-- Create Users table
CREATE TABLE users (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone VARCHAR2(20) NOT NULL,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Create trigger for users
CREATE OR REPLACE TRIGGER users_bir 
BEFORE INSERT ON users 
FOR EACH ROW
BEGIN
  SELECT users_seq.NEXTVAL
  INTO   :new.user_id
  FROM   dual;
END;
/

-- Create Flights table
CREATE TABLE flights (
    flight_id NUMBER PRIMARY KEY,
    flight_number VARCHAR2(10) UNIQUE NOT NULL,
    departure_city VARCHAR2(50) NOT NULL,
    arrival_city VARCHAR2(50) NOT NULL,
    departure_time TIMESTAMP NOT NULL,
    arrival_time TIMESTAMP NOT NULL,
    flight_type VARCHAR2(20) CHECK (flight_type IN ('domestic', 'international')) NOT NULL,
    total_seats NUMBER NOT NULL,
    available_seats NUMBER NOT NULL,
    price NUMBER(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- Create trigger for flights
CREATE OR REPLACE TRIGGER flights_bir 
BEFORE INSERT ON flights 
FOR EACH ROW
BEGIN
  SELECT flights_seq.NEXTVAL
  INTO   :new.flight_id
  FROM   dual;
END;
/

-- Insert sample flights
INSERT INTO flights (flight_number, departure_city, arrival_city, departure_time, arrival_time, flight_type, total_seats, available_seats, price) VALUES
('AI101', 'Delhi', 'Mumbai', TIMESTAMP '2024-03-20 08:00:00', TIMESTAMP '2024-03-20 10:00:00', 'domestic', 180, 180, 5000.00);

INSERT INTO flights (flight_number, departure_city, arrival_city, departure_time, arrival_time, flight_type, total_seats, available_seats, price) VALUES
('AI102', 'Mumbai', 'Delhi', TIMESTAMP '2024-03-20 12:00:00', TIMESTAMP '2024-03-20 14:00:00', 'domestic', 180, 180, 5500.00);

INSERT INTO flights (flight_number, departure_city, arrival_city, departure_time, arrival_time, flight_type, total_seats, available_seats, price) VALUES
('AI201', 'Delhi', 'London', TIMESTAMP '2024-03-20 09:00:00', TIMESTAMP '2024-03-20 15:00:00', 'international', 250, 250, 25000.00);

INSERT INTO flights (flight_number, departure_city, arrival_city, departure_time, arrival_time, flight_type, total_seats, available_seats, price) VALUES
('AI202', 'London', 'Delhi', TIMESTAMP '2024-03-20 14:00:00', TIMESTAMP '2024-03-20 20:00:00', 'international', 250, 250, 28000.00);