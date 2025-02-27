/*View the Dataset Structure*/
SELECT * FROM credit.credit_card_fraud_dataset;
/*Summary Statistics*/
SELECT 
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) AS fraudulent_transactions,
    SUM(CASE WHEN IsFraud = 0 THEN 1 ELSE 0 END) AS legitimate_transactions,
    (SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS fraud_percentage
FROM  credit.credit_card_fraud_dataset;
/*What are the minimum, maximum, average, and median transaction amounts*/
SELECT MIN(Amount),MAX(Amount),AVG(Amount) FROM credit.credit_card_fraud_dataset;
/*Fraudulent Transactions by Location*/
SELECT Location,(SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS fraud_percentage FROM credit.credit_card_fraud_dataset GROUP BY Location ORDER BY fraud_percentage DESC LIMIT 10;
/*Fraud Trends Over Time*/
SELECT Date(TransactionDate),(SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS fraud_percentage FROM credit.credit_card_fraud_dataset GROUP BY date(TransactionDate);
/* High-Risk Merchants*/
SELECT MerchantID, 
       COUNT(*) AS total_transactions, 
       SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
       (SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS fraud_percentage
FROM credit.credit_card_fraud_dataset
GROUP BY MerchantID
HAVING fraud_percentage > 10
ORDER BY fraud_percentage DESC;
/* High-Risk Merchants*/
SELECT Amount, 
       COUNT(*) AS total_transactions, 
       SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
       (SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS fraud_percentage
FROM credit.credit_card_fraud_dataset
GROUP BY Amount
HAVING fraud_percentage > 20
ORDER BY fraud_percentage DESC;
/*Suspicious Transaction Amounts*/
SELECT Amount, 
       COUNT(*) AS total_transactions, 
       SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
       (SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS fraud_percentage
FROM credit.credit_card_fraud_dataset
GROUP BY Amount
HAVING fraud_percentage > 20
ORDER BY fraud_percentage DESC;
/*Common Fraudulent Transaction Types*/
SELECT TransactionType, 
       COUNT(*) AS total_transactions, 
       SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) AS fraud_count,
       (SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS fraud_percentage
FROM credit.credit_card_fraud_dataset
GROUP BY TransactionType
ORDER BY fraud_percentage DESC;
/*Feature Importance*/
SELECT 
    COUNT(DISTINCT TransactionID) AS total_transactions,
    COUNT(DISTINCT MerchantID) AS total_merchants,
    COUNT(DISTINCT Location) AS total_locations,
    COUNT(DISTINCT TransactionType) AS transaction_types
FROM credit.credit_card_fraud_dataset;
/*High-Value Fraud*/
SELECT TransactionID, TransactionDate, Amount, MerchantID, Location, TransactionType
FROM credit.credit_card_fraud_dataset
WHERE IsFraud = 1
AND Amount > (SELECT AVG(Amount) FROM transactions WHERE IsFraud = 0) * 2
ORDER BY Amount DESC;
/*Multiple Frauds from Same Merchant*/
SELECT MerchantID, COUNT(*) AS fraud_count
FROM credit.credit_card_fraud_dataset
WHERE IsFraud = 1
GROUP BY MerchantID
HAVING COUNT(*) > 5
ORDER BY fraud_count DESC;
