SELECT
  COUNT(DISTINCT user_id) AS paying_users,
  SUM(total_revenue) AS total_revenue,
  AVG(total_revenue) AS avg_revenue_per_user
FROM {{ ref('core_user_activity') }}

