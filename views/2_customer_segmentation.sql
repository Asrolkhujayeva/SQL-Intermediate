/*
Customer segmentation

Who are our most valuable customers?
*/

WITH customer_ltv AS (
    SELECT
        customerkey,
        CONCAT(givenname, ' ', surname) AS cleaned_name,
        SUM(total_net_revenue) AS total_ltv
    FROM cohort_analysis
    GROUP BY
        customerkey,
        cleaned_name
), customer_segments AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_ltv) AS ltv_25th_percentile,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_ltv) AS ltv_75th_percentile
    FROM customer_ltv
), segment_values AS (
    SELECT
        c.*,
        CASE
            WHEN c.total_ltv < cs.ltv_25th_percentile THEN '1 - Low Value'
            WHEN c.total_ltv <= cs.ltv_75th_percentile THEN '2 - Mid Value'
            ELSE '3 - High Value'
        END AS customer_segment
    FROM customer_ltv c, customer_segments cs
)

SELECT
    customer_segment,
    SUM(total_ltv) AS total_ltv,
    COUNT(customerkey) AS customer_count,
    SUM(total_ltv) / COUNT(customerkey) As avg_ltv
FROM segment_values
GROUP BY customer_segment
ORDER BY customer_segment DESC

/*Results
"customer_segment","total_ltv","customer_count","avg_ltv"
"3 - High Value",135429277.2654981,"12372",10946.433661938094
"2 - Mid Value",66636451.78723886,"24743",2693.1435875697716
"1 - Low Value",4341809.527328114,"12372",350.93837110637844
*/