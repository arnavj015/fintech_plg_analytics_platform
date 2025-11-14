WITH user_events AS (
  SELECT
    e.user_id,
    COUNT(DISTINCT e.event_type) AS total_events,
    MIN(e.event_time) AS first_event_time,
    MAX(e.event_time) AS last_event_time
  FROM {{ ref('stg_events') }} e
  GROUP BY 1
),

user_txns AS (
  SELECT
    t.user_id,
    COUNT(DISTINCT t.transaction_id) AS txn_count,
    SUM(t.amount) AS total_revenue
  FROM {{ ref('stg_transactions') }} t
  GROUP BY 1
)

SELECT
  u.user_id,
  u.signup_date,
  u.plan_type,
  ue.total_events,
  ue.first_event_time,
  ue.last_event_time,
  ut.txn_count,
  ut.total_revenue
FROM {{ ref('stg_users') }} u
LEFT JOIN user_events ue ON u.user_id = ue.user_id
LEFT JOIN user_txns ut ON u.user_id = ut.user_id

