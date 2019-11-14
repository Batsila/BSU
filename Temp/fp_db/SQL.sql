CREATE FUNCTION [h_d] 
(
	@x varbinary(200),
	@y varbinary(200)
)
RETURNS int
AS
BEGIN
	declare @distance int;

		declare @i int;
		
		set @i = 0;
		set @distance = 0;

		WHILE @i < 200
		begin
			if not (SUBSTRING(@x, @i, 1) = SUBSTRING(@y, @i, 1))
			begin
				set @distance = @distance + 1;
			end
			set @i = @i + 1;
		end
		


	return @distance
END
GO

CREATE TABLE [dbo].[drug_like]
(
	[zinc_id] [varchar](255) NOT NULL,
	[smiles] [varchar](max) NOT NULL,
	[fp] [varbinary](200) NOT NULL,
	PRIMARY KEY CLUSTERED 
	(
		[zinc_id] ASC
	)
	WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_drug_like_fp] ON [drug_like]([fp]);

INSERT INTO [dbo].[drug_like] VALUES('test', 'test', 0x0);

