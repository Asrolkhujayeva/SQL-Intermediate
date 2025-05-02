-- Total Net Revenue and Average Processing time by year


SELECT
    DATE_PART('year', orderdate) AS order_year,
    ROUND(AVG(EXTRACT(DAYS FROM AGE(deliverydate, orderdate))), 2) AS avg_processing_time,
    CAST(SUM(quantity * netprice * exchangerate) AS INTEGER) AS total_revenue
FROM sales
WHERE orderdate >= CURRENT_DATE - INTERVAL '5 years'
GROUP BY order_year
ORDER BY order_year;


/*Resullts in csv
index,order_year,avg_processing_time,total_revenue
0,2020.0,"""0.96""",4690005
1,2021.0,"""1.36""",21357977
2,2022.0,"""1.62""",44864557
3,2023.0,"""1.75""",33108566
4,2024.0,"""1.67""",8396527
*/