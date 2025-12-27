-- Grain: 1 row = 1 valid transaction

SELECT
    t.transaction_id,
    {{ dbt_utils.generate_surrogate_key(['t.transaction_id', 't.user_id_clean', 't.transaction_time']) }} as txn_surrogate_key,
    t.user_id_clean as user_id,
    u.plan_type_clean AS plan_id,
    t.amount,
    DATE(t.transaction_time) AS transaction_date,
    t.transaction_time AS transaction_timestamp
FROM {{ ref('stg_transactions') }} t
INNER JOIN {{ ref('stg_users') }} u
  ON t.user_id_clean = u.user_id_clean
WHERE 
    t.is_bad_timestamp = 0
    AND t.is_duplicate_transaction = 0
    AND u.user_id_clean IS NOT NULL


