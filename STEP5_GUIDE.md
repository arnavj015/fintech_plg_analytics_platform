# Step 5: dbt Docs & GitHub Actions - Complete Guide

## 📚 What We Did

### 1. Generated dbt Documentation

**Command:** `dbt docs generate`

**What it creates:**
- `target/manifest.json` - Complete project metadata (models, tests, seeds, etc.)
- `target/catalog.json` - Database schema information
- `target/index.html` - Interactive documentation website

**What you get:**
- **Lineage Graph**: Visual representation of data flow between models
- **Model Documentation**: All your models, columns, tests, and descriptions
- **Test Results**: See which tests pass/fail
- **Column Details**: Data types, descriptions, and test coverage

**How to view locally:**
```bash
cd fintech_plg
source ../venv/bin/activate
dbt docs serve
# Opens in browser at http://localhost:8080
```

---

### 2. Created GitHub Actions Workflow

**File:** `.github/workflows/dbt.yml`

**What it does:**

#### Trigger Events:
- **Push to `main` or `dev` branches** → Runs CI/CD
- **Pull Request to `main`** → Runs tests before merge

#### Workflow Steps:

1. **Checkout Code**
   - Gets your code from GitHub
   - `fetch-depth: 0` = Gets full history (needed for `state:modified`)

2. **Set up Python**
   - Installs Python 3.11
   - Prepares environment

3. **Install Dependencies**
   - Upgrades pip
   - Installs packages from `requirements.txt` (dbt-snowflake)

4. **Install dbt Dependencies**
   - Runs `dbt deps`
   - Installs dbt packages (if you have `packages.yml`)

5. **Run dbt Build (Modified Only)**
   - **Key Feature:** `dbt build --select state:modified`
   - Only runs models that changed since last run
   - Saves time by skipping unchanged models
   - Falls back to running all models if state comparison fails

6. **Generate dbt Docs**
   - Runs `dbt docs generate`
   - Creates fresh documentation

7. **Deploy to GitHub Pages**
   - Only runs on `main` branch
   - Publishes docs to GitHub Pages
   - Makes docs accessible via web URL

---

### 3. Understanding `state:modified`

**What is it?**
- dbt's "state" feature compares your current code with a previous run
- Identifies which models, tests, seeds changed
- Only runs/test what changed

**How it works:**
1. Previous run's `manifest.json` is stored (via artifact upload)
2. Current run compares with previous state
3. Only modified models are selected
4. Dependencies are automatically included

**Benefits:**
- ⚡ **Faster CI/CD**: Skip unchanged models
- 💰 **Cost Savings**: Fewer Snowflake queries
- 🎯 **Focused Testing**: Only test what changed

**Example:**
```
If you change stg_users.sql:
- ✅ Runs: stg_users (modified)
- ✅ Runs: models that depend on stg_users
- ❌ Skips: All other unchanged models
```

---

### 4. GitHub Pages Setup

**What is GitHub Pages?**
- Free hosting for static websites
- Automatically serves your dbt docs
- Accessible at: `https://<username>.github.io/<repo-name>/`

**How it works:**
1. Workflow runs on `main` branch
2. Generates dbt docs in `target/` directory
3. `peaceiris/actions-gh-pages` action deploys to GitHub Pages
4. Docs become publicly accessible

**To enable GitHub Pages:**
1. Go to repository Settings → Pages
2. Source: GitHub Actions (automatic)
3. Workflow will deploy automatically

---

## 🚀 Next Steps: Push & Create PR

### Step 1: Push dev branch to GitHub

```bash
# Make sure you're on dev branch
git checkout dev

# Push to GitHub (first time)
git push -u origin dev

# Or if already pushed before
git push origin dev
```

### Step 2: Create Pull Request

1. **Go to GitHub.com** → Your repository
2. **Click "Pull requests"** → "New pull request"
3. **Base:** `main` ← **Target branch**
4. **Compare:** `dev` ← **Your feature branch**
5. **Add title:** "Week 1: Add dbt models, docs, and CI/CD"
6. **Add description:**
   ```
   - ✅ Created first staging model (stg_users)
   - ✅ Added data quality tests
   - ✅ Generated dbt documentation
   - ✅ Set up GitHub Actions CI/CD
   - ✅ Configured GitHub Pages deployment
   ```
7. **Click "Create pull request"**

### Step 3: GitHub Actions Will Run

Once PR is created:
- ✅ GitHub Actions workflow automatically triggers
- ✅ Runs `dbt deps`
- ✅ Runs `dbt build --select state:modified`
- ✅ Generates docs
- ✅ Shows results in PR checks

### Step 4: Merge to Main

1. **Review the PR** - Check that all checks pass
2. **Merge the PR** - Click "Merge pull request"
3. **Docs deploy** - GitHub Pages automatically updates
4. **Access docs** - Visit your GitHub Pages URL

---

## 🔐 Required GitHub Secrets

Before the workflow works, you need to set up secrets:

1. Go to **Repository Settings** → **Secrets and variables** → **Actions**
2. Click **"New repository secret"**
3. Add each of these:

| Secret Name | Value | Example |
|------------|-------|---------|
| `SNOWFLAKE_ACCOUNT` | Your account ID | `CHZFKAX-XOB43010` |
| `SNOWFLAKE_USER` | Your username | `arnavj015` |
| `SNOWFLAKE_PASSWORD` | Your password | `your_password` |
| `SNOWFLAKE_ROLE` | Your role | `ACCOUNTADMIN` |
| `SNOWFLAKE_DATABASE` | Database name | `FINTECH_DEV` |
| `SNOWFLAKE_WAREHOUSE` | Warehouse name | `COMPUTE_WH` |
| `SNOWFLAKE_SCHEMA` | Schema name | `PUBLIC` |

**Important:** Secrets are encrypted and never visible in logs!

---

## 📊 What Happens in the Workflow

### On Pull Request:
```
1. Checkout code
2. Install Python & dependencies
3. Run dbt deps
4. Download previous state (if available)
5. Run dbt build --select state:modified
   → Only runs changed models!
6. Generate docs
7. Upload state artifact (for next run)
```

### On Merge to Main:
```
1-6. Same as above
7. Deploy docs to GitHub Pages ✅
   → Your docs are now live!
```

---

## ✅ Summary

**What we accomplished:**
- ✅ Generated interactive dbt documentation
- ✅ Created automated CI/CD pipeline
- ✅ Set up incremental builds (state:modified)
- ✅ Configured GitHub Pages deployment
- ✅ Committed all changes to dev branch

**Next actions:**
1. Push `dev` branch to GitHub
2. Create Pull Request
3. Set up GitHub Secrets
4. Merge PR to trigger docs deployment
5. Access your live documentation!

---

## 🎓 Key Concepts Learned

1. **dbt Docs**: Interactive documentation with lineage graphs
2. **GitHub Actions**: Automate your workflow
3. **State:Modified**: Run only what changed
4. **GitHub Pages**: Free hosting for docs
5. **CI/CD**: Continuous integration and deployment

Your analytics engineering workflow is now production-ready! 🚀

