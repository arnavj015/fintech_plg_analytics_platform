WITH activity AS (
  SELECT
    user_id,
    DATE_TRUNC('week', first_event_time) AS cohort_week,
    DATE_TRUNC('week', last_event_time) AS last_active_week
  FROM {{ ref('core_user_activity') }}
)

SELECT
  cohort_week,
  COUNT(DISTINCT user_id) AS cohort_size,
  COUNT(DISTINCT CASE
    WHEN DATEDIFF('week', cohort_week, last_active_week) >= 4 THEN user_id
  END) AS retained_4w,
  ROUND(
    COUNT(DISTINCT CASE
      WHEN DATEDIFF('week', cohort_week, last_active_week) >= 4 THEN user_id
    END) * 100.0 /
    COUNT(DISTINCT user_id), 2
  ) AS retention_4w_rate
FROM activity
GROUP BY 1

