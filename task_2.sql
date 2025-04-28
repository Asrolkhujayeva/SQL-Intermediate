/*
Show total revelue by the category of 2022 and 2023

Pivoting with SUM()
*/


SELECT 
  p.categoryname,
  SUM(s.quantity * s.netprice * s.exchangerate) AS net_revenue,
  SUM(CASE WHEN s.orderdate BETWEEN '2022-01-01' AND '2022-12-31' THEN s.quantity * s.netprice * s.exchangerate  ELSE 0 END) AS audio_revenue_2022,
  SUM(CASE WHEN s.orderdate BETWEEN '2023-01-01' AND '2023-12-31' THEN s.quantity * s.netprice * s.exchangerate  ELSE 0 END) AS video_revenue_2023
FROM sales s
LEFT JOIN product p ON s.productkey = p.productkey
GROUP BY p.categoryname
LIMIT 10;


/*Result in CSV
index,categoryname,net_revenue,audio_revenue_2022,video_revenue_2023
0,Audio,5312898.102378255,766938.2116714902,688690.1849831974
1,Cameras and camcorders ,18520360.659611166,2382532.561053792,1983546.2867335202
2,Cell phones,32624265.717098236,8119665.074432448,6002147.634055804
3,Computers,90619022.05213447,17862213.490345106,11650867.209374903
4,Games and Toys,1668574.1346866041,316127.3044168772,270374.9646576682
5,Home Appliances,26607245.535542037,6612446.6798249,5919992.873000359
6,"Music, Movies and Audio Books",10588310.995579518,2989297.2804736737,2180768.128534369
7,TV and Video,20466861.383035127,5815336.605382702,4412178.225520054
*/
