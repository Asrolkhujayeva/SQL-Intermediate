/*
Task Title:
Calculate Sales by Revenue Group for Product Categories in 2022 and 2023

Objective:
Write an SQL query to calculate the total net revenue for each product
category in two groups (low and high revenue) for the years 2022 and 2023.
*/

WITH median_value AS (
  SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (s.quantity * s.netprice * s.exchangerate)) AS median
  FROM sales s
  WHERE s.orderdate BETWEEN '2022-01-01' AND '2023-12-31'
)

SELECT
  p.categoryname AS category,
  SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) < mv.median
        AND s.orderdate BETWEEN '2022-01-01' AND '2022-12-31'
    THEN (s.quantity * s.netprice * s.exchangerate) END) AS low_net_revenue,
  SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) >= mv.median
        AND s.orderdate BETWEEN '2022-01-01' AND '2022-12-31'
    THEN (s.quantity * s.netprice * s.exchangerate) END) AS high_net_revenue,
  SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) < mv.median
        AND s.orderdate BETWEEN '2023-01-01' AND '2023-12-31'
        THEN (s.quantity * s.netprice * s.exchangerate) END) AS low_net_revenue_2023,
  SUM(CASE WHEN (s.quantity * s.netprice * s.exchangerate) >= mv.median
        AND s.orderdate BETWEEN '2023-01-01' AND '2023-12-31'
        THEN (s.quantity * s.netprice * s.exchangerate) END) AS high_net_revenue_2023
FROM sales s
LEFT JOIN product p ON s.productkey = p.productkey,
median_value mv
GROUP BY p.categoryname;



/*Results in csv
index,category,low_net_revenue,high_net_revenue,low_net_revenue_2023,high_net_revenue_2023
0,Audio,222337.82635718057,544600.3853143097,180251.12765094213,508439.0573322559
1,Cameras and camcorders ,133004.53986824956,2249528.021185544,104869.45553499,1878676.8311985293
2,Cell phones,814449.5290331575,7305215.545399249,729699.3943516628,5272448.239704115
3,Computers,624340.4187194712,17237873.071625635,590790.3066906694,11060076.902684227
4,Games and Toys,231979.63297224336,84147.67144463338,206103.36475734616,64271.599900322006
5,Home Appliances,219797.07275582812,6392649.607069068,176261.350547353,5743731.5224530045
6,"Music, Movies and Audio Books",685808.48535634,2303488.7951173475,574958.7615252442,1605809.3670091284
7,TV and Video,272338.28691856225,5542998.3184641395,164275.35307351,4247902.8724465445
*/