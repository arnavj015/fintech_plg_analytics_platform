# GitHub Actions Workflows

## dbt.yml

This workflow automates dbt operations:

### What it does:
1. **Triggers**: Runs on pushes to `main`/`dev` and on pull requests
2. **Dependencies**: Installs Python, pip packages, and dbt packages
3. **Build**: Runs `dbt build --select state:modified` (only changed models)
4. **Docs**: Generates dbt documentation
5. **Deploy**: Publishes docs to GitHub Pages (main branch only)