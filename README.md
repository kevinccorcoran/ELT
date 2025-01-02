<<<<<<< HEAD
# ELT
=======
## Overview
This project establishes an Extract, Load, and Transform (ELT) data pipeline with Apache Airflow and dbt (Data Build Tool). The pipeline orchestrates workflows to calculate metrics, such as the Compound Annual Growth Rate (CAGR) for companies, while maintaining a clear separation between public code, sensitive configurations, and proprietary intellectual property within the metrics tables.

<img width="1221" alt="image" src="https://github.com/user-attachments/assets/e19bc0ab-c8e9-4d53-9092-26bf746a78ff">


## Features
- **Data Orchestration with Airflow**: Schedule and manage complex workflows.
- **Data Transformation with dbt**: Utilize SQL-based transformations and data modeling.
- **Modular Codebase**: Separate repositories (ELT for public code and ELT_private for sensitive code) to maintain security and collaboration.
- **Environment Management**: Use environment variables and .env files to configure different environments (e.g., dev, staging).

## Project Structure
├── dags/ # Airflow DAG definitions
├── dbt/ # dbt project files
│ ├── models/ # dbt models
│ ├── seeds/ # Seed data
│ └── ... # Other dbt directories (snapshots, macros, etc.)
├── scripts/ # Helper scripts and utilities
├── Python/ # ETL scripts
├── .gitignore # Git ignore file
├── requirements.txt # Python dependencies
└── README.md # Project documentation

## Getting Started

### Prerequisites
- Python 3.11.6
- Apache Airflow
- dbt (Data Build Tool) v1.7.0
- PostgreSQL
- Git
- **APIs**: `yfinance` and `Polygon.io` for data ingestion of financial and stock market information
- **Python Libraries**:
  - pandas
  - PySpark
  - Plotly
- **Optional Tools**:
  - Google Colab

### Installation

#### Clone the Repository:
git clone https://github.com/yourusername/ELT.git  
cd ELT

#### Set Up Virtual Environment:
python -m venv venv  
source venv/bin/activate

#### Install Dependencies:
pip install -r requirements.txt

#### Configure Environment Variables:
1. Create a `.env` file in the project root (ensure it's listed in `.gitignore`):  
   touch .env

2. Add your environment-specific variables to `.env`:
   ```dotenv
   ENV=dev  
   DB_HOST=localhost  
   DB_PORT=your_db_port  
   DB_USER=your_db_user  
   DB_PASSWORD=your_db_password  
   DB_NAME=your_db_name


## Initialize Airflow:
airflow db init

## Set Up Airflow Variables and Connections:
Configure variables and connections in the Airflow UI or via CLI to match your environment.

## Set Up dbt Profiles:
Configure your `~/.dbt/profiles.yml` to include the `dev` environment pointing to your database:

```yaml
default:  
  outputs:  
    dev:  
      type: postgres  
      host: localhost  
      user: your_db_user  
      password: your_db_password  
      port: your_port  
      dbname: dev  
      schema: public  
  target: dev

## Usage

### Start Airflow Services:
airflow scheduler &  
airflow webserver -p 8080

### Access Airflow UI:
Navigate to [http://localhost:8080](http://localhost:8080) in your web browser.

### Trigger DAGs:
- Manually trigger DAGs via the Airflow UI.
- Schedule DAGs as needed.

### Run dbt Models:
Navigate to your dbt project directory and run:
```bash
cd dbt  
dbt run --models company_cagr

## Troubleshooting
- **Database Connection Errors**: Ensure the database specified in your environment variables exists and is accessible.
- **Missing .env Variables**: Double-check that all required variables are set in your `.env` file.
- **Git Tracking Issues**: If sensitive files like `.env` are appearing in your GitHub repository, ensure they're listed in `.gitignore` and removed from tracking.

## Contributing

### Fork the Repository

#### Create a Feature Branch:
git checkout -b feature/your-feature-name

#### Commit Your Changes:
git commit -am 'Add new feature'

#### Push to the Branch:
git push origin feature/your-feature-name

#### Open a Pull Request

## Security and Privacy
- **Sensitive Information**: Keep all sensitive data and configurations in the `ELT_private` repository.
- **.gitignore**: Ensure files like `.env` are included to prevent accidental commits of sensitive information.
- **Branch Management**: Regularly check branches in the public repository to ensure no private code is exposed.

## License
This project is licensed under the MIT License.

## Contact
For questions or collaboration:
- **Name**: Kevin Corcoran
- **Email**: kevin.corcoran@hotmail.com
- **GitHub**: [kevinccorcoran](https://github.com/kevinccorcoran)
>>>>>>> elt_source/spike/heroku_dag_refactoring
