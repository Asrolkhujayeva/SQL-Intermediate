/*
Classify Customers as Active vs. Churned

Retention Analysis
*/
WITH customer_last_purchase AS (
    SELECT
        customerkey,
        CONCAT(givenname, ' ', surname) AS cleaned_name,
        orderdate,
        ROW_NUMBER() OVER (PARTITION BY customerkey ORDER BY orderdate DESC) AS rn,
        first_purchase_date,
        cohort_year
    FROM cohort_analysis
), churned_customers AS (
    SELECT
        customerkey,
        cleaned_name,
        orderdate AS last_purchase_date,
        CASE
            WHEN orderdate < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months' THEN 'Churned'
            ELSE 'Active'
        END AS customer_status,
        cohort_year
    FROM customer_last_purchase
    WHERE rn = 1
        AND first_purchase_date < (SELECT MAX(orderdate) FROM sales) - INTERVAL '6 months'
)


SELECT
    cohort_year,
    customer_status,
    COUNT(customerkey) AS num_customers,
    SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year) AS total_customers,
    ROUND(COUNT(customerkey) / SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year), 2) AS status_percentage
FROM churned_customers
GROUP BY cohort_year, customer_status

/*
Customer Status Distribution

"customer_status","num_customers","status_percentage"
"Active","4441","0.09"
"Churned","42472","0.91"
*/

/* Total customer retention and Churn by Cohort year

"cohort_year","customer_status","num_customers","total_customers","status_percentage"
"2015","Active","237","2825","0.08"
"2015","Churned","2588","2825","0.92"
"2016","Active","311","3397","0.09"
"2016","Churned","3086","3397","0.91"
"2017","Active","385","4068","0.09"
"2017","Churned","3683","4068","0.91"
"2018","Active","704","7446","0.09"
"2018","Churned","6742","7446","0.91"
"2019","Active","687","7755","0.09"
"2019","Churned","7068","7755","0.91"
"2020","Active","283","3031","0.09"
"2020","Churned","2748","3031","0.91"
"2021","Active","442","4663","0.09"
"2021","Churned","4221","4663","0.91"
"2022","Active","937","9010","0.10"
"2022","Churned","8073","9010","0.90"
"2023","Active","455","4718","0.10"
"2023","Churned","4263","4718","0.90"

*/