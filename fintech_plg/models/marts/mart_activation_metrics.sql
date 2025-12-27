with base as (
  select
    user_id,
    signup_date,
    first_event_time,
    total_events
  from {{ ref('core_user_activity') }}
  where first_event_time is not null
)
select
  count(distinct user_id) as total_signups,
  count(distinct case 
    when datediff('day', signup_date, first_event_time) <= 7 
     and total_events >= 2 
    then user_id 
  end) as activated_users,
  round(
    count(distinct case 
      when datediff('day', signup_date, first_event_time) <= 7 
       and total_events >= 2 
      then user_id 
    end) * 100.0 / 
    nullif(count(distinct user_id), 0), 
    2
  ) as activation_rate
from base