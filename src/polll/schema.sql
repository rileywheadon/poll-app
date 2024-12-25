-- Initialize the database.
-- Drop any existing data and create empty tables.

DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS poll;
DROP TABLE IF EXISTS poll_answer;
DROP TABLE IF EXISTS report;
DROP TABLE IF EXISTS response;
DROP TABLE IF EXISTS empty_response;
DROP TABLE IF EXISTS discrete_response;
DROP TABLE IF EXISTS numeric_response;
DROP TABLE IF EXISTS ranked_response;
DROP TABLE IF EXISTS tiered_response;

CREATE TABLE user (
	id INTEGER PRIMARY KEY, 
	username VARCHAR NOT NULL, 
	email VARCHAR UNIQUE NOT NULL, 
	account_created DATETIME NOT NULL, 
	last_online DATETIME NOT NULL, 
  last_poll_created DATETIME,
  next_poll_allowed DATETIME
);


CREATE TABLE poll (
	id INTEGER PRIMARY KEY, 
	creator_id INTEGER NOT NULL, 
	question VARCHAR NOT NULL, 
	poll_type VARCHAR NOT NULL, 
	date_created DATETIME NOT NULL, 
  FOREIGN KEY (creator_id) REFERENCES user (id)
);


CREATE TABLE poll_answer (
	id INTEGER PRIMARY KEY, 
	poll_id INTEGER NOT NULL, 
	answer VARCHAR NOT NULL, 
  FOREIGN KEY (poll_id) REFERENCES poll (id)
);


CREATE TABLE report (
	id INTEGER PRIMARY KEY, 
	poll_id INTEGER NOT NULL, 
	receiver_id INTEGER NOT NULL, 
	creator_id INTEGER NOT NULL, 
	timestamp DATETIME NOT NULL, 
  FOREIGN KEY (poll_id) REFERENCES poll (id),
  FOREIGN KEY (receiver_id) REFERENCES user (id),
  FOREIGN KEY (creator_id) REFERENCES user (id)
);


CREATE TABLE response (
	id INTEGER PRIMARY KEY, 
	user_id INTEGER NOT NULL, 
	poll_id INTEGER NOT NULL, 
	timestamp DATETIME NOT NULL, 
	FOREIGN KEY (user_id) REFERENCES user (id), 
	FOREIGN KEY (poll_id) REFERENCES poll (id)
);


CREATE TABLE empty_response (
	id INTEGER PRIMARY KEY, 
	response_id INTEGER NOT NULL, 
	FOREIGN KEY (response_id) REFERENCES response (id)
);


CREATE TABLE numeric_response (
	id INTEGER PRIMARY KEY, 
	response_id INTEGER NOT NULL, 
	value INTEGER NOT NULL, 
	FOREIGN KEY (response_id) REFERENCES response (id)
);


CREATE TABLE discrete_response (
	id INTEGER PRIMARY KEY, 
	answer_id INTEGER NOT NULL, 
	response_id INTEGER NOT NULL, 
	FOREIGN KEY (answer_id) REFERENCES poll_answer (id),
	FOREIGN KEY (response_id) REFERENCES response (id)
);


CREATE TABLE ranked_response (
	id INTEGER PRIMARY KEY, 
	answer_id INTEGER NOT NULL, 
	response_id INTEGER NOT NULL, 
	rank INTEGER NOT NULL, 
	FOREIGN KEY (answer_id) REFERENCES poll_answer (id), 
	FOREIGN KEY (response_id) REFERENCES response (id)
);


CREATE TABLE tiered_response (
	id INTEGER PRIMARY KEY, 
	answer_id INTEGER NOT NULL, 
	response_id INTEGER NOT NULL, 
	tier VARCHAR NOT NULL, 
	FOREIGN KEY (answer_id) REFERENCES poll_answer (id), 
	FOREIGN KEY (response_id) REFERENCES response (id)
);
