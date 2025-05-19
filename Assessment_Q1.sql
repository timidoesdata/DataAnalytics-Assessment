--- Q1. Identify high-value customers with multiple products
SELECT * FROM users_customuser;
SELECT * FROM savings_savingsaccount;
SELECT * FROM plans_plan; 

WITH savings_details AS ( 
	SELECT owner_id,
        COUNT(*) AS savings_count,
        SUM(confirmed_amount) / 100 AS total_savings
	FROM savings_savingsaccount
    WHERE confirmed_amount > 0 
    GROUP BY owner_id
),
investment_details AS (
	SELECT owner_id,
		COUNT(*) AS investment_count,
        SUM(amount) / 100 AS total_investment
	FROM plans_plan
    WHERE amount > 0 AND is_a_fund = 1
	GROUP BY owner_id
    )
SELECT s.owner_id,
	CONCAT(u.first_name, ' ', u.last_name) AS name,
    s.savings_count,
    i.investment_count,
    ROUND(s.total_savings + i.total_investment, 2) AS total_deposits
FROM savings_details s
JOIN investment_details i ON s.owner_id = i.owner_id 
JOIN users_customuser u ON u.id = s.owner_id
ORDER BY total_deposits DESC

        
