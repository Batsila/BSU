DROP FUNCTION dbo.CHECK_HORSE_OWNER;
DROP FUNCTION dbo.CHECK_HORSE_JOCKEY;

CREATE FUNCTION [CHECK_HORSE_OWNER] 
(
	@horse_id int,
	@owner_id int
)
RETURNS bit
AS
BEGIN
	if Exists (select * from dbo.horses where id = @horse_id)
	begin
		declare @current_owner_id int
		set @current_owner_id = (select owner_id from dbo.horses where id = @horse_id)
		if not @current_owner_id = @owner_id
		begin
			return 0
		end
	end
	return 1
END
GO

CREATE FUNCTION [CHECK_HORSE_JOCKEY] 
(
	@horse_id int,
	@jockey_id int,
	@contract_termination_date date
)
RETURNS bit
AS
BEGIN
	if Exists (select * from dbo.horses where id = @horse_id)
	begin
		declare @current_jockey_id int
		set @current_jockey_id = (select jockey_id from dbo.horses where id = @horse_id)
		if @current_jockey_id = @jockey_id
		begin
			if @contract_termination_date < GETDATE()
			begin
				return 0
			end
		end
		else
		begin
			return 0
		end
	end
	return 1
END
GO

