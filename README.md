# Bank CRM — Customer Churn & Retention Analysis

End-to-end analysis of a bank's customer relationship data (~10,000 customers across France, Germany, and Spain) to uncover the drivers of customer churn and surface retention opportunities. The project moves from raw relational data in MySQL, through 25+ analytical SQL queries, to an interactive Power BI dashboard.

## Overview

A bank wants to understand why customers leave and which segments are most at risk. This project answers that using a 7-table relational schema (customer info, geography, gender, credit card, active status, exit category, and churn facts), covering objective SQL-driven questions and open-ended business analysis.

## Tools Used

- **MySQL** — schema joins, CTEs, window functions, data cleaning
- **Power BI** — interactive dashboard and visual storytelling
- **PowerPoint** — findings summary for stakeholders

## What's in this repo

| File | Description |
|---|---|
| `Bank_CRM_SQLFILE.sql` | 25+ SQL queries — joins across 7 tables, CTEs, window functions (`RANK()`), churn segmentation, data quality checks |
| `Bank CRM_Power_BI_dashboard.pbix` | Interactive Power BI dashboard with churn KPIs and regional/demographic breakdowns |
| `Bank_CRM_Data_Analysis.docx` | Full write-up: approach, SQL, visualization, and insight for every question |
| `Bank_Churn_Analysis.pptx` | Stakeholder-facing summary of key findings |

## Key Insights

- **Overall churn rate: ~20.4%** (~2,037 of 10,000 customers exited)
- **Gender gap**: Female customers churn at 25.1% vs. 16.5% for male customers
- **Single-product risk**: Customers with only 1 product account for the largest share of churned customers and ~₹0.5B in lost balances — cross-selling a second product is a clear retention lever
- **Regional concentration**: France leads in both total balances (~₹0.31B) and long-tenured active customers (705), while Germany and Spain lag notably behind
- **Credit score correlation**: Retained customers have marginally higher average credit scores (651.85) than churned customers (645.35); the Low Credit Score segment has the highest churn *rate* (23.6%) despite being the smallest segment
- **Data quality finding**: Identified a logical inconsistency where customers are flagged `Exited = 1` but still marked `IsActiveMember = 1`, and proposed a cleaning fix
- **Seasonality**: New customer acquisition consistently spikes in September–November across all four years in the dataset (2016–2019)

## Approach

1. **Data modeling** — joined `bank_churn`, `customerinfo`, `geography`, and `gender` tables into a unified `MainTable` in MySQL
2. **SQL analysis** — answered 25+ objective and subjective business questions using joins, CTEs, window functions, and conditional segmentation (age, balance, credit score buckets)
3. **Data quality checks** — flagged and resolved contradictory records between `IsActiveMember` and `Exited`
4. **Dashboarding** — built an interactive Power BI report to visualize churn by geography, gender, product count, and credit score segment
5. **Reporting** — documented approach, query, visualization, and insight for each question; summarized findings in a stakeholder-ready deck

## Author

**Urmila Palwal**
