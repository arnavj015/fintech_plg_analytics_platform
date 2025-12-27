SELECT
  COUNT(DISTINCT CASE WHEN total_revenue > 0 THEN user_id END) AS paying_users,
  SUM(COALESCE(total_revenue, 0)) AS total_revenue,
  AVG(CASE WHEN total_revenue > 0 THEN total_revenue END) AS avg_revenue_per_user
FROM {{ ref('core_user_activity') }}

