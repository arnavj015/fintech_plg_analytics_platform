SELECT
    t.transaction_id,
    t.user_id,
    u.plan_type AS plan_id,
    t.amount,
    DATE(t.timestamp) AS transaction_date,
    t.timestamp AS transaction_timestamp
FROM {{ ref('stg_transactions') }} t
LEFT JOIN {{ ref('stg_users') }} u
  ON t.user_id = u.user_id

