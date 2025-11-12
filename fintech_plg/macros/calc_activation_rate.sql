{% macro calc_activation_rate(event_threshold) %}

ROUND(
  COUNT(DISTINCT CASE WHEN total_events >= {{ event_threshold }} THEN user_id END) * 100.0 /
  COUNT(DISTINCT user_id), 2
) AS activation_rate

{% endmacro %}

