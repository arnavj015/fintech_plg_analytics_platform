# Fintech PLG Analytics Platform

A full analytics-engineering environment built with dbt and Snowflake.

## 🎯 Project Overview

This project implements a production-grade analytics engineering workflow using:
- **dbt** for data transformation
- **Snowflake** as the data warehouse
- **Git** for version control and collaboration

## 📋 Prerequisites

- Python 3.8+
- Snowflake account (free 30-day trial available)
- Git

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd fintech_plg_analytics_platform
```

### 2. Create Virtual Environment

```bash
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Snowflake Connection

Create or edit the dbt profiles file at `~/.dbt/profiles.yml`:

```yaml
fintech_plg:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your-account-identifier>
      user: <your-username>
      password: <your-password>
      role: <your-role>  # Optional, defaults to ACCOUNTADMIN
      database: <your-database>
      warehouse: <your-warehouse>
      schema: <your-schema>
      threads: 4
      client_session_keep_alive: False
```

**To find your Snowflake account identifier:**
- Log into Snowflake
- Check the URL: `https://<account-identifier>.snowflakecomputing.com`
- Or check under Account → Admin → Accounts

### 5. Test Connection

```bash
cd fintech_plg
dbt debug
```

This will verify your connection to Snowflake.

### 6. Run Your First Models

```bash
dbt run
```

## 📁 Project Structure

```
fintech_plg/
├── models/          # dbt models (SQL transformations)
│   └── example/     # Example models
├── tests/           # Custom tests
├── macros/          # Reusable SQL macros
├── seeds/           # CSV files to load
├── snapshots/       # Snapshot models
├── analyses/        # Ad-hoc analyses
└── dbt_project.yml  # Project configuration
```

## 🔧 Development Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Develop your models**
   - Add SQL models in `models/`
   - Write tests in `tests/` or schema.yml files
   - Document your models

3. **Test locally**
   ```bash
   dbt run
   dbt test
   ```

4. **Commit and push**
   ```bash
   git add .
   git commit -m "Add: description of changes"
   git push origin feature/your-feature-name
   ```

5. **Create a Pull Request**
   - Open a PR on GitHub
   - Get code review
   - Merge to main after approval

## 📚 Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [Snowflake Documentation](https://docs.snowflake.com/)
- [dbt Community](https://community.getdbt.com/)

## 🎓 Week 1 Goals

- ✅ Build full analytics-engineering environment
- ✅ Adopt production-grade workflow (Git, branches, pull requests, testing)
- ✅ Produce first working dbt → Snowflake pipeline

---

**Next Steps:** Configure your Snowflake connection and run `dbt debug` to verify setup!

