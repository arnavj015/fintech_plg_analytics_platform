with joined as (
  select
    t.transaction_id,
    t.user_id_clean as txn_user_id,
    u.user_id_clean as matched_user_id
  from {{ ref('stg_transactions') }} t
  left join {{ ref('stg_users') }} u
    on t.user_id_clean = u.user_id_clean
),

agg as (
  select
    count(*) as total_txns,
    sum(case when matched_user_id is null then 1 else 0 end) as unmatched_txns
  from joined
),

final as (
  select
    total_txns,
    unmatched_txns,
    1.0 * unmatched_txns / nullif(total_txns, 0) as unmatched_rate
  from agg
)


select *
from final
where unmatched_rate > 0.005
