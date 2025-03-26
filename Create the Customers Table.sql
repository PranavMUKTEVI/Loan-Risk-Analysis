
CREATE TEMP TABLE TempData (
    application_date DATE,
    age INT,
    annual_income DECIMAL(12,2),
    credit_score INT,
    employment_status VARCHAR(50),
    education_level VARCHAR(50),
    experience INT,
    loan_amount DECIMAL(12,2),
    loan_duration INT,
    marital_status VARCHAR(50),
    number_of_dependents INT,
    home_ownership_status VARCHAR(50),
    monthly_debt_payments DECIMAL(12,2),
    credit_card_utilization_rate DECIMAL(5,2),
    number_of_open_credit_lines INT,
    number_of_credit_inquiries INT,
    debt_to_income_ratio DECIMAL(5,2),
    bankruptcy_history BOOLEAN,  --  BOOLEAN for direct import
    loan_purpose VARCHAR(50),
    previous_loan_defaults BOOLEAN, -- BOOLEAN for direct import
    payment_history INT,
    length_of_credit_history INT,
    savings_account_balance DECIMAL(12,2),
    checking_account_balance DECIMAL(12,2),
    total_assets DECIMAL(12,2),
    total_liabilities DECIMAL(12,2),
    monthly_income DECIMAL(12,2),
    utility_bills_payment_history DECIMAL(5,2),
    job_tenure INT,
    net_worth DECIMAL(12,2),
    base_interest_rate DECIMAL(5,4),
    interest_rate DECIMAL(5,4),
    monthly_loan_payment DECIMAL(12,2),
    total_debt_to_income_ratio DECIMAL(5,2),
    loan_approved BOOLEAN, --  BOOLEAN for direct import
    risk_score DECIMAL(5,2)
);

-- Import data from CSV into TempData
COPY TempData
FROM 'D:/Loan.csv' CSV HEADER;

--   (convert from text to boolean)
UPDATE TempData
SET bankruptcy_history = CASE 
                            WHEN bankruptcy_history = '1' THEN TRUE 
                            ELSE FALSE 
                          END;

UPDATE TempData
SET previous_loan_defaults = CASE 
                                WHEN previous_loan_defaults = '1' THEN TRUE 
                                ELSE FALSE 
                              END;

UPDATE TempData
SET loan_approved = CASE 
                       WHEN loan_approved = '1' THEN TRUE 
                       ELSE FALSE 
                    END;


CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,  -- Auto-generated unique ID for customers
    application_date DATE,
    age INT,
    annual_income DECIMAL(12,2),
    credit_score INT,
    employment_status VARCHAR(50),
    education_level VARCHAR(50),
    experience INT,
    marital_status VARCHAR(50),
    number_of_dependents INT,
    home_ownership_status VARCHAR(50),
    bankruptcy_history BOOLEAN,
    savings_account_balance DECIMAL(12,2),
    checking_account_balance DECIMAL(12,2),
    total_assets DECIMAL(12,2),
    total_liabilities DECIMAL(12,2),
    monthly_income DECIMAL(12,2),
    utility_bills_payment_history DECIMAL(5,2),
    job_tenure INT,
    net_worth DECIMAL(12,2)
);

CREATE TABLE Loans (
    loan_id SERIAL PRIMARY KEY, -- Auto-generated unique ID for loans
    customer_id INT REFERENCES Customers(customer_id), -- Foreign key reference
    loan_amount DECIMAL(12,2),
    loan_duration INT,
    loan_purpose VARCHAR(50),
    monthly_debt_payments DECIMAL(12,2),
    credit_card_utilization_rate DECIMAL(5,2),
    number_of_open_credit_lines INT,
    number_of_credit_inquiries INT,
    debt_to_income_ratio DECIMAL(5,2),
    previous_loan_defaults BOOLEAN,
    payment_history INT,
    length_of_credit_history INT,
    base_interest_rate DECIMAL(5,4),
    interest_rate DECIMAL(5,4),
    monthly_loan_payment DECIMAL(12,2),
    total_debt_to_income_ratio DECIMAL(5,2),
    loan_approved BOOLEAN,
    risk_score DECIMAL(5,2)
);
INSERT INTO Customers (application_date, age, annual_income, credit_score, employment_status, education_level, experience, marital_status, number_of_dependents, home_ownership_status, bankruptcy_history, savings_account_balance, checking_account_balance, total_assets, total_liabilities, monthly_income, utility_bills_payment_history, job_tenure, net_worth)
SELECT DISTINCT application_date, age, annual_income, credit_score, employment_status, education_level, experience, marital_status, number_of_dependents, home_ownership_status, bankruptcy_history, savings_account_balance, checking_account_balance, total_assets, total_liabilities, monthly_income, utility_bills_payment_history, job_tenure, net_worth
FROM TempData;

-- Insert loan data, linking to the correct customer
INSERT INTO Loans (customer_id, loan_amount, loan_duration, loan_purpose, monthly_debt_payments, credit_card_utilization_rate, number_of_open_credit_lines, number_of_credit_inquiries, debt_to_income_ratio, previous_loan_defaults, payment_history, length_of_credit_history, base_interest_rate, interest_rate, monthly_loan_payment, total_debt_to_income_ratio, loan_approved, risk_score)
SELECT c.customer_id, t.loan_amount, t.loan_duration, t.loan_purpose, t.monthly_debt_payments, t.credit_card_utilization_rate, t.number_of_open_credit_lines, t.number_of_credit_inquiries, t.debt_to_income_ratio, t.previous_loan_defaults, t.payment_history, t.length_of_credit_history, t.base_interest_rate, t.interest_rate, t.monthly_loan_payment, t.total_debt_to_income_ratio, t.loan_approved, t.risk_score
FROM TempData t
JOIN Customers c 
    ON t.age = c.age 
    AND t.credit_score = c.credit_score 
    AND t.annual_income = c.annual_income 
    AND t.application_date = c.application_date;

-- Clean up
DROP TABLE TempData;


