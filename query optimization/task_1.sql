EXPLAIN ANALYZE
SELECT
    customerkey,
    SUM(quantity * netprice * exchangerate) AS net_revenue
FROM sales
WHERE orderdate >= '2024-01-01'
GROUP BY customerkey
LIMIT 50