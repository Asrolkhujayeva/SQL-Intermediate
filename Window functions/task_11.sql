-- Average customer llietime value by cohort year and LTV change


WITH yearly_cohort AS (
    SELECT
      customerkey,
      EXTRACT(YEAR FROM MIN(orderdate)) AS cohort_year,
      SUM(quantity * netprice * exchangerate) AS total_customer_net_revenue
    FROM sales
    GROUP BY customerkey
), cohort_summary AS (
    SELECT
        cohort_year,
        customerkey,
        total_customer_net_revenue as customer_ltv,
        AVG(total_customer_net_revenue) OVER(PARTITION BY cohort_year) AS avg_cohort_ltv
    FROM yearly_cohort
), cohort_final AS ( 
    SELECT DISTINCT
        cohort_year,
        avg_cohort_ltv
    FROM cohort_summary
    ORDER BY cohort_year
)

SELECT *,
    LAG(avg_cohort_ltv) OVER(ORDER BY cohort_year) AS prev_cohort_ltv,
    100 * (avg_cohort_ltv - LAG(avg_cohort_ltv) OVER(ORDER BY cohort_year))/LAG(avg_cohort_ltv) OVER(ORDER BY cohort_year) AS ltv_growth
FROM cohort_final



/*
index,cohort_year,avg_cohort_ltv,prev_cohort_ltv,ltv_growth
0,"""2015""",5271.586007033071,NaN,NaN
1,"""2016""",5404.922501737599,5271.586007033071,2.529343057793952
2,"""2017""",5403.081112115635,5404.922501737599,-0.034068751612488485
3,"""2018""",4896.6405350206,5403.081112115635,-9.373181090311876
4,"""2019""",4731.946341274057,4896.6405350206,-3.3634119672182505
5,"""2020""",3933.322655420792,4731.946341274057,-16.877276880494772
6,"""2021""",3943.3275100548367,3933.322655420792,0.25436140155591036
7,"""2022""",3315.5170142913107,3943.3275100548367,-15.920830673148817
8,"""2023""",2543.1796830373282,3315.5170142913107,-23.294627291154743
9,"""2024""",2037.5530153657592,2543.1796830373282,-19.88167297198983
*/

