Question 1. Understanding Docker images

Run docker with the `python:3.13` image. Use an entrypoint `bash` to interact with the container.

docker run -it --entrypoint bash python:3.13

What's the version of `pip` in the image?
pip 26.2.1

## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that pgadmin should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

- db:5432


## Prepare the Data
Data ingestion was executed using the `notebook.py` script.

## Question 3. Counting short trips

For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a `trip_distance` of less than or equal to 1 mile?

select count(*)
from green_tripdata_2025_11
where lpep_pickup_datetime >= '2025-11-01' 
		and  lpep_pickup_datetime < '2025-12-01' 
		and trip_distance <= 1;

- 8,007

## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Only consider trips with `trip_distance` less than 100 miles (to exclude data errors).

Use the pick up time for your calculations.

SELECT 
    DATE(lpep_pickup_datetime) AS pickup_day,
    MAX(trip_distance) AS longest_distance
FROM green_tripdata_2025_11
WHERE trip_distance < 100
GROUP BY DATE(lpep_pickup_datetime)
ORDER BY longest_distance DESC
LIMIT 1;

- 2025-11-14

## Question 5. Biggest pickup zone

Which was the pickup zone with the largest `total_amount` (sum of all trips) on November 18th, 2025?

SELECT "Zone",
		SUM(total_amount) AS total
FROM green_tripdata_2025_11 g
INNER JOIN taxi_zones ON g."PULocationID" = taxi_zones."LocationID"
WHERE DATE(g.lpep_pickup_datetime) = '2025-11-18'
GROUP BY "Zone"
ORDER BY total DESC
LIMIT 1;

- East Harlem North


## Question 6. Largest tip

For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

Note: it's `tip` , not `trip`. We need the name of the zone, not the ID.

SELECT tdz."Zone", MAX(tip_amount) AS total_tip
FROM green_tripdata_2025_11 gt
INNER JOIN taxi_zones t ON gt."PULocationID" = t."LocationID"
INNER JOIN taxi_zones tdz ON gt."DOLocationID" = tdz."LocationID"
WHERE t."Zone" = 'East Harlem North' AND DATE_TRUNC('month', gt.lpep_pickup_datetime) = '2025-11-01'
GROUP BY tdz."Zone"
ORDER BY total_tip DESC
LIMIT 1;


- Yorkville West

## Terraform

## Question 7. Terraform Workflow

Which of the following sequences, respectively, describes the workflow for:
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

- terraform init, terraform apply -auto-approve, terraform destroy
