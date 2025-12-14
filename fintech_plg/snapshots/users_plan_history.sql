{% snapshot users_plan_history %}

{{
  config(
    target_database = target.database,
    target_schema   = target.schema,
    unique_key      = 'user_id',
    strategy        = 'timestamp',
    updated_at      = 'loaded_at'
  )
}}

select
  user_id,
  signup_date,
  plan_type,
  loaded_at
from {{ ref('stg_users') }}

{% endsnapshot %}

