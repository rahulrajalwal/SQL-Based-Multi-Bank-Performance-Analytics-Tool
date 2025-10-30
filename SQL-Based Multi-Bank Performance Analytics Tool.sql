-- SQL-Based Multi-Bank Performance Analytics Tool

CREATE DATABASE IF NOT EXISTS BankAnalytics;
USE BankAnalytics;

-- Disabling foreign key checks to drop tables safely
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing project tables in dependency order
DROP TABLE IF EXISTS Fees;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Holidays;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Branches;
DROP TABLE IF EXISTS Banks;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Creating Tables


-- Banks
CREATE TABLE Banks (
    bank_id INT PRIMARY KEY,
    bank_name VARCHAR(100),
    headquarters VARCHAR(50)
);

-- Branches
CREATE TABLE Branches (
    branch_id INT PRIMARY KEY,
    bank_id INT,
    branch_name VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    FOREIGN KEY (bank_id) REFERENCES Banks(bank_id)
);

-- Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    bank_id INT,
    name VARCHAR(50),
    customer_type VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    FOREIGN KEY (bank_id) REFERENCES Banks(bank_id)
);

-- Products
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    product_category VARCHAR(50),
    product_type VARCHAR(20)
);

-- Transactions
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    branch_id INT,
    product_id INT,
    transaction_date DATE,
    transaction_amount DECIMAL(12,2),
    payment_method VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Fees
CREATE TABLE Fees (
    fee_id INT PRIMARY KEY,
    transaction_id INT,
    fee_type VARCHAR(50),
    fee_amount DECIMAL(10,2),
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)
);

-- Holidays
CREATE TABLE Holidays (
    holiday_date DATE PRIMARY KEY,
    holiday_name VARCHAR(50)
);

-- Inserting Sample Data

-- Banks
INSERT INTO Banks VALUES
(1, 'ICICI', 'Mumbai'),
(2, 'HDFC Bank', 'Mumbai');

-- Branches
INSERT INTO Branches VALUES
(1, 1, 'Mumbai Central', 'Mumbai', 'Maharashtra'),
(2, 1, 'Ahmedabad Main', 'Ahmedabad', 'Gujarat'),
(3, 1, 'Bangalore MG Road', 'Bangalore', 'Karnataka'),
(4, 2, 'Delhi Connaught', 'Delhi', 'Delhi'),
(5, 2, 'Pune Camp', 'Pune', 'Maharashtra');

-- Customers
INSERT INTO Customers VALUES
(1, 1, 'Ramesh Kumar', 'Individual', 'Mumbai', 'Maharashtra'),
(2, 1, 'Suresh Patel', 'Individual', 'Ahmedabad', 'Gujarat'),
(3, 1, 'Tata Industries', 'Corporate', 'Pune', 'Maharashtra'),
(4, 1, 'Infosys Ltd', 'Corporate', 'Bangalore', 'Karnataka'),
(5, 2, 'Priya Sharma', 'Individual', 'Delhi', 'Delhi'),
(6, 2, 'Aditya Mehta', 'Individual', 'Pune', 'Maharashtra');

-- Products
INSERT INTO Products VALUES
(1, 'Savings Account', 'Deposit', 'Savings'),
(2, 'Home Loan', 'Loan', 'Home Loan'),
(3, 'Personal Loan', 'Loan', 'Personal Loan'),
(4, 'Credit Card', 'Card', 'Credit Card'),
(5, 'Fixed Deposit', 'Deposit', 'FD');

-- Transactions
INSERT INTO Transactions VALUES
(1, 1, 1, 1, '2025-01-05', 50000, 'Cash'),
(2, 2, 2, 2, '2025-02-15', 1500000, 'NetBanking'),
(3, 3, 3, 3, '2025-03-10', 750000, 'NetBanking'),
(4, 4, 3, 4, '2025-04-12', 50000, 'Card'),
(5, 5, 4, 1, '2025-05-18', 200000, 'Cash'),
(6, 1, 1, 5, '2025-06-20', 100000, 'Cash'),
(7, 6, 5, 2, '2025-07-15', 1200000, 'NetBanking');

-- Fees
INSERT INTO Fees VALUES
(1, 2, 'Processing Fee', 15000),
(2, 3, 'Service Charge', 5000),
(3, 4, 'Annual Fee', 1000),
(4, 5, 'Service Charge', 2000),
(5, 7, 'Processing Fee', 10000);

-- Holidays
INSERT INTO Holidays VALUES
('2025-01-26','Republic Day'),
('2025-08-15','Independence Day'),
('2025-10-02','Gandhi Jayanti');


--  Analytics Queries

-- Total revenue per bank
SELECT b.bank_name, SUM(t.transaction_amount) AS total_revenue
FROM Transactions t
JOIN Customers c ON t.customer_id = c.customer_id
JOIN Banks b ON c.bank_id = b.bank_id
GROUP BY b.bank_name;

-- Top customers by revenue per bank
SELECT b.bank_name, c.name, SUM(t.transaction_amount) AS total_spent
FROM Transactions t
JOIN Customers c ON t.customer_id = c.customer_id
JOIN Banks b ON c.bank_id = b.bank_id
GROUP BY b.bank_name, c.name
ORDER BY b.bank_name, total_spent DESC;

-- Branch revenue trend (monthly)
SELECT b.branch_name, EXTRACT(YEAR FROM t.transaction_date) AS year,
       EXTRACT(MONTH FROM t.transaction_date) AS month,
       SUM(t.transaction_amount) AS monthly_revenue
FROM Transactions t
JOIN Branches b ON t.branch_id = b.branch_id
GROUP BY b.branch_name, year, month
ORDER BY b.branch_name, year, month;

-- Customer retention rate per bank
WITH repeat_customers AS (
    SELECT customer_id
    FROM Transactions
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)
SELECT b.bank_name,
       (SELECT COUNT(*) FROM repeat_customers rc JOIN Customers c ON rc.customer_id=c.customer_id WHERE c.bank_id=b.bank_id) * 100.0
       / (SELECT COUNT(*) FROM Customers c WHERE c.bank_id=b.bank_id) AS retention_rate_percent
FROM Banks b;

-- RFM Analysis
SELECT b.bank_name, c.customer_id, c.name,
       DATEDIFF(CURRENT_DATE, MAX(t.transaction_date)) AS recency_days,
       COUNT(t.transaction_id) AS frequency,
       SUM(t.transaction_amount) AS monetary
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
JOIN Banks b ON c.bank_id = b.bank_id
GROUP BY b.bank_name, c.customer_id, c.name
ORDER BY b.bank_name, monetary DESC;

-- Payment method trends per bank
SELECT b.bank_name, t.payment_method, COUNT(*) AS num_transactions, SUM(transaction_amount) AS total_revenue
FROM Transactions t
JOIN Customers c ON t.customer_id = c.customer_id
JOIN Banks b ON c.bank_id = b.bank_id
GROUP BY b.bank_name, t.payment_method
ORDER BY b.bank_name, total_revenue DESC;

-- Product revenue and fees per bank
SELECT b.bank_name, p.product_name,
       SUM(t.transaction_amount) AS total_revenue,
       SUM(f.fee_amount) AS total_fees
FROM Transactions t
JOIN Customers c ON t.customer_id = c.customer_id
JOIN Banks b ON c.bank_id = b.bank_id
JOIN Products p ON t.product_id = p.product_id
LEFT JOIN Fees f ON t.transaction_id = f.transaction_id
GROUP BY b.bank_name, p.product_name
ORDER BY b.bank_name, total_revenue DESC;

-- High-value customers (top 80% revenue per bank)
WITH customer_revenue AS (
    SELECT b.bank_name, c.customer_id, c.name, SUM(t.transaction_amount) AS total_revenue
    FROM Transactions t
    JOIN Customers c ON t.customer_id = c.customer_id
    JOIN Banks b ON c.bank_id = b.bank_id
    GROUP BY b.bank_name, c.customer_id, c.name
),
bank_total AS (
    SELECT bank_name, SUM(total_revenue) AS total_rev
    FROM customer_revenue
    GROUP BY bank_name
)
SELECT cr.bank_name, cr.customer_id, cr.name, cr.total_revenue
FROM customer_revenue cr
JOIN bank_total bt ON cr.bank_name = bt.bank_name
WHERE cr.total_revenue >= 0.8 * bt.total_rev
ORDER BY cr.bank_name, cr.total_revenue DESC;

-- Revenue on Holidays
SELECT b.bank_name, h.holiday_name, SUM(t.transaction_amount) AS holiday_revenue
FROM Transactions t
JOIN Customers c ON t.customer_id = c.customer_id
JOIN Banks b ON c.bank_id = b.bank_id
JOIN Holidays h ON t.transaction_date = h.holiday_date
GROUP BY b.bank_name, h.holiday_name
ORDER BY b.bank_name, holiday_revenue DESC;
