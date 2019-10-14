-- 1. Jockey cannot own the horse on which he participates in competitions
-- It is inpossible since jockeys and owners in different tables
-- 1'. Two horses with the same jockey can not. 
CREATE TRIGGER jockey_in_competition
ON dbo.results  
AFTER INSERT, UPDATE   
AS
BEGIN
	IF ((select count(*) from results inner join horses on horses.id = horse_id 
	where jockey_id = (select top 1 jockey_id from inserted inner join horses on horses.id = horse_id)
	and competition_id = (select top 1 competition_id from inserted)) > 1)
	begin
		RAISERROR ('Horse with this jockey already exists in competition.', 16, 10);
		ROLLBACK TRANSACTION;  
		RETURN 
	end
END;
GO

-- 2. Only one horse of one owner in competition.
CREATE TRIGGER horses_one_competition_in_week
ON dbo.results  
AFTER INSERT, UPDATE   
AS
BEGIN
	IF ((select count(*) from results inner join competitions on competition_id = competitions.id
	where horse_id = (select top 1 horse_id from inserted)
	and competitions.date between dateadd(day,-7,getdate()) and getdate()) > 2)
	begin
		RAISERROR ('Horse is already participating in 2 competitions this week.', 16, 10);
		ROLLBACK TRANSACTION;  
		RETURN 
	end
END;
GO

-- 3. Only one horse of one owner in competition.
CREATE TRIGGER horses_of_owner_in_competition
ON dbo.results  
AFTER INSERT, UPDATE   
AS
BEGIN
	IF ((select count(*) from results inner join horses on horses.id = horse_id 
	where owner_id = (select top 1 owner_id from inserted inner join horses on horses.id = horse_id)
	and competition_id = (select top 1 competition_id from inserted)) > 1)
	begin
		RAISERROR ('Horse of owner already exists in competition.', 16, 10);
		ROLLBACK TRANSACTION;  
		RETURN 
	end
END;
GO

-- 1'. Horses with same jockeys 1, 4, competition 5
INSERT INTO dbo.results VALUES (1, 4, 5);
INSERT INTO dbo.results VALUES (2, 1, 5);


-- 2. Competition on this week 5, 6, 7
INSERT INTO dbo.results VALUES (3, 5, 5);
INSERT INTO dbo.results VALUES (1, 5, 6);
INSERT INTO dbo.results VALUES (1, 5, 7);


-- 3. Horses with same owner 2, 3, competition 5
INSERT INTO dbo.results VALUES (2, 3, 5);
INSERT INTO dbo.results VALUES (4, 2, 5);