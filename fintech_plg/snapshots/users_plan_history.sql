{% snapshot users_plan_history %}

{{
  config(
    target_schema='snapshots',
    unique_key='user_id',

    strategy='timestamp',
    updated_at='loaded_at'
  )
}}

select
  user_id_clean as user_id,
  plan_type_clean as plan_type,
  signup_date,
  loaded_at
from {{ ref('stg_users') }}

{% endsnapshot %}
