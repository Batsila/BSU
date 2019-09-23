ALTER TABLE horses
DROP CONSTRAINT CHECK_OWNER; 
ALTER TABLE horses
DROP CONSTRAINT CHECK_JOCKEY; 
DROP TABLE results;
DROP TABLE horses;
DROP TABLE competitions;
DROP TABLE owners;
DROP TABLE jockeys;

CREATE TABLE owners (
	id int NOT NULL PRIMARY KEY IDENTITY(1,1),
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	address varchar(max)
);

CREATE TABLE jockeys (
	id int NOT NULL PRIMARY KEY IDENTITY(1,1),
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	age int NOT NULL CHECK (age between 10 and 72),
	address varchar(max),
	height int NOT NULL CHECK (height between 120 and 210),
	weight int NOT NULL CHECK (weight between 25 and 130)
);

CREATE TABLE horses (
	id int NOT NULL PRIMARY KEY IDENTITY(1,1),
	name varchar(50) NOT NULL,
	age int NOT NULL CHECK (age between 0 and 45),
	gender varchar(8) CHECK (gender IN ('mare', 'stallion')),
	owner_id int FOREIGN KEY REFERENCES owners(id) NOT NULL,
	jockey_id int FOREIGN KEY REFERENCES jockeys(id) NOT NULL,
	contract_termination_date date NOT NULL,
	constraint CHECK_OWNER check (dbo.[CHECK_HORSE_OWNER](id, owner_id) = 1),
	constraint CHECK_JOCKEY check (dbo.[CHECK_HORSE_JOCKEY](id, jockey_id, contract_termination_date) = 1)
);

CREATE TABLE competitions (
	id int NOT NULL PRIMARY KEY IDENTITY(1,1),
	date DATE NOT NULL CHECK (date < GETDATE() and date > '2000-01-01'),
	time time NOT NULL,
	address varchar(max) NOT NULL,
	name varchar(max) NULL,
	races int NOT NULL CHECK (races between 1 and 42)
);

CREATE TABLE results (
	place int NOT NULL CHECK(place > 0),
	horse_id int FOREIGN KEY REFERENCES horses(id) NOT NULL,
	competition_id int FOREIGN KEY REFERENCES competitions(id) NOT NULL,
	PRIMARY KEY (horse_id, competition_id),
	unique(place, competition_id)
);
	
