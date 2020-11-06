
-- Drop all tables, views, procedures
DROP FUNCTION IF EXISTS calculatePrice;
DROP FUNCTION IF EXISTS calculateFreeSeats;
--DROP PROCEDURE IF EXISTS;
DROP PROCEDURE IF EXISTS addPayment;
DROP PROCEDURE IF EXISTS addContact;
DROP PROCEDURE IF EXISTS addPassenger;
DROP PROCEDURE IF EXISTS addReservation;
DROP PROCEDURE IF EXISTS seeFreeSeats;
DROP PROCEDURE IF EXISTS addFlight;
DROP PROCEDURE IF EXISTS addRoute;
DROP PROCEDURE IF EXISTS addDestination;
DROP PROCEDURE IF EXISTS addDay;
DROP PROCEDURE IF EXISTS addYear;
-- DROP TABLE IF EXISTS;

DROP VIEW IF EXISTS allFlights;
DROP TABLE IF EXISTS RESERVATION_PASSENGERS CASCADE;
DROP TABLE IF EXISTS TICKET CASCADE;
DROP TABLE IF EXISTS PAYINFO CASCADE;
DROP TABLE IF EXISTS BOOKING CASCADE;
DROP TABLE IF EXISTS RESERVATION CASCADE;
DROP TABLE IF EXISTS CONTACT_PERSON CASCADE;
DROP TABLE IF EXISTS PASSENGER CASCADE;
DROP TABLE IF EXISTS FLIGHT CASCADE;
DROP TABLE IF EXISTS WEEKLY_SCHEDULE CASCADE;
DROP TABLE IF EXISTS WEEKDAY CASCADE;
DROP TABLE IF EXISTS ROUTE CASCADE;
DROP TABLE IF EXISTS YEAR CASCADE;
DROP TABLE IF EXISTS AIRPORT CASCADE;

-- Airport
CREATE TABLE AIRPORT(
    Airport_code VARCHAR(3),
    Country VARCHAR(30),
    Airport_name VARCHAR(30),
    PRIMARY KEY(Airport_code)
);

-- Year
CREATE TABLE YEAR(
    Year INT,
    Profitfactor DOUBLE,
    PRIMARY KEY(Year)
);


-- Route
CREATE TABLE ROUTE(
  Arriving_to VARCHAR(3),
  Departing_from VARCHAR(3),
  Year INT,
  Route_price DOUBLE,
  PRIMARY KEY(Arriving_to, Departing_from, Year),
  FOREIGN KEY (Arriving_to) REFERENCES AIRPORT(Airport_code),
  FOREIGN KEY (Departing_from) REFERENCES AIRPORT(Airport_code),
  FOREIGN KEY (Year) REFERENCES YEAR(Year)
);

-- Weekday
CREATE TABLE WEEKDAY(
    Day VARCHAR(10),
    Year INT,
    Weekdayfactor DOUBLE,
    PRIMARY KEY(Day, Year),
    FOREIGN KEY(Year) REFERENCES YEAR(Year)
);

-- Weekly Schedule
CREATE TABLE WEEKLY_SCHEDULE (
    Id INT, -- OSÄKERT
    RArriving_to VARCHAR(3),
    RDeparting_from VARCHAR(3),
    RYear INT,
    Day_of_week VARCHAR(10),
    WYear INT,
    T_of_departure TIME,
    PRIMARY KEY(Id),
    FOREIGN KEY(RArriving_to) REFERENCES ROUTE(Arriving_to),
    FOREIGN KEY(RDeparting_from) REFERENCES ROUTE(Departing_from),
    FOREIGN KEY(RYear) REFERENCES ROUTE(Year),
    FOREIGN KEY(Day_of_week) REFERENCES WEEKDAY(Day),
    FOREIGN KEY(WYear) REFERENCES WEEKDAY(Year)
);
-- Flight
CREATE TABLE FLIGHT (
    Flightnumber INT,
    Week INT,
    Total_seats INT,
    Weekly_flight INT,
    PRIMARY KEY (Flightnumber),
    FOREIGN KEY (Weekly_flight) REFERENCES WEEKLY_SCHEDULE(Id)
);

-- Passenger
CREATE TABLE PASSENGER (
    Pass_number INT,
    Fullname VARCHAR(30),
    PRIMARY KEY (Pass_number)
);

-- Contact Person
CREATE TABLE CONTACT_PERSON (
    Email VARCHAR(30),
    Phone_number BIGINT,
    Passenger INT,
    PRIMARY KEY (Passenger),
    FOREIGN KEY(Passenger) REFERENCES PASSENGER(Pass_number)
);

--Reservation
CREATE TABLE RESERVATION(
    Reservation_id INT,
    Flight INT,
    Cperson INT,
    PRIMARY KEY (Reservation_id),
    FOREIGN KEY(Cperson) REFERENCES CONTACT_PERSON(Passenger)
);

-- Booking
CREATE TABLE BOOKING(
    Reservation INT,
    Total_price DOUBLE,
    PRIMARY KEY (Reservation),
    FOREIGN KEY (Reservation) REFERENCES RESERVATION(Reservation_id)
);

-- Payinfo
CREATE TABLE PAYINFO (
    Reservation INT,
    Cardnumber BIGINT,
    Cardholder VARCHAR(30),
    PRIMARY KEY (Reservation, Cardnumber),
    FOREIGN KEY (Reservation) REFERENCES RESERVATION(Reservation_id)
);

-- Ticket
CREATE TABLE TICKET(
    Passenger INT,
    Booking INT,
    Ticket_number INT,
    PRIMARY KEY (Ticket_number),
    FOREIGN KEY (Passenger) REFERENCES PASSENGER(Pass_number),
    FOREIGN KEY (Booking) REFERENCES BOOKING(Reservation)
);

-- Reservation Passengers
CREATE TABLE RESERVATION_PASSENGERS (
    Reservation INT,
    Passenger INT,
    PRIMARY KEY (Reservation, Passenger),
    FOREIGN KEY (Reservation) REFERENCES RESERVATION(Reservation_id),
    FOREIGN KEY (Passenger) REFERENCES PASSENGER(Pass_number)
);



SHOW TABLES;


-- Database procedures and triggers
----------------------------------UPG 3------------------------------------
delimiter //

CREATE PROCEDURE addYear (IN year INT, IN factor DOUBLE)
BEGIN
    INSERT INTO YEAR VALUES (year, factor);
END//


CREATE PROCEDURE addDay (IN year INT, IN day VARCHAR(10), IN factor DOUBLE)
BEGIN
    INSERT INTO WEEKDAY VALUES (day, year, factor);
END//


CREATE PROCEDURE addDestination (IN airport_code VARCHAR(3), IN name VARCHAR(30), IN country VARCHAR(30))
BEGIN
    INSERT INTO AIRPORT VALUES (airport_code, country, name);
END//


CREATE PROCEDURE addRoute (IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INT, IN routeprice DOUBLE)
BEGIN
    INSERT INTO ROUTE VALUES (arrival_airport_code, departure_airport_code, year, routeprice);
END//


CREATE PROCEDURE addFlight (IN departure_airport_code VARCHAR(3), IN arrival_airport_code VARCHAR(3), IN year INT, IN day VARCHAR(10),IN departure_time TIME)
BEGIN
    DECLARE schedule_id INT;
    DECLARE week_number INT;
    DECLARE flight_id INT;

    SET schedule_id = (SELECT COUNT(*) FROM WEEKLY_SCHEDULE) + 1;

    INSERT INTO WEEKLY_SCHEDULE VALUES(schedule_id, arrival_airport_code, departure_airport_code, year, day, year, departure_time);
    
    SET week_number = 1;
    SET flight_id = (SELECT COUNT(*) FROM FLIGHT) + 1;

    flightloop: LOOP

        INSERT INTO FLIGHT VALUES(flight_id, week_number, 40, schedule_id);

        SET flight_id = flight_id + 1;
        SET week_number = week_number + 1;

        IF week_number < 53 THEN
            ITERATE flightloop;
        END IF;
        LEAVE flightloop;

    END LOOP flightloop;
END//



----------------------------------UPG 4------------------------------------
CREATE FUNCTION calculateFreeSeats(flightnumber INT)
RETURNS INT
BEGIN
    DECLARE paid_seats INT;
    DECLARE total_seats INT;

    SET paid_seats = (SELECT COUNT(*)
    FROM TICKET AS T, BOOKING AS B, RESERVATION AS R
    WHERE T.Booking = B.Reservation AND B.Reservation = R.Reservation_id AND R.Flight = flightnumber);
    
    SET total_seats = (SELECT F.Total_seats 
    FROM FLIGHT AS F
    WHERE F.Flightnumber = flightnumber);

    RETURN (total_seats-paid_seats);
END//

-- Total Price = Routeprice * Weekdayfactor * (BookedPassengers + 1)/40 * profitfactor

CREATE FUNCTION calculatePrice(flightnumber INT)
RETURNS DOUBLE
BEGIN
    DECLARE Routeprice DOUBLE; 
    DECLARE Weekdayfactor DOUBLE; 
    DECLARE BookedPassengers INT; 
    DECLARE Profitfactor DOUBLE; 

    SET Routeprice = (SELECT R.Route_price 
    FROM ROUTE AS R, FLIGHT AS F, WEEKLY_SCHEDULE AS W 
    WHERE R.Arriving_to = W.RArriving_to AND R.Departing_from = W.RDeparting_from 
    AND R.Year = W.RYear AND W.Id = F.Weekly_flight AND F.Flightnumber = flightnumber);

    SET Weekdayfactor = (SELECT WD.Weekdayfactor
    FROM WEEKDAY AS WD, FLIGHT AS F, WEEKLY_SCHEDULE AS WS
    WHERE WD.Day = WS.Day_of_week AND WD.Year = WS.WYear AND WS.Id = F.Weekly_flight 
    AND F.Flightnumber = flightnumber);

    SET BookedPassengers = (SELECT COUNT(*)
    FROM TICKET AS T, BOOKING AS B, RESERVATION AS R
    WHERE T.Booking = B.Reservation AND B.Reservation = R.Reservation_id AND R.Flight = flightnumber);

    SET Profitfactor = (SELECT Y.Profitfactor
    FROM YEAR as Y, FLIGHT AS F, WEEKLY_SCHEDULE AS WS 
    WHERE Y.Year = WS.WYear AND WS.Id = F.Weekly_flight AND F.Flightnumber = flightnumber);
    
    RETURN ROUND((Routeprice * Weekdayfactor * (BookedPassengers + 1) / 40 * Profitfactor), 3);
END//



CREATE PROCEDURE seeFreeSeats(IN flightnumber INT)
BEGIN
    DECLARE p DOUBLE;
    SET p = calculatePrice(flightnumber);
    SELECT p;
END//


----------------------------------UPG 5------------------------------------

CREATE TRIGGER generateTicket AFTER INSERT ON BOOKING
FOR EACH ROW
BEGIN
    DECLARE rand_ticket_nr INT;
    DECLARE passengerExists INT;
    DECLARE passenger INT;

    DECLARE done INT DEFAULT 0;
    
    DECLARE cur CURSOR FOR
    SELECT RP.Passenger 
    FROM RESERVATION_PASSENGERS AS RP
    WHERE RP.Reservation = NEW.Reservation;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN cur;
    addTickets: LOOP
    
        FETCH cur INTO passenger;
        IF done THEN
            LEAVE addTickets;
        END IF;
        
        SET rand_ticket_nr = CAST(RAND()*1000000 AS INT);

        SET passengerExists = (SELECT COUNT(*)
        FROM TICKET AS T
        WHERE T.Ticket_number = rand_ticket_nr);

        WHILE passengerExists > 0 DO
            SET rand_ticket_nr = CAST(RAND()*1000000 AS INT);
            
            SET passengerExists = (SELECT COUNT(*)
            FROM TICKET AS T
            WHERE T.Ticket_number = rand_ticket_nr);
        END WHILE;

        INSERT INTO TICKET VALUES(passenger, NEW.Reservation, rand_ticket_nr);

    END LOOP;
    CLOSE cur;
END//


----------------------------------UPG 6------------------------------------

CREATE PROCEDURE addReservation(IN departure_airport_code VARCHAR(3), 
IN arrival_airport_code VARCHAR(3), IN year INT, IN week INT, IN day VARCHAR(10),
IN departure_time TIME, IN number_of_passengers INT, OUT output_reservation INT)
BEGIN
    DECLARE flight INT;
    DECLARE free_seats INT;
    DECLARE fake_bool INT;

    SET flight = (SELECT F.Flightnumber
    FROM FLIGHT AS F, WEEKLY_SCHEDULE AS WS 
    WHERE F.Week = week AND WS.Id = F.Weekly_flight AND WS.RArriving_to = arrival_airport_code AND
    WS.RDeparting_from = departure_airport_code AND WS.RYear = year AND WS.Day_of_week = day
    AND WS.T_of_departure = departure_time);

    IF ISNULL(flight) THEN 
        SET fake_bool = 0;
    ELSE
        SET fake_bool = 1;
    END IF;

    IF fake_bool = 1 THEN
        
        SET free_seats = calculateFreeSeats(flight);

        IF free_seats >= number_of_passengers THEN
            SET output_reservation = (SELECT COUNT(*) FROM RESERVATION) + 1;

            INSERT INTO RESERVATION VALUES (output_reservation, flight, NULL);
        ELSE
            SELECT "Too few seats left on this flight" AS 'Message';
        END IF;
    ELSE
        SELECT "There exist no flight for the given route, date and time" AS "Message";
    END IF;

END//


CREATE PROCEDURE addPassenger(IN reservation_nr INT, IN pass_nr INT, IN name VARCHAR(30))
BEGIN
    DECLARE passengerExists INT;
    DECLARE reservationExists INT;
    DECLARE alreadyBooked INT;
    
    SET reservationExists = (SELECT COUNT(*)
    FROM RESERVATION AS R 
    WHERE R.Reservation_id = reservation_nr);
    
    IF reservationExists > 0 THEN

        SET alreadyBooked = (SELECT COUNT(*)
        FROM BOOKING AS B 
        WHERE B.Reservation = reservation_nr);

        IF alreadyBooked = 0 THEN
            
            SET passengerExists = (SELECT COUNT(*) 
            FROM PASSENGER 
            WHERE Pass_number = pass_nr);
        
            IF passengerExists = 0 THEN
                INSERT INTO PASSENGER VALUES(pass_nr, name);
            END IF;
            
            INSERT INTO RESERVATION_PASSENGERS VALUES(reservation_nr, pass_nr);
        ELSE
            SELECT "The booking has already been payed and no futher passengers can be added" AS "Message";
        END IF;
    ELSE
        SELECT "The given reservation number does not exist" as "Message";
    END IF;
END//

CREATE PROCEDURE addContact(IN reservation_nr INT, IN pass_nr INT, IN email VARCHAR(30), IN phone BIGINT)
BEGIN
    DECLARE isInReservation INT;
    DECLARE reservationExists INT;
    
    SET reservationExists = (SELECT COUNT(*)
    FROM RESERVATION AS R 
    WHERE R.Reservation_id = reservation_nr);


    
    SET isInReservation = (SELECT COUNT(*) 
    FROM RESERVATION_PASSENGERS AS RP
    WHERE RP.Reservation = reservation_nr AND RP.Passenger = pass_nr); 

    IF reservationExists > 0 THEN
        IF isInReservation > 0 THEN
            INSERT INTO CONTACT_PERSON VALUES (email, phone, pass_nr);
        ELSE
            SELECT "The person is not a passenger of the reservation" AS "Message";
        END IF;
    ELSE
        SELECT "The given reservation number does not exist" AS "Message";
    END IF;
END//

CREATE PROCEDURE addPayment(IN reservation_nr INT, IN cardholder_name VARCHAR(30), IN creditcard_number BIGINT)
BEGIN
    DECLARE has_contact INT;
    DECLARE flight_nr INT;
    DECLARE amount_passengers INT;
    DECLARE free_seats INT;
    DECLARE payment_price DOUBLE;
    DECLARE reservationExists INT;

    SET reservationExists = (SELECT COUNT(*)
    FROM RESERVATION AS R 
    WHERE R.Reservation_id = reservation_nr);

    IF reservationExists > 0 THEN
        
        SET has_contact = (SELECT COUNT(*)
        FROM CONTACT_PERSON AS CP, RESERVATION_PASSENGERS AS RP
        WHERE RP.Reservation = reservation_nr AND RP.Passenger = CP.Passenger);

        SET amount_passengers = (SELECT COUNT(*) 
        FROM RESERVATION_PASSENGERS AS RP 
        WHERE RP.Reservation = reservation_nr);

        SET flight_nr = (SELECT R.Flight 
        FROM RESERVATION AS R
        WHERE R.Reservation_id = reservation_nr);

    
        IF has_contact > 0 THEN
            
            SET free_seats = calculateFreeSeats(flight_nr);
            IF free_seats >= amount_passengers THEN

                SELECT sleep(5);
                
                INSERT INTO PAYINFO VALUES (reservation_nr, creditcard_number, cardholder_name);
        
                SET payment_price = calculatePrice(flight_nr);
                
                INSERT INTO BOOKING VALUES (reservation_nr, payment_price);
            ELSE
                SELECT "Not enough free seats, deleting reservation" AS "Message";
                
                DELETE FROM RESERVATION_PASSENGERS
                WHERE Reservation = reservation_nr;
                
                DELETE FROM RESERVATION
                WHERE Reservation_id = reservation_nr;
            END IF;
        ELSE
            SELECT "The reservation has no contact person" AS "Message";
        END IF;
    ELSE
        SELECT "The given reservation number does not exist " AS "Message";
    END IF;
END//


delimiter ;

----------------------------------UPG 7------------------------------------

---------- Views -----------

CREATE VIEW allFlights (departure_city_name, destination_city_name, departure_time, departure_day, departure_week, departure_year, nr_of_free_seats, current_price_per_seat)
AS SELECT ADEP.Airport_name, ADES.Airport_name, WS.T_of_departure, WS.Day_of_week, F.Week, WS.WYear, calculateFreeSeats(F.Flightnumber), calculatePrice(F.Flightnumber)
FROM AIRPORT AS ADEP, AIRPORT AS ADES, WEEKLY_SCHEDULE AS WS, FLIGHT AS F
WHERE ADEP.Airport_code = WS.RDeparting_from AND ADES.Airport_code = WS.RArriving_to AND F.Weekly_flight = WS.Id;


----------------------------------UPG 8------------------------------------

/*
a)
In the first hand you want encrypt the sensitive data in the database so that it is unusable if a hacker manages to access it.
To further increase the security you might also want to limit all direct access to the database so that all the data is manipulated within stored procedures in the database and not by functions in the frontend. It is also important to set appropriate privileges and roles where only the specific roles can access the sensitive data.


b)
1. Stored procedures can be faster than functions written in the frontend using other languages since they are compiled and saved in the cache memory of the database.

2. Stored procedures limit access to the database relation-tables which makes it more secure.

3. If multiple applications want to use the database they can directly use the stored procedure instead of writing their own function. This will reduce duplication of code since it only needs to be in one place, the database.


9.
b. No, because after writing start transaction we are working in an isolated environment in that session (since we disable autocommit mode), therefore the database as seen by all other sessions will be unchanged until the changes in session A are commited (or rolled back but then the database will be unchanged anyways).
c. For the reason stated above the sessions will be completly independent from eachother and isolated. In session B the reservation made in A will not be visible until it is commited in A. If both transactions try to change the same row the second one will be blocked until the first is commited or rolled back. The first session to modify the row will acquire an exclusive lock that will block other sessions from modifying until the lock is released.


10.
a. There was no overbooking that occured, this was because one of the "customers" probably added the booking before the other checked for the amount of free seats.
b. Yes, an overbooking could definetly happen. If two sessions would have checked the amount of free seats before any of them actually inserted the booking then they would both have inserted a booking and we could have an overbooking if both together needed more seats than available.
c. The theoretical case was possible to simulate with a 5 second sleep placed inside the if-statement where free seats have been checked but the booking has not yet been made. This resulted in the session finishing first getting 19 seats left available and the session following getting -2 seats left available.
d. since the school servers are still not functioning Olaf told us that we do not have to answer this particular question.



SECONDARY INDEXES:

Secondary indexes can improve performance when a user wants to search for a row using something else than the primary key.

In our case we could use a secondary index to improve performance when searching for a flight for a specific week. By using week as a secondary index, which is much more useful to a user, it would make searches like this go faster.

It could also be useful to be able to search for passengers by name instead of passport number in an efficient way.

*/

-- CALLING PROCEDURES

-- CALL addYear(2020, 34.5);
-- CALL addDay(2020,'Monday', 23.7);
-- CALL addDestination('ARN', 'Arlanda', 'Sweden');
-- CALL addDestination('GOT', 'Landvetter', 'Sweden');
-- CALL addDestination('JFK', 'John F Kennedy Airport', 'USA');
-- CALL addDestination('LAX', 'Los Angeles Airport', 'USA');
-- CALL addRoute('ARN', 'GOT', 2020, 999.99);
-- CALL addRoute('GOT', 'ARN', 2020, 999.99);
-- CALL addRoute('JFK', 'ARN', 2020, 9999.99);
-- CALL addRoute('ARN', 'JFK', 2020, 9999.99);
-- CALL addFlight('ARN', 'GOT', 2020, 'Monday', '10:00:00');
-- CALL addFlight('GOT', 'ARN', 2020, 'Monday', '10:00:00');
-- CALL addFlight('ARN', 'JFK', 2020, 'Monday', '06:00:00');
-- CALL addFlight('JFK', 'ARN', 2020, 'Monday', '06:00:00');

-- SELECT * FROM ALL_FLIGHTS;

-- -- SOURCE Question3.sql;
-- -- SELECT COUNT(*) FROM FLIGHT;

-- -- SELECT * FROM YEAR;
-- -- SELECT * FROM WEEKDAY;
-- -- SELECT * FROM AIRPORT;
-- -- SELECT * FROM ROUTE;
-- -- SELECT * FROM FLIGHT;
-- -- SELECT * FROM WEEKLY_SCHEDULE;
-- ----------------------------------UPG 4------------------------------------
-- CALL seeFreeSeats(1);
-- ----------------------------------UPG 5------------------------------------
-- --CALL testGenerate(1);
-- ----------------------------------UPG 6------------------------------------


-- CALL addReservation('JFK', 'ARN', 2020, 23, 'Monday', '06:00:00', 5, @output_nr);

-- CALL addPassenger(@output_nr, 1234, 'Frodo');
-- CALL addPassenger(@output_nr, 4321, 'Sam');

-- CALL addContact(@output_nr, 4321, 'sam@fylke.com', 123456789);

-- SELECT * FROM PASSENGER;
-- SELECT * FROM RESERVATION_PASSENGERS;
-- SELECT * FROM CONTACT_PERSON;

-- CALL addPayment(@output_nr, 'Sam', 6764186764);

-- SELECT * FROM PAYINFO;
-- SELECT * FROM BOOKING;
-- -- SELECT @output_nr;

SOURCE Question7.sql
