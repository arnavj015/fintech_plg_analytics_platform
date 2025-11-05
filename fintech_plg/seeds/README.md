# Seeds Directory

This directory contains CSV files that will be loaded into your data warehouse as tables.

## Usage

Seeds are useful for:
- **Reference data:** Lookup tables, mappings, configuration data
- **Small datasets:** Data that doesn't change frequently
- **Testing:** Sample data for development and testing

## How to Use

1. **Add CSV files** to this directory
2. **Run seeds:**
   ```bash
   dbt seed
   ```
3. **Reference in models:**
   ```sql
   SELECT * FROM {{ ref('seed_table_name') }}
   ```

## Best Practices

- Keep files small (< 1MB recommended)
- Use clear, descriptive filenames
- Include a header row with column names
- Document seed files in `schema.yml`
- Commit seed files to version control

## Example

```bash
# Add a CSV file: countries.csv
# Then run:
dbt seed --select countries
```

