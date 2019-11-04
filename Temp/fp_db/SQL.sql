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

INSERT INTO [dbo].[drug_like] VALUES('test', 'test', 0x0);
