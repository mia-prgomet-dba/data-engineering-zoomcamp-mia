# Loading the data
 ```
--Create an external table using the Yellow Taxi Trip Records.
CREATE OR REPLACE EXTERNAL TABLE `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://mia-workflow-kestra/yellow_tripdata_2024-*.parquet']
);
```

# Create a (regular/materialized) table in BQ using the Yellow Taxi Trip Records (do not partition or cluster this table).
```
CREATE OR REPLACE TABLE `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24_nonpartitioned` AS
SELECT * FROM `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24`;
```

# Question 1. Counting records
## What is count of records for the 2024 Yellow Taxi Data?

 20,332,093

# Question 2. Data read estimation
## Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
## What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

```
SELECT DISTINCT(PULocationID)
FROM `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24`;
```

```SELECT DISTINCT(PULocationID)
FROM `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24_nonpartitioned`;
```
0 MB for the External Table and 155.12 MB for the Materialized Table

# Question 3. Understanding columnar storage
## Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID on the same table.
```
SELECT PULocationID
FROM `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24_nonpartitioned`;

SELECT PULocationID, DOLocationID
FROM `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24_nonpartitioned`;
```
## Why are the estimated number of Bytes different?

BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data
than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

# Question 4. Counting zero fare trips
## How many records have a fare_amount of 0?

8,333

# Question 5. Partitioning and clustering
## What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

Partition by tpep_dropoff_datetime and Cluster on VendorID

```
CREATE OR REPLACE TABLE  `workflow-orchestration-mia.zoomcamp.yellow_tripdata_partitioned_clustered_01-06-2024`
PARTITION BY
  DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24`;
```
# Question 6. Partition benefits
## Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)
## Use the materialized table you created earlier in your from clause and note the estimated bytes. Now change the table in the from clause to the partitioned table you created for question 5 and note the 
## estimated bytes processed. What are these values?
```
SELECT DISTINCT(VendorID)
FROM `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24_nonpartitioned`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT(VendorID)
FROM `workflow-orchestration-mia.zoomcamp.yellow_tripdata_partitioned_clustered_01-06-2024`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
```

310.24 MB for non-partitioned table and 26.84 MB for the partitioned table

# Question 7. External table storage
## Where is the data stored in the External Table you created?

Big Query

# Question 8. Clustering best practices
## It is best practice in Big Query to always cluster your data:

False

# Question 9. Understanding table scans
## No Points: Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
```
SELECT COUNT(*)
FROM `workflow-orchestration-mia.zoomcamp.external_yellow_tripdata_01-06-24_nonpartitioned`
```
Big Query has cache. That's the reason why system don't have to read data again. If there is no updates to the table, system already has prepared data from metadata since the table was created.

