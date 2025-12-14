select
  {{ dbt_utils.generate_surrogate_key(['user_id', 'event_type', 'event_time']) }} as event_id,
  e.user_id,
  e.event_type,
  e.event_time::date as event_date,
  coalesce(t.amount, 0) as amount
from {{ ref('stg_events') }} e
left join {{ ref('stg_transactions') }} t
  on e.user_id = t.user_id
 and e.event_time::date = t.timestamp::date
 and e.event_type = 'transaction'

