.mode csv
.headers on

.output exports/mart_revenue_by_plan.csv
SELECT * FROM mart_revenue_by_plan;

.output exports/mart_revenue_metrics.csv
SELECT * FROM mart_revenue_metrics;

.output exports/mart_activation_metrics.csv
SELECT * FROM mart_activation_metrics;

.output exports/mart_retention_metrics.csv
SELECT * FROM mart_retention_metrics;

.output exports/data_reliability_report.csv
SELECT * FROM data_reliability_report;

.quit
