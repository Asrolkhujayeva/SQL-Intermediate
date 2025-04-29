/*
Categorize each sale using a CASE statement:
 -'low' for revenue below the 25th percentile
 - 'Median' for revenue between the 25th and 75th percentiles
 - 'High' for revenue above the 75th percentile

Aggregate total net revenue or each category and tier using SUM(quantity*netprice*exchangerate)
group the results by categoryname and revenue_tier for meaninful segmentation
*/


WITH percentiles AS (
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY (s.quantity * s.netprice * s.exchangerate)) AS revenue_25th_percentile,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY (s.quantity * s.netprice * s.exchangerate)) AS revenue_75th_percentile
  FROM sales s
  WHERE s.orderdate BETWEEN '2022-01-01' AND '2023-12-31'
)

SELECT
  p.categoryname AS category,
  SUM(s.quantity * s.netprice * s.exchangerate)  AS total_revenue,
  CASE
    WHEN (s.quantity * s.netprice * s.exchangerate) < percentiles.revenue_25th_percentile THEN '3 - Low'
    WHEN (s.quantity * s.netprice * s.exchangerate) >= percentiles.revenue_75th_percentile THEN '1 - High'
    ELSE '2 - Medium'
  END AS revenue_tier
FROM sales s
LEFT JOIN product p ON s.productkey = p.productkey,
percentiles
GROUP BY p.categoryname, revenue_tier;

/* Results in csv
index,category,total_revenue,revenue_tier
0,Audio,1213265.71363285,1 - High
1,Audio,3832415.382310277,2 - Medium
2,Audio,267217.00643510325,3 - Low
3,Cameras and camcorders ,15050781.630230403,1 - High
4,Cameras and camcorders ,3388546.104676732,2 - Medium
5,Cameras and camcorders ,81032.92470404143,3 - Low
6,Cell phones,21874993.14765068,1 - High
7,Cell phones,10338963.217020713,2 - Medium
8,Cell phones,410309.35242682265,3 - Low
9,Computers,79607760.88966574,1 - High
10,Computers,10808054.105618838,2 - Medium
11,Computers,203207.05684977135,3 - Low
12,Games and Toys,133749.09307957598,1 - High
13,Games and Toys,1001381.9080737742,2 - Medium
14,Games and Toys,533443.133533257,3 - Low
15,Home Appliances,22383475.296016462,1 - High
16,Home Appliances,4118724.6404670966,2 - Medium
17,Home Appliances,105045.59905826848,3 - Low
18,"Music, Movies and Audio Books",3844996.291374837,1 - High
19,"Music, Movies and Audio Books",6100817.990653775,2 - Medium
20,"Music, Movies and Audio Books",642496.713550717,3 - Low
21,TV and Video,16632856.325682836,1 - High
22,TV and Video,3766783.301903755,2 - Medium
23,TV and Video,67221.7554484602,3 - Low
*/

