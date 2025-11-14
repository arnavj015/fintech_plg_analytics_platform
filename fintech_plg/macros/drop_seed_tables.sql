{% macro drop_seed_tables(schema, database) %}
  {% set drop_seeds_sql %}
    DROP TABLE IF EXISTS {{ adapter.quote(database) }}.{{ adapter.quote(schema) }}.EVENTS;
    DROP TABLE IF EXISTS {{ adapter.quote(database) }}.{{ adapter.quote(schema) }}.TRANSACTIONS;
    DROP TABLE IF EXISTS {{ adapter.quote(database) }}.{{ adapter.quote(schema) }}.USERS;
  {% endset %}
  
  {% set results = run_query(drop_seeds_sql) %}
  {% do log("Dropped seed tables if they existed", info=True) %}
{% endmacro %}

