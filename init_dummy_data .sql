
DROP TABLE IF EXISTS users_utm
DROP TABLE IF EXISTS users
DROP TABLE IF EXISTS purchases


CREATE TABLE [dbo].[users_utm](
	[utmDate] [datetime] NULL,
	[userId] [int] NULL,
	[utmSource] [varchar](100) NULL
) 

CREATE TABLE [dbo].[users](
	[userId] [int] NULL,
	[registrationDate] [datetime] NULL
) 


CREATE TABLE [dbo].[purchases](
	[purchaseDate] [datetime] NULL,
	[userId] [int] NULL,
	[billing] [decimal](12, 6) NULL
) 


INSERT INTO [dbo].[users_utm]
           ([utmDate]
           ,[userId]
           ,[utmSource])
     VALUES
           ('1/1/2020 01:20:05',12121,'Facebook'),
		   ('2/2/2020 01:20:06',12121,'Google'),
		   ('2/2/2020 11:00:00',6161,'Google'),
		   ('2/2/2020 19:22:00',6161,'Facebook'),
		   ('5/2/2020 11:30:00',1111,'Google'),
		   ('5/7/2020 12:00:00',6161,'LinkedIn'),
		   ('5/9/2020 12:00:00',6161,'Google'),
		   ('2/2/2020 09:00:00',00001,'LinkedIn')



INSERT INTO [dbo].[users]
           ([userId],[registrationDate])
     VALUES(12121,'1/1/2020 01:20:05'),
	        (6161,'2/2/2020 11:00:00'),
			(1111,'5/2/2020 11:30:00'),
			(00001,'2/2/2020 09:00:00')


INSERT INTO [dbo].[purchases]
           ([purchaseDate]
           ,[userId]
           ,[billing])
     VALUES
           ('2/2/2020 06:00:06',12121,100),
		   ('2/2/2020 12:00:00',6161,1000),
		   ('5/9/2020 13:00:00',6161,100)


