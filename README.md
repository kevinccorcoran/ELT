# ELT Platform for Public-Company Analytics

A full-stack ELT platform that  

* **pulls data** from APIs and third-party sources  
* **transforms** it with dbt and Python/Polars  
* **deploys** cleanly in both local and production environments  

Delivers metrics such as **Compound Annual Growth Rate (CAGR)** and a custom **Adjusted Momentum / Risk-Managed Score (AMRMS)**.

---

## Tech Stack

| Layer | Tooling | Purpose |
|-------|---------|---------|
| **Orchestration** | **Apache Airflow** | Schedule & monitor DAGs |
| **Modeling** | **dbt v1.7** | SQL-based transformations |
| **Analytics** | **Polars + Python** | High-performance data engineering |
| **Storage** | **PostgreSQL** | Raw, CDM, Metrics schemas |

---

## Recent Additions

* 💡 **Fibonacci-based modeling** & AMRMS scoring  
* ⚡ **Polars migration** → faster processing, efficient batch inserts  
* 🧱 **Three-tier DAGs** `raw → cdm → metrics` with env-specific schemas  
* 🔐 **Secret management**: `.env`, GitGuardian pre-commit scanning  
* ☁️ **PaaS-ready**: `Procfile`, `.python-version`, modular folder layout  

> **Environment Diagram →**  
<img width="1204" alt="image" src="https://github.com/user-attachments/assets/87f6ee3b-d73d-4b05-b2c0-057dedd18520" />

> **Data Pipeline →** 
<img width="1299" alt="image" src="https://github.com/user-attachments/assets/1e1db2b8-088d-45f2-89c1-0874e2270ca5" />

> **Local-to-Heroku Deployment Workflow →** 
<img width="1111" alt="image" src="https://github.com/user-attachments/assets/8c2ce78b-5ef8-4b53-ad1a-15287a1ba45d" />

---

## Key Features

### Workflow Orchestration
* Modular Airflow DAGs grouped by stage (`raw`, `cdm`, `metrics`)
* Separate scheduler & worker setup

### Data Transformation
* Version-controlled dbt models & macros
* Clear raw/CDM/metrics schema separation

### Quantitative Analytics
* CAGR, momentum scores, Fibonacci offset logic for temporal shifts
* Custom AMRMS metric

### Project Modularity
* **`ELT`** (this repo) – public code & pipelines  
* **`ELT_private`** – API keys, proprietary logic, dashboards

### Environment Management
* `.env` files + Airflow Variables for per-env configs  
* Python 3.11.6 pinned via `pyenv`

### Security
* GitGuardian hooks to block hard-coded secrets  
* `.gitignore` tuned for sensitive artifacts

---

## Getting Started (quick local run)

```bash
# 1. Clone and enter repo
git clone https://github.com/kevinccorcoran/ELT.git
cd ELT

# 2. Create & activate venv
python3.11 -m venv .venv
source .venv/bin/activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Initialize Airflow (SQLite meta DB for dev)
airflow db init
airflow webserver &
airflow scheduler &
