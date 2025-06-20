# 🧠 SQL Customer Cohort Analysis & LTV Insights

This project uses SQL to analyze customer behavior over time, including:

- 📊 **Cohort-based customer retention**
- 💰 **Customer Lifetime Value (LTV)**
- 📈 **Order count ranking and revenue patterns**

The dataset is based on a transactional `sales` table with detailed purchase data.

---

## 📁 Data Overview

The `sales` table includes:

| Column        | Description                                 |
|---------------|---------------------------------------------|
| `customerkey` | Unique customer ID                          |
| `orderdate`   | Date of purchase                            |
| `quantity`    | Quantity of products purchased              |
| `netprice`    | Price per unit                              |
| `exchangerate`| Exchange rate to convert to base currency   |

---

## 📆 Cohort Analysis

This query tracks customer retention by cohort and year:

```sql
WITH yearly_cohort AS (
  SELECT DISTINCT
    customerkey,
    EXTRACT(YEAR FROM MIN(orderdate) OVER(PARTITION BY customerkey)) AS cohort_year,
    EXTRACT(YEAR FROM orderdate) AS purchase_year
  FROM sales
)

SELECT DISTINCT
  cohort_year,
  purchase_year,
  COUNT(customerkey) OVER(PARTITION BY purchase_year, cohort_year) AS num_customers
FROM yearly_cohort
ORDER BY cohort_year, purchase_year;
