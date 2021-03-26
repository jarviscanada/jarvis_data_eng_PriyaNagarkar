# Linux Cluster Monitoring Agent
## Introduction
The Linux Cluster Monitoring Agent (LCMA) is a tool designed to monitor and collect data from host machines over a network using IPv4 addresses; this includes hardware specifications, activity, and performance of Linux machines within a cluster. This data is stored in a PostgreSQL (psql) Relational Database Management System (RDBMS) and uses Docker containers. Docker is used to keep consistency between nodes/ servers.  All the nodes in the cluster have the bash scripts which collects the hardware specifications and usage data and sends it to the database; the CPU usage data is sent every one minute which is scheduled using crontab to get the real time data for real time analysis. The collected data is used to provide statistics for better business decisions and resource planning. 

## Quick Start
- Provision a docker psql instance on host computer by executing psql_docker.sh.

   bash ./scripts/psql_docker.sh create|start|stop [username] [password]
   
- Create tables which will contain the hardware specifications and resource usages using ddl.sql.

   psql -h localhost -U [username] -d [database] -f sql/ddl.sql
   
- Collect and insert host device hardware info into the host_info table.

   bash ./scripts/host_info.sh localhost 5432 [database] [username] [password]
   
- Collect and insert host device cpu/memory usage into the host_usage table.

   bash ./scripts/host_usage.sh localhost 5432 [database] [username] [password]
   
- Automate the host_usage.sh script with crontab CLI tool.

    Open crontab job file
    crontab -e
    Add this task to the list and save
     * * * * * bash [full_directory_path]/host_usage.sh localhost 5432 [database] [username] [password] > /tmp/host_usage.log
    
## Implementation
- A psql_docker.sh script creates a psql container using docker to host the postgreSQL database in the monitoring agent node where the other nodes are connected by switch through IPv4.
- The database host_agent was then setup using PostgreSQL command line interface using DDL SQL queries. Using ddl.sql the tables host_info and host_usage were created in the host_agent database for storing hardware specifications and CPU and memory usage information respectively.
- The bash scripts were created for automation purposes, host_info is created to insert host hardware information into the host_info table and host_usage script is created to insert host resource usage data into host_usage table.
- The queries.sql using DML SQL queries was created to retrieve information from the two tables to help answer the business question for better resource planning.
## Architecture
![New Chart](https://user-images.githubusercontent.com/80492218/112588113-3ca61580-8dd5-11eb-932a-6a6249710acf.JPG)

## Scripts
 
- psql_docker.sh - is used to create a docker container or start/stop a container if one already exists
- host_info.sh - is used to get hardware configuration data of the host and then insert the data into the database.
- host_usage.sh - is used to collect usage of resources. This is run every minute using crontab.
- crontab - is used to get the script to run every minute, i.e. crontab jobs run certain scripts repeatedly within the given time.
- ddl.sql - is used to create the database tables needed for the host_agent database, that is, creation of the two tables host_info and host_usage.
- queries.sql - is used to get information on the cluster and manage the different data from usage for future enterprise planning. The queries.sql is used to resolve business issues by the information it collects: 
              i. It is used to find out which host has the most memory. 
              ii. It also helps find out the average memory used every 5 minutes. 
              iii. This also helps detect failure of the node if it inserts less than three data points within 5-min intervals.

## Database Modeling
host_info Table

| Columns | Values |
| --- | ---|
| id |SERIAL NOT NULL PRIMARY KEY |
| hostname | VARCHAR NOT NULL UNIQUE |
| cpu_number | INT NOT NULL |
| cpu_architecture | VARCHAR NOT NULL |
| cpu_model | VARCHAR NOT NULL |
| cpu_mhz | FLOAT NOT NULL |
| L2_cache | VARCHAR NOT NULL |
| total_mem | INT NOT NULL |
| timestamp |TIMESTAMP NOT NULL |


 
host_usage Table
 
| Columns | Values |
| -- | -- |
| timestamp |TIMESTAMP NOT NULL PRIMARY KEY |
| host_id | INT NOT NULL REFERENCES host_info(id) |
| memory_free | INT NOT NULL |
| cpu_idle | INT NOT NULL |
| cpu_kernel | INT NOT NULL |
| disk_io | INT NOT NULL |
| disk_available | VARCHAR NOT NULL |

 
## Test
- The bash scripts were tested manually using command line to ensure the proper functioning of the scripts by verifying the number of arguments, expected errors got displayed and the exit code was successful.
- The SQL queries were tested using test data to ensure the expected results were displayed.

## Improvements
- Add GUI so that resource utilization will be easy to interpret. 
- Set up varying threshold values according to issue severity.
