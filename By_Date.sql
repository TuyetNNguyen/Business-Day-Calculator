CREATE TEMP FUNCTION COUNT_WEEKDAYS_OLD (
  StartDate DATE,
  EndDate DATE
  RETURNS INT64 AS (
    (DATE_DIFF(StartDate, EndDate, DAY) +1)
    -(DATE_DIFF(StartDate, EndDate, WEEK) *2)
    -(CASE WHEN ((FORMAT_DATE("%w", StartDate) = "0") OR (FORMAT_DATE("%w", EndDate) = "0")) THEN 1 ELSE 0 END)
    -(CASE WHEN ((FORMAT_DATE("%w", StartDate) = "6") OR (FORMAT_DATE("%w", EndDate) = "6")) THEN 1 ELSE 0 END)
 );
 
 #expected days could be different depends on current_date() if it's weekend or weekday.Assuming today is Saturday
 WITH dates_table AS (
  SELECT CURRENT_DATE() AS start_date, CURRENT_DATE() AS end_date, '0 days' AS expected result
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY), '1 days'
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 2 DAY), '2 days'
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY), '3 days'
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 4 DAY), '4 days'
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 5 DAY), '5 days'
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 6 DAY), '5 days'
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY), '5 days'
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 8 DAY), '6 days'
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 9 DAY), '7 days'
  UNION ALL SELECT CURRENT_DATE(), DATE_SUB(CURRENT_DATE(), INTERVAL 10 DAY), '8 days'
)

SELECT
  start_date,
  end_date,
  COUNT_WEEKDAYS(start_date, end_date) AS num_week_days,
  expected_result
FROM
  dates_table
