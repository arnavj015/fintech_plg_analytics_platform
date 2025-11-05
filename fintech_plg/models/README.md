# Models Directory

This directory contains all dbt models organized by layer following the dbt best practices.

## Folder Structure

### `staging/`
**Purpose:** Raw data transformations and basic cleaning
- One model per source table
- Rename columns to follow naming conventions
- Cast data types
- Add basic validations
- These models should be materialized as views (fast, always up-to-date)

**Example naming:** `stg_orders.sql`, `stg_customers.sql`

### `core/`
**Purpose:** Intermediate models that combine staging models
- Business logic and transformations
- Joins between staging models
- Calculations and aggregations
- These models can be materialized as views or tables depending on complexity

**Example naming:** `int_orders_with_customers.sql`, `int_monthly_revenue.sql`

### `marts/`
**Purpose:** Final, business-ready models for end users
- Denormalized, user-friendly models
- Ready for BI tools and dashboards
- Materialized as tables for performance
- Organized by business domain (e.g., `finance/`, `marketing/`, `sales/`)

**Example naming:** `dim_customers.sql`, `fct_orders.sql`, `revenue_by_product.sql`

## Best Practices

1. **Follow the lineage:** `staging → core → marts`
2. **Use descriptive names:** Clear, consistent naming conventions
3. **Document models:** Add descriptions in `schema.yml` files
4. **Test your models:** Add tests for data quality
5. **Materialize appropriately:** Views for speed, tables for performance

