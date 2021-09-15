
CREATE PROCEDURE [utm_report_builder]


AS
BEGIN

	DECLARE @report_end_date Date
	SET @report_end_date = CONVERT(date, GETDATE())


	-- delete data from prev run.
	DROP TABLE IF EXISTS #utm_sources
	DROP TABLE IF EXISTS #utm_base
	DROP TABLE IF EXISTS #utm_reg
	DROP TABLE IF EXISTS #utm_path
	DROP TABLE IF EXISTS #utm_purchases_agg
	TRUNCATE TABLE utm_report


	-- Init table date_dim to yesterday.
	EXEC	[date_dim_builder]
		@todate = @report_end_date


	-- Get all distinct UTM sources.
	SELECT * 
		INTO #utm_sources
		FROM (
			SELECT 
				utmSource
				  FROM 
					  users_utm
					  GROUP BY utmSource
		  ) AS sources


	-- Init UTM sources & calendar date.
	SELECT * 
		INTO #utm_base
		FROM (
			SELECT 
				dd.CalendarDate,
				us.utmSource
				   FROM 
					   dim_date dd
					   JOIN
					   #utm_sources us
			   ON 
			   1=1
			   ) AS utm_base


	-- Get number of registrations per UTM source and calendar date.
	SELECT * 
		INTO #utm_reg
		FROM (
				SELECT 
					uu.utmSource,
					CONVERT(date, u.registrationDate) AS CalendarDate,
					COUNT(u.userId) AS number_of_registrations
						FROM
							users_utm uu
							JOIN
							users u
							ON
							uu.userId = u.userId
							AND
							uu.utmDate = u.registrationDate
							GROUP BY uu.utmSource, CONVERT(date, u.registrationDate)
			   ) AS utm_reg


	-- Get per purchase the UTM path of the user.
	SELECT *
		INTO #utm_path
		FROM (
				SELECT 
					CONVERT(date, p.purchaseDate) AS CalendarDate,
					uu.utmSource,
					uu.userId,
					p.billing,
					DENSE_RANK() OVER (PARTITION BY uu.userId,p.purchaseDate ORDER BY uu.utmDate DESC) AS dr,
					COUNT(uu.userId) OVER (PARTITION BY uu.userId,p.purchaseDate) AS count_sources,
					p.purchaseDate,
					uu.utmDate
						FROM 
							users_utm uu
							JOIN
							purchases p
							ON
							uu.userId = p.userId
							AND
							uu.utmDate <= p.purchaseDate		
			) AS utm_path


	-- Implement time decay logic of purchases.
	SELECT * 
		INTO #utm_purchases_agg
		FROM (
				SELECT 
					CalendarDate, 
					utmSource,
					SUM(CASE WHEN dr = 1 THEN 1 ELSE 0 END) AS number_of_purchases, -- Purchase belong to last UTM the user encountered before purchase.
					SUM(CASE 
						--  WHEN dr = 1 AND count_sources = 1 THEN billing -- Should give 100% from purchase to last UTM if the user had only encountered one UTM.
							WHEN dr = 1 THEN (billing/2.0)
							ELSE ((billing/2.0)/(count_sources-1)) 
						  END ) AS total_billing
					FROM 
						#utm_path
						GROUP BY CalendarDate, utmSource
			   ) as utm_purchases_agg


	-- Insert into final table and handle null values.
	INSERT INTO utm_report
		SELECT 
			ub.CalendarDate,
			ub.utmSource,
			ISNULL(ur.number_of_registrations,0) AS number_of_registrations,
			ISNULL(upa.number_of_purchases,0) AS number_of_purchases,
			ISNULL(upa.total_billing,0) AS total_billing
				FROM
					#utm_base ub
					LEFT JOIN
					#utm_reg ur
					ON
					ub.CalendarDate = ur.CalendarDate
					AND
					ub.utmSource = ur.utmSource
					LEFT JOIN
					#utm_purchases_agg  upa
					ON
					upa.CalendarDate = ub.CalendarDate
					AND
					upa.utmSource = ub.utmSource



END
