# Snowflake Connection Setup Guide

## Quick Setup Steps

1. **Create the profiles.yml file:**
   ```bash
   mkdir -p ~/.dbt
   cp profiles.yml.template ~/.dbt/profiles.yml
   ```

2. **Edit the profiles.yml file:**
   ```bash
   # Use your preferred editor
   nano ~/.dbt/profiles.yml
   # or
   vim ~/.dbt/profiles.yml
   # or
   code ~/.dbt/profiles.yml  # Opens in VS Code
   ```

3. **Fill in your Snowflake credentials:**
   - Replace all `<placeholders>` with your actual values
   - See details below for finding each value

4. **Test the connection:**
   ```bash
   cd fintech_plg
   source ../venv/bin/activate  # Activate virtual environment
   dbt debug
   ```

## Finding Your Snowflake Credentials

### Account Identifier
- **Option 1:** Check the URL when logged into Snowflake
  - Format: `https://<account-identifier>.snowflakecomputing.com`
  - Example: `https://xy12345.us-east-1.snowflakecomputing.com`
  - Your account identifier is: `xy12345.us-east-1` or just `xy12345`

- **Option 2:** In Snowflake UI
  - Go to: **Account → Admin → Accounts**
  - Find your account identifier

### User & Password
- Your Snowflake username and password
- If you don't have an account, sign up for a free 30-day trial: https://signup.snowflake.com/

### Role
- Default: `ACCOUNTADMIN` (for trial accounts)
- Other common roles: `SYSADMIN`, `USERADMIN`
- Check your assigned roles in Snowflake: **Account → Users → [Your User]**

### Database
- Create a new database in Snowflake:
  ```sql
  CREATE DATABASE ANALYTICS_DEV;
  ```
- Or use an existing database name

### Warehouse
- Create a new warehouse (if needed):
  ```sql
  CREATE WAREHOUSE COMPUTE_WH
    WITH WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;
  ```
- Or use an existing warehouse name
- Trial accounts typically have `COMPUTE_WH` available

### Schema
- Default: `PUBLIC`
- Or create a custom schema:
  ```sql
  CREATE SCHEMA ANALYTICS;
  ```

## Example Complete Configuration

```yaml
fintech_plg:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: xy12345.us-east-1
      user: johndoe
      password: mySecurePassword123
      role: ACCOUNTADMIN
      database: ANALYTICS_DEV
      warehouse: COMPUTE_WH
      schema: PUBLIC
      threads: 4
      client_session_keep_alive: False
```

## Troubleshooting

### Connection Issues
- Verify all credentials are correct
- Check that your Snowflake account is active
- Ensure your IP is whitelisted (if required by your organization)
- Try using the full account identifier with region (e.g., `xy12345.us-east-1`)

### Permission Issues
- Ensure your user has the necessary permissions
- Verify the role has access to the database and warehouse
- Check that the warehouse is running (not suspended)

### Testing Connection
Run `dbt debug` to see detailed connection information and any errors.

