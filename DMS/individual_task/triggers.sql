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

drop trigger horses_of_owner_in_competition

INSERT INTO dbo.results VALUES (2, 3, 6);
