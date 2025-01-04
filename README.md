# Retail Sector Analysis Project

## Description
This project analyzes trends, consumer behavior, and market dynamics within the retail sector. It aims to provide insights that help businesses optimize strategies, improve customer engagement.

Key focuses include:
- **Consumer Behavior**: Analyzing purchasing patterns.
- **Market Segmentation**: Identifying customer segments.
- **Sales Forecasting**: Predicting future sales trends.
- **Product Analysis**: Assessing product performance.

The project applies data analysis to uncover actionable insights.

## Technologies Used
- MySQL Workbench

## Data Sources
- **Retail customer profile Dataset**: Provided by Coding Ninjas. The dataset is available [click here](https://github.com/akbirla1/retail_analysis/blob/main/data/sql_p_retail_customer_profiles.sql)
- **Retail products Dataset**: Provided by Coding Ninjas. The dataset is available [click here](https://github.com/akbirla1/retail_analysis/blob/main/data/sql_p_retail_product_inventory.sql)
- **Retail sales Dataset**: Provided by Coding Ninjas. The dataset is available [click here](https://github.com/akbirla1/retail_analysis/blob/main/data/sql_p_retail_sales_transaction.sql)

## Installation Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/akbirla1/retail_analysis
   
2. Create a new database in Mysql:
CREATE DATABASE retail_analysis;

3.Import the SQL files into Mysql:
mysql -u username -p retail_analysis < data/sql_p_retail_customer_profiles.sql
mysql -u username -p retail_analysis < data/sql_p_retail_product_inventory.sql
mysql -u username -p retail_analysis < data/sql_p_retail_sales_transaction.sql

