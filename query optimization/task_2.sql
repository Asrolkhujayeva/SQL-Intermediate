EXPLAIN ANALYZE
SELECT
    customerkey,
    orderdate,
    SUM(quantity * netprice * exchangerate) AS net_revenue
FROM sales
GROUP BY
    customerkey,
    orderdate
