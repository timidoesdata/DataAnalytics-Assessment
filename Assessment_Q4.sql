--Create a CTE to calculate total transactions, tenure, and total profit per customer
WITH customer_transactions AS (
    SELECT u.id AS customer_id, u.name,                                         
        DATE_PART('month', AGE(CURRENT_DATE, u.date_joined)) AS tenure_months, 
        COUNT(s.id) AS total_transactions,              
        SUM(s.confirmed_amount * 0.001 / 100) AS total_profit 
    FROM users_customuser u
    JOIN savings_savingsaccount s 
        ON u.id = s.owner_id                            
    WHERE s.confirmed_amount > 0                          
    GROUP BY u.id, u.name, u.date_joined                     
)

-- get estimated CLV using the formula and return final output
SELECT 
    customer_id, 
    name,
    tenure_months,
    total_transactions,
    ROUND((CAST(total_transactions AS FLOAT) / NULLIF(tenure_months, 0))  
        * 12                                                         
        * (total_profit / NULLIF(total_transactions, 0)),         
        2                                                               
    ) AS estimated_clv
FROM customer_transactions
ORDER BY estimated_clv DESC;                                               
