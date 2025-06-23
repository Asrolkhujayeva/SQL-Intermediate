# 📊 SQL Project: Sales Analysis with Date Functions

## 🧠 Overview

This SQL project focuses on using **Date Functions** to extract insights from sales data over the last five years. It demonstrates how to:
- Filter records by date intervals
- Extract year-based aggregates
- Calculate delivery processing time
- Compute yearly revenue performance

---

## 📅 Query 1: Filter Orders from the Last 5 Years

This query selects orders where the `orderdate` falls within the past 5 years from the current system date.

### SQL Code:
```sql
SELECT 
    CURRENT_DATE,
    orderdate
FROM sales
WHERE
    orderdate >= CURRENT_DATE - INTERVAL '5 years'
LIMIT 100;
# 📊 SQL Project: Sales Analysis with Date Functions

## 🧠 Overview

This SQL project focuses on using **Date Functions** to extract insights from sales data over the last five years. It demonstrates how to:
- Filter records by date intervals
- Extract year-based aggregates
- Calculate delivery processing time
- Compute yearly revenue performance

---

## 📅 Query 1: Filter Orders from the Last 5 Years

This query selects orders where the `orderdate` falls within the past 5 years from the current system date.

### SQL Code:
```sql
SELECT 
    CURRENT_DATE,
    orderdate
FROM sales
WHERE
    orderdate >= CURRENT_DATE - INTERVAL '5 years'
LIMIT 100;
