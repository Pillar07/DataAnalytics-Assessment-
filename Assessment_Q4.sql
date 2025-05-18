-- Estimate Customer Lifetime Value (CLV) per user (MySQL-compatible)
WITH user_tx_summary AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) AS total_value
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
tenure_data AS (
    SELECT
        u.id AS customer_id,
        u.name,
        TIMESTAMPDIFF(MONTH, u.created_on, CURRENT_DATE()) AS tenure_months,
        u.created_on AS signup_date
    FROM users_customuser u
),
clv_calc AS (
    SELECT
        t.customer_id,
        t.name,
        CASE 
            WHEN t.tenure_months = 0 THEN 1 
            ELSE t.tenure_months 
        END AS tenure_months,
        COALESCE(u.total_transactions, 0) AS total_transactions,
        COALESCE(u.total_value, 0) AS total_value,
        CASE 
            WHEN u.total_transactions IS NULL OR u.total_transactions = 0 THEN 0
            ELSE (CAST(u.total_value AS DECIMAL(15,2)) / u.total_transactions) * 0.001
        END AS avg_profit_per_transaction
    FROM tenure_data t
    LEFT JOIN user_tx_summary u ON t.customer_id = u.owner_id
)
SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND((total_transactions / tenure_months) * 12 * avg_profit_per_transaction / 100, 2) AS estimated_clv
FROM clv_calc
ORDER BY estimated_clv DESC;
