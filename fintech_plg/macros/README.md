# Macros Directory

This directory contains reusable SQL macros (Jinja functions) that can be used across your dbt project.

## Usage

Macros are useful for:
- **Reusable SQL patterns:** Common transformations, calculations
- **Dynamic SQL:** Conditional logic, loops
- **Standardization:** Consistent business logic across models

## How to Use

1. **Create a macro file** (e.g., `my_macro.sql`)
2. **Define the macro:**
   ```sql
   {% macro my_macro(column_name) %}
     CASE 
       WHEN {{ column_name }} > 100 THEN 'high'
       ELSE 'low'
     END
   {% endmacro %}
   ```
3. **Use in models:**
   ```sql
   SELECT 
     {{ my_macro('order_total') }} as order_category
   FROM orders
   ```

## Best Practices

- Use descriptive macro names
- Document macro parameters and usage
- Keep macros focused and single-purpose
- Test macros thoroughly
- Use dbt's built-in macros as reference (e.g., `dbt_utils` package)

## Common Patterns

- **Date formatting:** `{{ format_date('created_at') }}`
- **Currency conversion:** `{{ convert_currency(amount, 'USD', 'EUR') }}`
- **Data quality checks:** `{{ assert_not_null('customer_id') }}`

