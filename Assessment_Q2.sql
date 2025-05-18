-- Analyze transaction frequency and categorize users (MySQL version)
WITH transaction_stats AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        GREATEST(
            (YEAR(MAX(created_on)) - YEAR(MIN(created_on))) * 12 +
            (MONTH(MAX(created_on)) - MONTH(MIN(created_on))),
            1
        ) AS active_months
    FROM savings_savingsaccount
    GROUP BY owner_id
),
categorized AS (
    SELECT
        owner_id,
        total_transactions,
        active_months,
        ROUND(CAST(total_transactions AS DECIMAL(10,2)) / active_months, 2) AS avg_tx_per_month,
        CASE
            WHEN CAST(total_transactions AS DECIMAL(10,2)) / active_months >= 10 THEN 'High Frequency'
            WHEN CAST(total_transactions AS DECIMAL(10,2)) / active_months BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM transaction_stats
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
