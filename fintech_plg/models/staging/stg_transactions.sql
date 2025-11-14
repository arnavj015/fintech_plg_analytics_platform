SELECT
    transaction_id,
    user_id,
    amount,
    timestamp
    {{ add_loaded_at() }}
FROM {{ ref('transactions') }}

