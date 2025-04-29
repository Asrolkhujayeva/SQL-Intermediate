/*Calculate Median Sales per Product Category for 2022 and 2023

pivoting data with CASE
*/


SELECT
  p.categoryname AS category,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (CASE
      WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN (s.quantity * s.netprice * s.exchangerate) END)) AS y2022_median_sales,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (CASE
      WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN (s.quantity * s.netprice * s.exchangerate) END)) AS y2023_median_sales
FROM sales s
LEFT JOIN product p ON s.productkey = p.productkey
GROUP BY p.categoryname;


/*Results in csv
index,category,y2022_median_sales,y2023_median_sales
0,Audio,257.21227619999996,266.587696302
1,Cameras and camcorders ,651.464,672.5957984
2,Cell phones,418.6,375.881888
3,Computers,809.7,657.1806
4,Games and Toys,33.78,32.6208
5,Home Appliances,791.0,825.24556425
6,"Music, Movies and Audio Books",186.57556411500002,159.63418910000001
7,TV and Video,730.4559834,790.79
*/