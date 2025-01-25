-- Initialize the database.
-- Drop any existing data and create empty tables.

DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS poll;
DROP TABLE IF EXISTS poll_board;
DROP TABLE IF EXISTS board;
DROP TABLE IF EXISTS poll_answer;
DROP TABLE IF EXISTS poll_report;
DROP TABLE IF EXISTS response;
DROP TABLE IF EXISTS discrete_response;
DROP TABLE IF EXISTS numeric_response;
DROP TABLE IF EXISTS ranked_response;
DROP TABLE IF EXISTS tiered_response;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS comment_report;
DROP TABLE IF EXISTS like;
DROP TABLE IF EXISTS dislike;

CREATE TABLE user (
	id INTEGER PRIMARY KEY, 
	username TEXT NOT NULL, 
	email TEXT UNIQUE NOT NULL, 
	account_created DATETIME NOT NULL, 
	last_online DATETIME NOT NULL, 
  last_poll_created DATETIME,
  next_poll_allowed DATETIME,
  is_muted BOOLEAN NOT NULL CHECK (is_muted IN (0, 1)), 
  is_banned BOOLEAN NOT NULL CHECK (is_banned IN (0, 1))
);


CREATE TABLE poll (
	id INTEGER PRIMARY KEY, 
	creator_id INTEGER NOT NULL, 
	question TEXT NOT NULL, 
	poll_type TEXT NOT NULL, 
	date_created DATETIME NOT NULL, 
  is_pinned BOOLEAN NOT NULL CHECK (is_pinned IN (0, 1)), 
  is_anonymous BOOLEAN NOT NULL CHECK (is_anonymous IN (0, 1)), 
  is_active BOOLEAN NOT NULL CHECK (is_active IN (0, 1)), 
  FOREIGN KEY (creator_id) REFERENCES user (id)
);


-- Defines the many-to-many relationship between polls and boards
CREATE TABLE poll_board (
  poll_id INTEGER NOT NULL,
  board_id INTEGER NOT NULL,
  FOREIGN KEY (poll_id) REFERENCES poll (id),
  FOREIGN KEY (board_id) REFERENCES board (id)
);


CREATE TABLE board (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);


CREATE TABLE poll_answer (
	id INTEGER PRIMARY KEY, 
	poll_id INTEGER NOT NULL, 
	answer TEXT NOT NULL, 
  FOREIGN KEY (poll_id) REFERENCES poll (id)
);


CREATE TABLE poll_report (
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
	tier TEXT NOT NULL, 
	FOREIGN KEY (answer_id) REFERENCES poll_answer (id), 
	FOREIGN KEY (response_id) REFERENCES response (id)
);

CREATE TABLE comment (
  id INTEGER PRIMARY KEY,
  poll_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_id INTEGER NOT NULl,
  comment TEXT NOT NULL,
	timestamp DATETIME NOT NULL, 
  FOREIGN KEY (poll_id) REFERENCES poll (id),
  FOREIGN KEY (user_id) REFERENCES user (id),
  FOREIGN KEY (parent_id) REFERENCES comment (id)
);


CREATE TABLE comment_report (
	id INTEGER PRIMARY KEY, 
	comment_id INTEGER NOT NULL, 
	receiver_id INTEGER NOT NULL, 
	creator_id INTEGER NOT NULL, 
	timestamp DATETIME NOT NULL, 
  FOREIGN KEY (comment_id) REFERENCES poll (id),
  FOREIGN KEY (receiver_id) REFERENCES user (id),
  FOREIGN KEY (creator_id) REFERENCES user (id)
);


CREATE TABLE like (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  comment_id INTEGER NOT NULL,
	timestamp DATETIME NOT NULL, 
  FOREIGN KEY (user_id) REFERENCES user (id),
  FOREIGN KEY (comment_id) REFERENCES comment (id)
);

CREATE TABLE dislike (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  comment_id INTEGER NOT NULL,
	timestamp DATETIME NOT NULL, 
  FOREIGN KEY (user_id) REFERENCES user (id),
  FOREIGN KEY (comment_id) REFERENCES comment (id)
);
