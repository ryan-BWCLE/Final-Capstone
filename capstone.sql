USE master
GO

--drop database if it exists
IF DB_ID('final_capstone') IS NOT NULL
BEGIN
	ALTER DATABASE final_capstone SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE final_capstone;
END

CREATE DATABASE final_capstone
GO

USE final_capstone
GO

--create tables
CREATE TABLE users (
	user_id int IDENTITY(1,1) NOT NULL,
	username varchar(50) NOT NULL,
	password_hash varchar(200) NOT NULL,
	salt varchar(200) NOT NULL,
	user_role varchar(50) NOT NULL
	CONSTRAINT PK_user PRIMARY KEY (user_id)
)

CREATE TABLE theater (
	theater_id int IDENTITY(1,1) NOT NULL,
	theater_name varchar(50) NOT NULL,

	CONSTRAINT PK_theater_id PRIMARY KEY (theater_id)
	)

CREATE TABLE movie (
	movie_id int IDENTITY(1,1) NOT NULL,
	movie_title varchar(50) NOT NULL,
	duration int NOT NULL,
	rating varchar(5) NOT NULL,
	film_description varchar(max) NOT NULL,
	poster_URL varchar(400) NOT NULL, 
	theater_id int NOT NULL,
	--THEATER_ID put back in

	CONSTRAINT PK_movie_id PRIMARY KEY (movie_id),
	CONSTRAINT FK_theater_id FOREIGN KEY (theater_id) REFERENCES theater(theater_id)
)

CREATE TABLE showing (
	showing_id int IDENTITY(1,1) NOT NULL,
	show_dateTime datetime NOT NULL,
	movie_id int NOT NULL,

	CONSTRAINT PK_showing_id PRIMARY KEY (showing_id),
	CONSTRAINT FK_movie_id FOREIGN KEY (movie_id) REFERENCES movie(movie_id),
)

CREATE TABLE theater_seats(
--these are the total seats
	seat_id int IDENTITY(1,1) NOT NULL,
	[row_number] int NOT NULL,
	seat_number int NOT NULL,
	theater_id int NOT NULL,

	CONSTRAINT PK_seat PRIMARY KEY (seat_id),
	CONSTRAINT FK_theater_number FOREIGN KEY (theater_id) REFERENCES theater(theater_id)
)

CREATE UNIQUE INDEX ix_row_seat ON theater_seats (theater_id, [row_number], seat_number)

GO

CREATE TABLE ticket (
--these are the tickets that have been SOLD
	ticket_id int IDENTITY (1,1) NOT NULL,
	seat_id int NOT NULL,
	showing_id int NOT NULL,
	is_adult bit NOT NULL,
	user_id int NULL,

	CONSTRAINT PK_ticket_id PRIMARY KEY (ticket_id),
	constraint FK_seat_id FOREIGN KEY (seat_id) REFERENCES theater_seats (seat_id),
	CONSTRAINT FK_showing_id FOREIGN KEY (showing_id) REFERENCES showing(showing_id),
	CONSTRAINT FK_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
)


--populate default data
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('user','Jg45HuwT7PZkfuKTz6IB90CtWY4=','LHxP4Xh7bN0=','user');
INSERT INTO users (username, password_hash, salt, user_role) VALUES ('admin','YhyGVQ+Ch69n4JMBncM4lNF/i9s=', 'Ar/aB2thQTI=','admin');

SET IDENTITY_INSERT theater ON;

INSERT INTO theater (theater_id, theater_name) VALUES 
(1, 'Theater One'),
(2, 'Theater Two'),
(3, 'Theater Three'),
(4, 'Theater Four');

SET IDENTITY_INSERT theater OFF;

/*run the below code after loading the movies (the ticket code buys tickets; the theater_seats code puts empty seats into the theaters)
Insert into ticket (seat_id, showing_id, user_id) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1),
(19, 1, 1),
(20, 1, 1);*/

DECLARE @Row INT, @Seat INT, @Theater Int = 1;
WHILE @Theater <= 4
BEGIN

	SET @Row = 1

	WHILE @Row <= 5 

	BEGIN
		SET @Seat = 1
		WHILE @Seat <= 10
		BEGIN
		
			--PRINT Concat(' ', @Theater, ' ', @Row, ' ', @Seat)

			INSERT INTO theater_seats (theater_id, [row_number], seat_number) VALUES
			(@Theater, @Row, @Seat)
			PRINT @@IDENTITY
			-- ^^this is the seat_id
			SET @Seat = @Seat + 1
		END

	SET @Row = @Row + 1
	END

SET @Theater = @Theater +1
END

GO