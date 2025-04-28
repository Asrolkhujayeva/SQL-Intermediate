/*
Task: Analyze Daily Customer Activity in January 2023
Objective: To understand the daily customer activity and
regional distribution of customers for the month of January 2025
*/

SELECT 
  s.orderdate,
  COUNT(DISTINCT s.customerkey) AS total_customers,
  COUNT(DISTINCT CASE WHEN c.continent = 'Europe' THEN s.customerkey END) as europe_customers,
  COUNT(DISTINCT CASE WHEN c.continent = 'Asia' THEN s.customerkey END) as asia_customers,
  COUNT(DISTINCT CASE WHEN c.continent = 'Africa' THEN s.customerkey END) as africa_customers
FROM sales s
LEFT JOIN customer c ON s.customerkey = c.customerkey
WHERE s.orderdate BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY s.orderdate
LIMIT 10;


/*RESULTS IN JSON
[
    {"index":0,"orderdate":"2022-01-01","total_customers":86,"europe_customers":29,"asia_customers":0,"africa_customers":0},
    {"index":1,"orderdate":"2022-01-02","total_customers":9,"europe_customers":4,"asia_customers":0,"africa_customers":0},
    {"index":2,"orderdate":"2022-01-03","total_customers":39,"europe_customers":10,"asia_customers":0,"africa_customers":0},
    {"index":3,"orderdate":"2022-01-04","total_customers":51,"europe_customers":16,"asia_customers":0,"africa_customers":0},
    {"index":4,"orderdate":"2022-01-05","total_customers":62,"europe_customers":18,"asia_customers":0,"africa_customers":0},
    {"index":5,"orderdate":"2022-01-06","total_customers":67,"europe_customers":19,"asia_customers":0,"africa_customers":0},
    {"index":6,"orderdate":"2022-01-07","total_customers":44,"europe_customers":11,"asia_customers":0,"africa_customers":0},
    {"index":7,"orderdate":"2022-01-08","total_customers":78,"europe_customers":29,"asia_customers":0,"africa_customers":0},
    {"index":8,"orderdate":"2022-01-09","total_customers":7,"europe_customers":1,"asia_customers":0,"africa_customers":0},
    {"index":9,"orderdate":"2022-01-10","total_customers":33,"europe_customers":16,"asia_customers":0,"africa_customers":0}]
*/