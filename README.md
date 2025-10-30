# SQL-Based Multi-Bank Performance Analytics Tool

A comprehensive SQL-powered analytics solution for comparing key performance metrics across multiple banks, designed to facilitate actionable insights for banking sector management and analysts.

## Project Overview

The Multi-Bank Performance Analytics Tool leverages MySQL to analyze transactional, customer, and product data across diverse banks and branches. It automates complex business intelligence queries revenue, retention, RFM analysis, payment behaviors, and holiday impacts enabling optimal decisions on product offerings and customer targeting.

## Features

- Cross-bank analytics: Compare data across banks and branches for competitive analysis.
- Revenue, fees, and product metrics: Automated SQL queries for total revenue, product fees, trends, and high-value customers.
- Customer retention & segmentation: RFM profiling, repeat transaction analysis, and loyalty measurement.
- Payment method trends: Visualize payment type distribution and value across banks.
- Error handling & data integrity: Rigorous foreign key constraints and normalized schema to maintain robust relationships.
- Holiday impact modeling: Discover bank revenues and transaction shifts during national holidays.

## Database Schema

- **Entity Tables:** Banks, Branches, Customers, Products  
- **Transactional Tables:** Transactions, Fees  
- **Auxiliary Tables:** Holidays  
- Relationships are enforced using foreign keys. The schema supports normalized storage and flexible queries using CTEs and aggregates.

## Setup Instructions

1. **Create Database and Tables:**  
   Run the SQL script (`SQL-Based-Multi-Bank-Performance-Analytics-Tool.sql`) to set up the schema and insert sample data.

2. **Populate Data:**  
   Insert operational data by expanding the sample inserts for banks, branches, customers, products, transactions, fees, and holiday dates.

3. **Run Analytics Queries:**  
   Use the provided example SQL queries for revenue analysis, retention rate, RFM segmentation, product insights, and holiday analysis.

## Example SQL Analytics Queries

| Metric                        | Description                                                       |
|-------------------------------|-------------------------------------------------------------------|
| Total Revenue per Bank        | Aggregates all transaction values by each bank.                   |
| Top Customers by Revenue      | Ranks customers with highest transaction volume per bank.         |
| Customer Retention Rate       | Calculates repeat transaction percentage per bank.                |
| RFM Analysis                  | Segments customers by recency, frequency, and monetary value.     |
| Payment Method Trends         | Shows frequency/value for each payment method.                    |
| Product Revenue and Fees      | Summarizes revenue and fees for each product.                     |
| High-Value Customers          | Identifies customers contributing top 80% revenue per bank.       |
| Revenue on Holidays           | Sums transaction totals for holidays per bank.                    |

## Error Handling and Data Integrity

- Uses foreign keys for strict reference validation between banks, customers, and transactions.
- Enforces consistent data types and nullability for reliability.

## Future Enhancements

- Integrating temporal analytics and trend forecasting via machine learning models.
- Expanding schema for deeper demographic segmentation and richer transaction metadata.

## Authors

- Rahul Meena
- Chandra Shekhar
