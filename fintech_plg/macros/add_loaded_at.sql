{% macro add_loaded_at(column_name='loaded_at') %}
  , CURRENT_TIMESTAMP AS {{ column_name }}
{% endmacro %}

