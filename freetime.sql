DROP DATABASE IF EXISTS FreeTime;
CREATE DATABASE FreeTime;

USE FreeTime;

CREATE TABLE Events (
	event_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    start_time TIME NOT NULL,
    duration DOUBLE NOT NULL,
    day VARCHAR(45) NOT NULL,
    color VARCHAR(45) NOT NULL
);

CREATE TABLE Schedules (
	schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    FOREIGN KEY fk1(event_id) REFERENCES Events(event_id)
);

CREATE TABLE Users (
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(45) NOT NULL,
    password VARCHAR(256) NOT NULL
    -- friend_id INT, 
    -- schedule_id INT,
    -- FOREIGN KEY fk1(friend_id) REFERENCES Friends(friend_id),
    -- FOREIGN KEY fk2(schedule_id) REFERENCES Schedules(schedule_id)
);

CREATE TABLE Friends (
	id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    friend_id INT,
    FOREIGN KEY user(user_id) REFERENCES Users(user_id),
    FOREIGN KEY friend(friend_id) REFERENCES Users(user_id)
);

INSERT INTO Users (username, password) VALUES ('user1', 'password');
INSERT INTO Users (username, password) VALUES ('user2', 'password');

INSERT INTO Friends (user_id, friend_id) VALUES (1, 2);


