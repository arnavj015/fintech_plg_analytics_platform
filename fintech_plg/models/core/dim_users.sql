select
  user_id,
  signup_date,
  plan_type,
  country
from {{ ref('stg_users') }}

