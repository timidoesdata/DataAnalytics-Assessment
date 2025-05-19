# DataAnalytics-Assessment

This repository contains my solutions to the Cowrywise SQL proficiency assessment. 
The assessment consisted of four questions designed to test analytical thinking, SQL querying skills, and problem-solving using real-world-style data.

---

## Q1: Identify Customers with Both Savings and Investment Plans

### My approach:
- I queried the `savings_savingsaccount` and `plans_plan` tables.
- I joined them to the `users_customuser` table to identify users having:
  - At least one savings plan (`is_regular_savings = true`)
  - At least one investment plan (`is_a_fund = true`)
- I grouped by customer and summed their confirmed deposits.
- I then sorted the final results by highest deposit.

### Challenges:
- Some users appeared multiple times, however, I solved this by using `DISTINCT` and filtering after grouping.

---

## Q2: Frequency of Transactions per Customer

### My approach:
- I calculated each customer's average number of transactions per month since their join date.
- I used `DATE_PART('month', AGE(current_date, u.date_joined))` to find tenure.
- I used `CASE WHEN` statements to classify frequency:
  - High: >3 per month
  - Medium: 1–3 per month
  - Low: <1 per month

### Challenges:
- Some users had tenure = 0 months, and to avoid division by zero, I used `NULLIF`.
- I filtered only confirmed transactions in order to maintain accuracy.

---

## Q3: Inactive Accounts

### my approach:
- I queried the `savings_savingsaccount` table.
- I then sed `MAX(transaction_date)` to find the most recent transaction per account.
- I calculated the difference between `CURRENT_DATE` and the last transaction.
- Flagged accounts where the gap was **≥ 365 days** as inactive.

### Challenges:
- Some accounts had no transactions, which returned `NULL`. I handled this using `COALESCE` and `LEFT JOIN` to preserve all accounts in the final list.

---

## Q4: Estimating Customer Lifetime Value (CLV)

### My approach:
- I created a Common Table Expression (CTE) to:
  - Get each customer's total number of transactions and total profit, and
  - Calculate tenure in months since account creation
- I then pplied the CLV formula:
- Used `ROUND()` to return a 2-decimal figure for better readability.

### Challenges:
- There was many NULL values so I added `NULLIF()` to avoid division by zero for users with 0 tenure or transactions.
