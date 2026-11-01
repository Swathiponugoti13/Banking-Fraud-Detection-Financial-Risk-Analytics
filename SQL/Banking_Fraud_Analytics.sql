--Banking Fraud Analytics
SELECT
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    COUNT(*) - SUM(isFraud) AS non_fraud_transactions,
    ROUND(AVG(isFraud) * 100, 4) AS fraud_rate_pct
FROM banking_transactions_full;


--Fraud analysis by transaction type
SELECT
    type AS transaction_type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(100 * AVG(isFraud), 4) AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END),2) AS fraud_labelled_amount
FROM banking_transactions_full
GROUP BY type
ORDER BY fraud_rate_pct DESC;


--Fraud rate by transaction amount range
SELECT
    CASE
        WHEN amount < 10000 THEN '1. Below 10K'
        WHEN amount < 100000 THEN '2. 10K to 100K'
        WHEN amount < 1000000 THEN '3. 100K to 1M'
        ELSE '4. 1M and Above'
    END AS amount_range,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(AVG(isFraud) * 100, 4) AS fraud_rate_pct
FROM banking_transactions_full
GROUP BY
    CASE
        WHEN amount < 10000 THEN '1. Below 10K'
        WHEN amount < 100000 THEN '2. 10K to 100K'
        WHEN amount < 1000000 THEN '3. 100K to 1M'
        ELSE '4. 1M and Above'
    END
ORDER BY amount_range;


--Fraud amount and average transaction amount
SELECT isFraud AS fraud_label,
    COUNT(*) AS total_transactions,
    ROUND(AVG(amount), 2) AS avg_transaction_amount,
    ROUND(MIN(amount), 2) AS min_transaction_amount,
    ROUND(MAX(amount), 2) AS max_transaction_amount,
    ROUND(SUM(amount), 2) AS total_transaction_amount
FROM banking_transactions_full
GROUP BY isFraud
ORDER BY isFraud DESC;


--System fraud-flag detection performance
SELECT
    COUNT(*) AS total_fraud_transactions,
    SUM(isFlaggedFraud) AS system_flagged_transactions,
    COUNT(*) - SUM(isFlaggedFraud) AS not_system_flagged,
    ROUND(100 * SUM(isFlaggedFraud) / COUNT(*),4) AS system_flag_detection_pct
FROM banking_transactions_full
WHERE isFraud = 1;


--Origin account balance changes
SELECT isFraud AS fraud_label,
    COUNT(*) AS total_transactions,
    ROUND(AVG(origin_balance_change), 2) AS avg_balance_change,
    ROUND(MIN(origin_balance_change), 2) AS min_balance_change,
    ROUND(MAX(origin_balance_change), 2) AS max_balance_change
FROM banking_transactions_full
GROUP BY isFraud
ORDER BY isFraud DESC;


--Fraud analysis by transaction type and system flag
SELECT
    type AS transaction_type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    SUM(isFlaggedFraud) AS system_flagged_transactions,
    SUM(
        CASE
            WHEN isFraud = 1 AND isFlaggedFraud = 0 THEN 1
            ELSE 0
        END
    ) AS unflagged_fraud_transactions
FROM banking_transactions_full
GROUP BY type
ORDER BY fraud_transactions DESC;


--Origin balance mismatch analysis
SELECT
    type AS transaction_type,
    isFraud AS fraud_label,
    COUNT(*) AS total_transactions,
    SUM(
        CASE
            WHEN ABS(origin_balance_change + amount) > 0.01
            THEN 1
            ELSE 0
        END
    ) AS origin_mismatch_count,
    ROUND(
        100 * SUM(
            CASE
                WHEN ABS(origin_balance_change + amount) > 0.01
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS origin_mismatch_pct
FROM banking_transactions_full
WHERE type IN ('CASH_OUT', 'TRANSFER')
GROUP BY type, isFraud
ORDER BY type, isFraud;


--Destination balance mismatch analysis
SELECT
    transaction_type,
    fraud_label,
    COUNT(*) AS total_transactions,
    SUM(destination_mismatch) AS destination_mismatch_count,
    ROUND(100 * AVG(destination_mismatch), 2)
        AS destination_mismatch_pct
FROM (
    SELECT
        type AS transaction_type,
        isFraud AS fraud_label,
        CASE
            WHEN ABS(destination_balance_change - amount) > 0.01
            THEN 1
            ELSE 0
        END AS destination_mismatch
    FROM banking_transactions_full
    WHERE type IN ('CASH_OUT', 'TRANSFER')
)
GROUP BY transaction_type, fraud_label
ORDER BY transaction_type, fraud_label;


--Overall fraud risk summary by transaction type
SELECT
    type AS transaction_type,
    COUNT(*) AS total_transactions,
    SUM(isFraud) AS fraud_transactions,
    ROUND(100 * AVG(isFraud), 4) AS fraud_rate_pct,
    ROUND(SUM(CASE WHEN isFraud = 1 THEN amount ELSE 0 END),2) AS fraud_labelled_amount
FROM banking_transactions_full
GROUP BY type
ORDER BY fraud_transactions DESC, type;