--- Q2. Transaction frequency analysis
WITH monthly_transactions AS (
    SELECT s.owner_id,
        EXTRACT(YEAR FROM s.transaction_date) AS year,
        EXTRACT(MONTH FROM s.transaction_date) AS month,
        COUNT(*) AS transactions_count
    FROM savings_savingsaccount s
    GROUP BY s.owner_id, year, month
),
avg_transactions_per_customer AS (
    SELECT owner_id,
        AVG(transactions_count) AS avg_monthly_transactions
    FROM monthly_transactions
    GROUP BY owner_id
),
categorized_customer AS (
    SELECT owner_id,
        avg_monthly_transactions,
        CASE
            WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'
            WHEN avg_monthly_transactions BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_transactions_per_customer
)
SELECT frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month
FROM categorized_customer
GROUP BY frequency_category
ORDER BY
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;
