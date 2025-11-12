WITH base AS (
  SELECT user_id, signup_date, plan_type, total_events
  FROM {{ ref('core_user_activity') }}
)

SELECT
  COUNT(DISTINCT user_id) AS total_signups,
  COUNT(DISTINCT CASE WHEN total_events >= 2 THEN user_id END) AS activated_users,
  {{ calc_activation_rate(2) }}
FROM base

