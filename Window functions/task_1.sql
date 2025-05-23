-- Average Revenue of Customers

SELECT
    customerkey,
    orderkey,
    linenumber,
    (quantity * netprice * exchangerate) AS net_revenue,
    AVG(quantity * netprice * exchangerate) OVER(PARTITION BY customerkey) AS avg_net_revenue_of_customer,
    ROW_NUMBER() OVER(PARTITION BY customerkey ORDER BY (quantity * netprice * exchangerate) DESC) AS order_rank,
    SUM(quantity * netprice * exchangerate) OVER(PARTITION BY customerkey ORDER BY orderdate) AS customer_running_total
FROM sales
ORDER BY customerkey
LIMIT 10


/*Results
index,customerkey,orderkey,linenumber,net_revenue,avg_net_revenue_of_customer,order_rank,customer_running_total
0,15,2259001,0,2217.4064388,2217.4064388,1,2217.4064388
1,180,3162018,1,1913.5478819999996,836.7384189333333,1,2510.2152567999997
2,180,1305016,0,525.3105168000001,836.7384189333333,2,525.3105168000001
3,180,3162018,0,71.35685799999999,836.7384189333333,3,2510.2152567999997
4,185,1613010,0,1395.5234436,1395.5234436,1,1395.5234436
5,243,505008,0,287.66755741500003,287.66755741500003,1,287.66755741500003
6,387,1451007,0,1608.095632,517.3152850173778,1,2370.5407431904
7,387,2495044,0,1265.55637824,517.3152850173778,2,3636.0971214304
8,387,1451007,1,619.7706513503999,517.3152850173778,3,2370.5407431904
9,387,3242015,3,446.43712200000004,517.3152850173778,4,4655.8375651564
*/