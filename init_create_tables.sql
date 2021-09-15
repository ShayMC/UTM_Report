

CREATE TABLE [dbo].[dim_date](
	[CalendarDate] [date] NULL
) 

CREATE TABLE [dbo].[utm_report](
	[CalendarDate] [date] NULL,
	[utmSource] [varchar](100) NULL,
	[number_of_registrations] [int] NULL,
	[number_of_purchases] [int] NULL,
	[total_billing] [decimal](12, 6) NULL
) 
