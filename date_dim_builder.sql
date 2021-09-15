

CREATE PROCEDURE [date_dim_builder]

	-- Init parameters for the stored procedure
	@todate date = '2050-12-31',
	@fromdate date = '1990-01-01'
	
AS
BEGIN
	
	-- delete data from prev run.
	TRUNCATE TABLE dim_date

	;With DateSequence( [Date] ) AS
	(
		SELECT @fromdate AS [Date]
			UNION ALL
		SELECT DATEADD(day, 1, [Date])
			FROM DateSequence
			WHERE Date < @todate
	)
	INSERT INTO dim_date
	SELECT
		[Date] AS [Date]

	FROM DateSequence OPTION (MaxRecursion 0)

END