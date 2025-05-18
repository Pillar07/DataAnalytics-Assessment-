-- Find customers with both funded savings and investment plans
WITH savings_summary AS (
    SELECT
        s.owner_id,
        COUNT(*) AS savings_count,
        SUM(s.confirmed_amount) AS savings_total
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_a_fund = 0 AND s.confirmed_amount > 0
    GROUP BY s.owner_id
),
investment_summary AS (
    SELECT
        s.owner_id,
        COUNT(*) AS investment_count,
        SUM(s.confirmed_amount) AS investment_total
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE p.is_a_fund = 1 AND s.confirmed_amount > 0
    GROUP BY s.owner_id
)
SELECT
    u.id AS owner_id,
    u.name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    ROUND((COALESCE(s.savings_total, 0) + COALESCE(i.investment_total, 0)) / 100.0, 2) AS total_deposits
FROM users_customuser u
LEFT JOIN savings_summary s ON u.id = s.owner_id
LEFT JOIN investment_summary i ON u.id = i.owner_id
WHERE COALESCE(s.savings_count, 0) > 0 AND COALESCE(i.investment_count, 0) > 0
ORDER BY total_deposits DESC;
