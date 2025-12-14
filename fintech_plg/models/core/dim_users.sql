select
  user_id,
  signup_date,
  plan_type,
  NULL AS country  -- Placeholder for future country data
from {{ ref('stg_users') }}

