SELECT
  user_id
FROM {{ ref('core_user_activity') }}
WHERE total_events = 0
  AND DATEDIFF('day', signup_date, CURRENT_DATE) > 7

