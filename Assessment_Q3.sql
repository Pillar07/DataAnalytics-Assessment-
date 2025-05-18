-- Identify active accounts (Savings or Investment) with no transactions in the last 365 days
WITH savings_last_tx AS (
    SELECT
        s.plan_id,
        s.owner_id,
        'Savings' AS type,
        MAX(s.created_on) AS last_transaction_date
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_a_fund = 0
    GROUP BY s.plan_id, s.owner_id
),
investments_last_tx AS (
    SELECT
        s.plan_id,
        s.owner_id,
        'Investment' AS type,
        MAX(s.created_on) AS last_transaction_date
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_a_fund = 1
    GROUP BY s.plan_id, s.owner_id
),
combined AS (
    SELECT * FROM savings_last_tx
    UNION ALL
    SELECT * FROM investments_last_tx
)
SELECT
    plan_id,
    owner_id,
    type,
    DATE(last_transaction_date) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(), last_transaction_date) AS inactivity_days
FROM combined
WHERE last_transaction_date < DATE_SUB(CURRENT_DATE(), INTERVAL 365 DAY)
ORDER BY inactivity_days DESC;
