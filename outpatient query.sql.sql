--Number of providers that offered services in 2011
SELECT COUNT(DISTINCT provider_id) FROM bigquery-public-data.medicare.outpatient_charges_2011;
--Total outpatient for each provider sorted in descending order
SELECT provider_name, SUM(outpatient_services) AS outpatient_services FROM bigquery-public-data.medicare.outpatient_charges_2011 GROUP BY provider_name ORDER BY outpatient_services DESC;
--Top 10 provider cities with the highest average total payments
SELECT provider_city, SUM(average_estimated_submitted_charges) AS average_total_payments FROM bigquery-public-data.medicare.outpatient_charges_2011 GROUP BY provider_city ORDER BY average_total_payments DESC LIMIT 10;
--Total average medicare payments for each provider
SELECT provider_name, SUM(average_total_payments) AS total_payments 
FROM bigquery-public-data.medicare.outpatient_charges_2011 GROUP BY provider_name ORDER BY total_payments;
/*Total outpatient services into categories; 100 and above as High, 50-99 as Medium, and 49 and below as Low*/
SELECT provider_name, provider_city, outpatient_services,
CASE
  WHEN outpatient_services >= 100 THEN "High"
  WHEN outpatient_services < 100 AND outpatient_services >= 50 
  THEN "Medium"
  ELSE "Low" END AS Discharge_flag
FROM bigquery-public-data.medicare.outpatient_charges_2011;
/*comparing the total outpatient services of providers that offered services in 2011 and 2012*/
SELECT m11.provider_name, SUM(m11.outpatient_services), m12.provider_name, SUM(m12.outpatient_services) FROM bigquery-public-data.medicare.outpatient_charges_2011 AS m11 JOIN bigquery-public-data.medicare.outpatient_charges_2012 AS m12 ON m11.provider_id=m12.provider_id GROUP BY m11.provider_name, m12.provider_name;
--List of providers that provided services in 2011 and 2012
SELECT DISTINCT a.provider_name, b.provider_name FROM bigquery-public-data.medicare.outpatient_charges_2011 a JOIN bigquery-public-data.medicare.outpatient_charges_2012 b ON a.provider_id=b.provider_id;
--List of providers that offered services in 2011 but not in 2012
SELECT DISTINCT y.provider_name, z.provider_name FROM bigquery-public-data.medicare.outpatient_charges_2011 AS y LEFT JOIN bigquery-public-data.medicare.outpatient_charges_2012 AS Z ON y.provider_id=z.provider_id WHERE z.provider_name IS NULL
--average total payments for each provider accross the 4 years
SELECT a.provider_name, SUM(a.average_total_payments) AS average_total_payments_2011, SUM(b.average_total_payments) AS average_total_payments_2012, SUM(c.average_total_payments) AS average_total_payments_2013, SUM(d.average_total_payments) AS average_total_payments_2014 FROM bigquery-public-data.medicare.outpatient_charges_2011 a JOIN bigquery-public-data.medicare.outpatient_charges_2012 b ON a.provider_id=b.provider_id JOIN bigquery-public-data.medicare.outpatient_charges_2013 c ON a.provider_id=c.provider_id JOIN bigquery-public-data.medicare.outpatient_charges_2014 d ON a.provider_id=d.provider_id GROUP BY a.provider_name;
--Merging 2011 and 2012 tables
SELECT * FROM bigquery-public-data.medicare.outpatient_charges_2011
UNION ALL
SELECT * FROM bigquery-public-data.medicare.outpatient_charges_2012 
