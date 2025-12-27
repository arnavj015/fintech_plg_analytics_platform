# Fintech PLG Analytics Engineering Platform

## Overview

End-to-end analytics engineering project modeling user events, transactions, and subscription plan changes into reliable business metrics and dashboards. The project demonstrates production-style data modeling, historical tracking, and metric governance.

### Capabilities

- Event and transaction modeling

- Historical plan tracking with SCD Type 2 snapshots

- Time-aware revenue attribution

- Data quality testing and quarantine handling

- Cohort retention and activation metrics

- User-level feature generation for churn/LTV analysis

- Tableau Public dashboard for core KPIs

### Data Architecture

staging – cleaned canonicalized source models

snapshots – subscription plan history

core – fact and dimension tables

marts – activation, retention, revenue, user features

quarantine tables – malformed timestamps, duplicates, orphans

data reliability report – summary of pipeline issues

### Business Metrics Produced

- Activation rate

- 4-week retention

- Revenue by plan over time

- ARPU

- Paying users

- Total revenue

### Tech Stack

dbt Core

DuckDB

Python (data generation)

Tableau Public

### Dashboard

Link: https://public.tableau.com/app/profile/arnav.jain3373/viz/Book1_17668363990340/FintechPLGAnalytics



