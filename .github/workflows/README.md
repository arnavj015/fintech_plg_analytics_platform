# GitHub Actions Workflows

## dbt.yml

This workflow automates dbt operations:

### What it does:
1. **Triggers**: Runs on pushes to `main`/`dev` and on pull requests
2. **Dependencies**: Installs Python, pip packages, and dbt packages
3. **Build**: Runs `dbt build --select state:modified` (only changed models)
4. **Docs**: Generates dbt documentation
5. **Deploy**: Publishes docs to GitHub Pages (main branch only)

### Required GitHub Secrets:
Set these in your repository settings (Settings → Secrets and variables → Actions):

- `SNOWFLAKE_ACCOUNT` - Your Snowflake account identifier
- `SNOWFLAKE_USER` - Your Snowflake username
- `SNOWFLAKE_PASSWORD` - Your Snowflake password
- `SNOWFLAKE_ROLE` - Your Snowflake role (e.g., ACCOUNTADMIN)
- `SNOWFLAKE_DATABASE` - Your database name
- `SNOWFLAKE_WAREHOUSE` - Your warehouse name
- `SNOWFLAKE_SCHEMA` - Your schema name (e.g., PUBLIC)

### State:Modified Feature:
- `state:modified` only runs models that changed since the last run
- Compares current code with previous state
- Speeds up CI/CD by skipping unchanged models
- Falls back to running all models if state comparison fails

### GitHub Pages:
- Docs are automatically deployed when pushing to `main`
- Accessible at: `https://<username>.github.io/<repo-name>/`
- Only deploys from main branch for stability

