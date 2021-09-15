
SELECT [CalendarDate]
      ,[utmSource]
      ,[number_of_registrations]
      ,[number_of_purchases]
      ,[total_billing]
  FROM [DW_Measurements].[dbo].[utm_report]
  where [total_billing] <> 0 
    or [number_of_purchases] <> 0 
	or [number_of_registrations] <> 0


SELECT TOP (1000) [CalendarDate]
  FROM [DW_Measurements].[dbo].[dim_date]


SELECT  min([CalendarDate])
  FROM [DW_Measurements].[dbo].[utm_report]

SELECT  max([CalendarDate])
	FROM [DW_Measurements].[dbo].[utm_report]

 
EXEC	[date_dim_builder]
		@todate = '2021-09-09'

EXEC	[utm_report_builder]

	
