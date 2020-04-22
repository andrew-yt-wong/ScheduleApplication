DROP DATABASE IF EXISTS FreeTime;
CREATE DATABASE FreeTime;

USE FreeTime;

CREATE TABLE Friends (
	friend_id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL,
    schedule_id VARCHAR(45) NOT NULL
);

CREATE TABLE Events (
	event_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    start_time TIME,
    end_time TIME,
    day VARCHAR(45) NOT NULL
);

CREATE TABLE Schedules (
	schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    FOREIGN KEY fk1(event_id) REFERENCES Events(event_id)
);

CREATE TABLE Users (
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(45) NOT NULL,
    password VARCHAR(45) NOT NULL
    -- friend_id INT, 
    -- schedule_id INT,
    -- FOREIGN KEY fk1(friend_id) REFERENCES Friends(friend_id),
    -- FOREIGN KEY fk2(schedule_id) REFERENCES Schedules(schedule_id)
);

INSERT INTO Users (username, password) VALUES ('awong827', 'password');