# 📊 SQL Project: Advanced Sales Analytics

## 💡 Project Overview

This project demonstrates advanced SQL techniques to analyze and summarize sales data. It includes queries based on:

* **Date Functions** for time-based filtering and metrics
* **Pivoting Data** for cross-tab analysis
* **Window Functions** for customer behavior trends
* **Views** for reusable logic
* **Query Optimization** for efficient performance

The goal is to extract insights like net revenue, processing time, customer distribution, and product category analysis.

---

## 🗓️ Date Functions

### ✅ Query 1: Orders in the Last 5 Years

Filters all sales placed within the last 5 years.

```sql
SELECT
    CURRENT_DATE,
    orderdate
FROM sales
WHERE orderdate >= CURRENT_DATE - INTERVAL '5 years'
LIMIT 100;
```

### ✅ Query 2: Net Revenue and Avg Processing Time by Year

Calculates total revenue and average delivery duration for each year.

```sql
SELECT
    DATE_PART('year', orderdate) AS order_year,
    ROUND(AVG(EXTRACT(DAYS FROM AGE(deliverydate, orderdate))), 2) AS avg_processing_time,
    CAST(SUM(quantity * netprice * exchangerate) AS INTEGER) AS total_revenue
FROM sales
WHERE orderdate >= CURRENT_DATE - INTERVAL '5 years'
GROUP BY order_year
ORDER BY order_year;
```

---

## 🔄 Pivoting Data

### 📅 Query 3: Daily Active Customers by Continent (Jan 2022)

Splits daily customer counts by continent.

```sql
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
```

### 📆 Query 4: Revenue by Category for 2022 and 2023

Pivot revenue across years using CASE.

```sql
SELECT
  p.categoryname,
  SUM(s.quantity * s.netprice * s.exchangerate) AS net_revenue,
  SUM(CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN s.quantity * s.netprice * s.exchangerate ELSE 0 END) AS audio_revenue_2022,
  SUM(CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN s.quantity * s.netprice * s.exchangerate ELSE 0 END) AS video_revenue_2023
FROM sales s
LEFT JOIN product p ON s.productkey = p.productkey
GROUP BY p.categoryname
LIMIT 10;
```

### ✖️ Query 5: Median Revenue per Category

Uses PERCENTILE\_CONT to compare 2022 vs 2023 sales.

```sql
SELECT
  p.categoryname AS category,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CASE
      WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN s.quantity * s.netprice * s.exchangerate END) AS y2022_median_sales,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CASE
      WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN s.quantity * s.netprice * s.exchangerate END) AS y2023_median_sales
FROM sales s
LEFT JOIN product p ON s.productkey = p.productkey
GROUP BY p.categoryname;
```

### 🔁 Query 6: Revenue Grouping (High/Low) by Year

Categorizes sales as high or low using a median threshold.

```sql
WITH median_value AS (
  SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY s.quantity * s.netprice * s.exchangerate) AS median
  FROM sales s
  WHERE s.orderdate BETWEEN '2022-01-01' AND '2023-12-31'
)
SELECT
  p.categoryname AS category,
  SUM(CASE WHEN s.quantity * s.netprice * s.exchangerate < mv.median AND s.orderdate BETWEEN '2022-01-01' AND '2022-12-31'
      THEN s.quantity * s.netprice * s.exchangerate END) AS low_net_revenue,
  SUM(CASE WHEN s.quantity * s.netprice * s.exchangerate >= mv.median AND s.orderdate BETWEEN '2022-01-01' AND '2022-12-31'
      THEN s.quantity * s.netprice * s.exchangerate END) AS high_net_revenue,
  SUM(CASE WHEN s.quantity * s.netprice * s.exchangerate < mv.median AND s.orderdate BETWEEN '2023-01-01' AND '2023-12-31'
      THEN s.quantity * s.netprice * s.exchangerate END) AS low_net_revenue_2023,
  SUM(CASE WHEN s.quantity * s.netprice * s.exchangerate >= mv.median AND s.orderdate BETWEEN '2023-01-01' AND '2023-12-31'
      THEN s.quantity * s.netprice * s.exchangerate END) AS high_net_revenue_2023
FROM sales s
LEFT JOIN product p ON s.productkey = p.productkey,
median_value mv
GROUP BY p.categoryname;
```

### 🔹 Query 7: Revenue Tier Classification

Classifies revenue as low, medium, or high based on 25th and 75th percentiles.

```sql
WITH percentiles AS (
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY s.quantity * s.netprice * s.exchangerate) AS revenue_25th_percentile,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY s.quantity * s.netprice * s.exchangerate) AS revenue_75th_percentile
  FROM sales s
  WHERE s.orderdate BETWEEN '2022-01-01' AND '2023-12-31'
)
SELECT
  p.categoryname AS category,
  SUM(s.quantity * s.netprice * s.exchangerate) AS total_revenue,
  CASE
    WHEN s.quantity * s.netprice * s.exchangerate < percentiles.revenue_25th_percentile THEN '3 - Low'
    WHEN s.quantity * s.netprice * s.exchangerate >= percentiles.revenue_75th_percentile THEN '1 - High'
    ELSE '2 - Medium'
  END AS revenue_tier
FROM sales s
LEFT JOIN product p ON s.productkey = p.productkey,
percentiles
GROUP BY p.categoryname, revenue_tier;
```





