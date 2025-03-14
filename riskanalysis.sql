SELECT 
    customer_id, 
    credit_score, 
    annual_income, 
    bankruptcy_history,
    CASE 
        WHEN credit_score < 600 OR bankruptcy_history = TRUE THEN 'High Risk'
        WHEN credit_score BETWEEN 600 AND 700 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM Customers;
SELECT 
    c.credit_score, 
    COUNT(l.loan_id) AS total_loans, 
    SUM(CASE WHEN l.loan_approved = TRUE THEN 1 ELSE 0 END) AS approved_loans,
    ROUND(100.0 * SUM(CASE WHEN l.loan_approved = TRUE THEN 1 ELSE 0 END) / COUNT(l.loan_id), 2) AS approval_rate
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
GROUP BY c.credit_score
ORDER BY c.credit_score DESC;
SELECT 
    customer_id, 
    SUM(loan_amount) AS total_loans, 
    COUNT(loan_id) AS num_loans
FROM Loans
WHERE loan_amount > (SELECT AVG(loan_amount) * 3 FROM Loans)
GROUP BY customer_id
HAVING COUNT(loan_id) > 5;
CREATE VIEW RiskAssessment AS
SELECT 
    c.customer_id, 
    c.credit_score, 
    c.annual_income, 
    c.bankruptcy_history, 
    l.loan_amount, 
    l.loan_approved, 
    CASE 
        WHEN c.credit_score < 600 OR c.bankruptcy_history = TRUE THEN 'High Risk'
        WHEN c.credit_score BETWEEN 600 AND 700 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_category
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id;
SELECT * FROM RiskAssessment;
