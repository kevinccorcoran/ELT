Overview
This project is a full-stack ELT platform designed for analyzing publicly traded companies. It uses:

Apache Airflow for orchestrating and scheduling data workflows

dbt for SQL-based data modeling and transformation

Polars + Python for high-performance analytics and data engineering

It’s built for flexibility, speed, and security—while supporting robust metric calculations like Compound Annual Growth Rate (CAGR) and a custom Adjusted Momentum / Risk-Managed Score (AMRMS).

Recent Additions
💡 Fibonacci-based modeling logic and AMRMS scoring

⚡ Polars migration for faster processing and efficient PostgreSQL batch inserts

🧱 Three-tier DAG architecture: raw → cdm → metrics, with clean schema separation for environments (staging, dev)

🔐 Strong secret management using .env, GitGuardian scanning, and hardened Git history

☁️ Deployment readiness: Procfile, .python-version, and modular structure for PaaS support

👉 Architecture diagram:
https://github.com/user-attachments/assets/e19bc0ab-c8e9-4d53-9092-26bf746a78ff

Key Features
Workflow Orchestration
Modular Airflow DAGs grouped by stage (raw, cdm, metrics), with scheduler and worker support.

Data Transformation
SQL models written in dbt v1.7, using version-controlled macros.

Quantitative Analytics
Calculates CAGR, momentum scores, and other analytics; Fibonacci offset logic captures temporal performance shifts.

Project Modularity
Two repos:

ELT (this one): public code and pipelines

ELT_private: API keys, proprietary logic, and dashboards

Environment Management
.env files and Airflow Variables configure separate environments. Python version pinned to 3.11.6 via pyenv.

Security
GitGuardian pre-commit hooks flag hardcoded credentials. .gitignore and best practices protect sensitive content.