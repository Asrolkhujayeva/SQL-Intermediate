/*
COALESCE for average revenue.
Spending Customers VS All Customers
*/
WITH sale_data AS (
    SELECT
        customerkey,
        SUM(quantity * netprice * exchangerate) AS net_revenue
    FROM sales
    GROUP BY customerkey  
)

SELECT
    AVG(s.net_revenue) AS sppending_customers_avg_net_revenue,
    AVG(COALESCE(s.net_revenue, 0)) AS all_customers_avg_net_revenue
FROM sale_data s
LEFT JOIN customer c ON s.customerkey = c.customerkey
