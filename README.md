# Banking Fraud Detection & Financial Risk Analytics

**End-to-end data analytics and machine learning project** using SQL, Python, scikit-learn, Power BI and DAX to explore synthetic financial transactions, investigate fraud patterns, and evaluate a classification model.

> **Dataset note:** This project uses the synthetic PaySim mobile-money transaction dataset. It is not real customer or bank data. The `step` field is a simulation time index, not a calendar date, and the dataset does not specify a currency.

## Project at a glance

| Item | Details |
|---|---|
| Dataset size | 6,362,620 transactions |
| Fraud-labelled records | 8,213 (approximately 0.1291%) |
| Non-fraud records | 6,354,407 |
| Transaction types | CASH_IN, CASH_OUT, DEBIT, PAYMENT, TRANSFER |
| SQL | Transaction summaries, fraud rates, amount bands, system flags and balance consistency checks |
| Python | Chunk-based inspection, validation, exploratory analysis and feature preparation |
| Machine learning | Logistic Regression classification pipeline |
| BI | Three-page Power BI report with DAX measures |

## Business problem

Fraud-labelled transactions are rare compared with legitimate transactions. The project explores how transaction type, amount and account-balance information relate to fraud labels, then evaluates a baseline model for identifying potentially fraudulent transactions. The aim is analytical investigation and model evaluation—not deployment of a live banking fraud-monitoring system.

## Objectives

- Profile a large transaction dataset and validate data quality.
- Quantify class imbalance and compare fraud rates across transaction types.
- Investigate transaction amounts, system-flagged records and account-balance changes.
- Build and evaluate a Logistic Regression fraud-classification baseline.
- Communicate findings through an interactive Power BI dashboard.

## Technology stack

- **SQL:** Aggregations, `CASE`, grouping, subqueries and transaction-risk summaries.
- **Python:** Data processing and exploratory analysis.
- **NumPy / Pandas:** Numerical operations, chunk-based loading, cleaning and aggregation.
- **Matplotlib / Seaborn:** Exploratory visualizations.
- **Scikit-learn:** Preprocessing pipeline, Logistic Regression and classification metrics.
- **Power BI / DAX:** KPI measures, interactive visuals, slicers and report navigation.

## Workflow

1. **Data inspection and validation** — inspect schema, missing values, duplicates, labels, amounts, simulation steps and balances. Large-file checks use chunked Pandas processing.
2. **SQL analysis** — summarize transaction volumes, fraud rates, amount ranges, system flags and balance mismatches.
3. **Exploratory data analysis** — analyze fraud distribution and transaction patterns using Python.
4. **Machine learning** — split the data chronologically using the simulation `step`, sample only the training period, preprocess numeric and categorical features, and train Logistic Regression.
5. **Evaluation** — assess predictions on the later, untouched test period using precision, recall, F1-score, Average Precision, ROC-AUC and a confusion matrix.
6. **Reporting** — present executive metrics, fraud patterns and model evaluation in Power BI.

## Key analytical findings

- Fraud-labelled transactions account for approximately **0.1291%** of all records, so the target is highly imbalanced.
- Fraud labels occur in **TRANSFER** and **CASH_OUT** transactions in this dataset.
- The dataset's original `isFlaggedFraud` indicator flags only **16** records, illustrating the difference between the provided system flag and the `isFraud` label.
- Balance-change consistency checks are used as investigation signals; a mismatch should not automatically be interpreted as fraud.

## Machine learning methodology

The notebook builds a scikit-learn pipeline with:
- Numeric features: `step`, `amount`, `oldbalanceOrg`, `oldbalanceDest`.
- Categorical feature: `type`.
- Numeric preprocessing: median imputation and standardization.
- Categorical preprocessing: most-frequent imputation and one-hot encoding.
- Classifier: Logistic Regression with class weighting.

The split is time-based: the earlier portion is used for training and the later portion for testing. Training data is downsampled while the test period retains its original class distribution. The test period is not used to fit preprocessing or the model.

### Reported test performance

| Metric | Result |
|---|---:|
| Test transactions | 1,293,523 |
| Actual fraud cases | 4,258 |
| Precision | 4.76% |
| Recall | 78.96% |
| F1-score | 8.98% |
| ROC-AUC | 0.962 |
| Average Precision | 0.3168 |

**Interpretation:** The reported recall indicates that the model detects a substantial share of fraud-labelled test cases. Precision is low, meaning many transactions predicted as fraud are false positives and would require review. These results are a baseline on a synthetic dataset, not evidence of production readiness. Threshold selection and validation should be handled using validation data separate from the final test set.

## Power BI dashboard

The report contains three pages. Screenshots below are included for a quick preview; the editable `.pbix` report is not included in this repository package yet.

### 1. Executive Overview

![Executive Overview](Screenshots/Executive_Overview.png)

### 2. Fraud Analysis & Investigation

![Fraud Analysis](Screenshots/Fraud_Analysis.png)

### 3. Risk & ML Performance

![Risk and ML Performance](Screenshots/Risk_ML_Performance.png)

## Repository structure

```text
Banking-Fraud-Detection-Financial-Risk-Analytics/
├── README.md
├── Dataset/
│   └── README.md
├── SQL/
│   └── Banking_Fraud_Analytics.sql
├── Python/
│   ├── initial_inspection.ipynb
│   └── Machine_Learning.ipynb
├── ML_Outputs/
│   └── README.md
├── PowerBI/
│   └── README.md
├── Screenshots/
│   ├── Executive_Overview.png
│   ├── Fraud_Analysis.png
│   └── Risk_ML_Performance.png
└── docs/
    └── README.md
```

## Running the notebooks

1. Download the dataset from its original source and note its license/terms.
2. Place the CSV in a local `Dataset/` or `Raw_Data/` folder.
3. Update the `DATA_PATH` or `file_path` variables in the notebooks to match your local path.
4. Install the required Python packages:

```bash
pip install pandas numpy matplotlib seaborn scikit-learn joblib jupyter
```

5. Run `initial_inspection.ipynb` first, then `Machine_Learning.ipynb`.

The notebooks currently contain local Windows file paths; update these before running on another machine. The SQL script expects a table named `banking_transactions_full` with the columns used in its queries, including `origin_balance_change` and `destination_balance_change`. Create/load that table and derived columns before running the SQL script.

## Dataset and large-file handling

The original CSV contains more than 6.3 million rows and is intentionally not bundled here. Avoid committing the full raw CSV or generated large prediction files directly to Git. Instead:
- Include a `Dataset/README.md` with the dataset name, source URL, license/terms and download instructions.
- Keep only small, useful, reproducible outputs in Git.
- Use Git LFS for files that genuinely need versioning and are within Git LFS limits/quotas, or link to an appropriate external storage location.
- Do not publish private account identifiers, credentials, or sensitive data.

## Limitations

- PaySim is synthetic and may not represent all real-world banking behaviour.
- The dataset's currency is unspecified.
- `step` represents simulated time, not a real date/time.
- High recall with low precision creates many false-positive alerts.
- Logistic Regression is a baseline model; further validation, threshold tuning, comparison with other models and operational testing would be needed before any real-world use.

## Author

**Swathi Ponugoti**  
Aspiring Data Analyst | SQL | Python | Machine Learning | Power BI  
[LinkedIn](https://www.linkedin.com/in/swathi-ponugoti-4763ba2bb/) · [GitHub](https://github.com/Swathiponugoti13)
