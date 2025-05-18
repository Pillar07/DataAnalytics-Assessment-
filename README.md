
# DataAnalytics-Assessment

This repository contains solutions to a SQL Proficiency Assessment designed to evaluate data analysis and SQL querying skills. The task involved querying a relational database to extract insights and perform calculations relevant to customer behavior, transaction activity, and customer lifetime value.


## Question-wise Explanations

✅ Question 1: High-Value Customers with Multiple Products

Objective: Identify customers with at least one funded savings plan and one funded investment plan.

Approach:

1. Joined plans_plan with savings_savingsaccount to count deposits per plan.
2. Used conditional aggregation to count funded savings (is_regular_savings = 1) and investment plans (is_a_fund = 1).
3. Filtered customers who had both types and sorted by total deposits.

Challenge: Initially had issue understanding the schema


✅ Question 2: Transaction Frequency Analysis

Objective: Categorize customers into High, Medium, or Low transaction frequency based on average monthly transactions.

Approach:
1. Grouped savings_savingsaccount by owner_id
2. Used TIMESTAMPDIFF(MONTH, ...) to calculate active months.
3. Computed average transactions per month.
4. Categorized using CASE statement.


     ✅ Question 3: Account Inactivity Alert
Objective: Identify plans with no inflow in the last 365 days.

Approach:
1. Used MAX(created_on) from savings_savingsaccount to determine the last inflow.
2. Joined with plans_plan to determine plan type (is_a_fund = 1 → Investment).
3. Used DATEDIFF() to calculate inactivity days.
4.Filtered for plans with last activity more than 365 days ago.

✅ Question 4: Customer Lifetime Value (CLV)

Objective: Estimate CLV using transaction history and account tenure.

Approach:
1. Used TIMESTAMPDIFF(MONTH, created_on, CURRENT_DATE()) to get account tenure.
2. Calculated total transactions and total confirmed amount.
3. Used a simplified CLV formula:
CLV = (total_transactions / tenure) * 12 * average_profit_per_transaction



## Final Thoughts

This assessment reinforced the importance of:

•Using correct SQL syntax for the target RDBMS

•	Understanding data structures and ensuring proper joins

•	Applying logical handling for edge cases (zero tenure, missing transactions)
________________________________________

## Repository Structure

DataAnalytics-Assessment/
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
└── README.md
All queries are written in standard, well-formatted SQL with comments for clarity.

├## Tools Used
Tools Used
	MySQL Workbench
     	Microsoft Office
