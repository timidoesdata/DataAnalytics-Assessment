--- Account inactivity alert
--- get most recent transaction date for each savings plan
WITH last_transactions AS (
    SELECT plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY plan_id
),
--- identify active savings or investment plans
active_plans AS (
    SELECT id AS plan_id,
        owner_id,
        CASE 
            WHEN is_regular_savings = 1 THEN 'Savings'
            WHEN is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type
    FROM plans_plan
    WHERE is_regular_savings = 1 OR is_a_fund = 1
)
--- calculate inactivity
SELECT 
    ap.plan_id,
    ap.owner_id,
    ap.type, 
    DATE_FORMAT(lt.last_transaction_date, '%Y-%m-%d') AS last_transaction_date,
    CASE 
        WHEN lt.last_transaction_date IS NOT NULL THEN DATEDIFF(CURDATE(), lt.last_transaction_date)
        ELSE NULL
    END AS inactivity_days
FROM active_plans ap
LEFT JOIN last_transactions lt ON ap.plan_id = lt.plan_id
WHERE lt.last_transaction_date IS NULL 
    OR DATEDIFF(CURDATE(), lt.last_transaction_date) > 365
ORDER BY inactivity_days DESC
