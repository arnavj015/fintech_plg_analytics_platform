# GitHub Actions Fixes - Troubleshooting Guide

## Issues Fixed

### 1. ✅ dbt-utils Installation Error
**Problem:** `dbt-utils` cannot be installed via pip directly.

**Solution:** 
- Created `packages.yml` file with dbt-utils package
- Removed `pip install dbt-utils` from workflows
- Now installed via `dbt deps` (which reads `packages.yml`)

### 2. ✅ Artifact Download Error
**Problem:** First run fails because no previous artifact exists.

**Solution:**
- Added `continue-on-error: true` to artifact download step
- Workflow continues even if artifact doesn't exist (first run)

### 3. ⚠️ Missing GitHub Secrets
**Problem:** Credentials are `None` because secrets aren't set up.

**Solution Required:** You need to add GitHub Secrets!

---

## Required: Set Up GitHub Secrets

The workflows need these secrets to connect to Snowflake. **You must add them in GitHub:**

### Steps to Add Secrets:

1. Go to your repository: https://github.com/arnavj015/fintech_plg_analytics_platform
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **"New repository secret"**
4. Add each of these 7 secrets:

| Secret Name | Value (from your profiles.yml) |
|-------------|--------------------------------|
| `SNOWFLAKE_ACCOUNT` | `CHZFKAX-XOB43010` |
| `SNOWFLAKE_USER` | `arnavj015` |
| `SNOWFLAKE_PASSWORD` | `9qhMM2ZYJvQsrmw` |
| `SNOWFLAKE_ROLE` | `ACCOUNTADMIN` |
| `SNOWFLAKE_DATABASE` | `FINTECH_DEV` |
| `SNOWFLAKE_WAREHOUSE` | `COMPUTE_WH` |
| `SNOWFLAKE_SCHEMA` | `PUBLIC` |

### After Adding Secrets:

1. The workflows will automatically use them
2. Tests should pass on the next PR/push
3. You can verify by checking the workflow logs

---

## What Was Fixed

### Files Changed:

1. **Created `packages.yml`**
   - Added dbt-utils package
   - Now installed via `dbt deps`

2. **Updated `.github/workflows/dbt-ci.yml`**
   - Removed `pip install dbt-utils`
   - Now uses `dbt deps` to install packages

3. **Updated `.github/workflows/dbt.yml`**
   - Added `continue-on-error: true` to artifact download
   - Prevents failure on first run

---

## Testing the Fix

After adding secrets, the workflows should:
- ✅ Install dbt-utils via packages.yml
- ✅ Continue even if artifact doesn't exist
- ✅ Connect to Snowflake using secrets
- ✅ Run dbt commands successfully

---

## Next Steps

1. **Add GitHub Secrets** (required!)
2. **Push the fixes** to trigger new workflow run
3. **Check workflow status** in GitHub Actions tab
4. **Verify tests pass** before merging

---

## Troubleshooting

If tests still fail after adding secrets:

1. **Check secret names** - Must match exactly (case-sensitive)
2. **Check secret values** - No extra spaces or characters
3. **Check workflow logs** - Look for specific error messages
4. **Verify Snowflake access** - Ensure credentials are correct

---

**The main issue is missing GitHub Secrets. Once you add them, the workflows should work!**

