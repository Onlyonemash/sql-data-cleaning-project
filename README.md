# SQL Data Cleaning & Exploratory Data Analysis Project

## Project Overview

This project focuses on cleaning and analysing a real-world global layoffs dataset using SQL in MySQL Workbench.

The project was divided into two main stages:

1. Data Cleaning
2. Exploratory Data Analysis (EDA)

The dataset contained duplicates, inconsistent formatting, null values, and unstructured data that required cleaning before analysis could be performed.

After cleaning the dataset, exploratory analysis was conducted to identify trends, patterns, and insights related to layoffs across industries, countries, companies, and time periods.

---

## Dataset Source

Kaggle:
https://www.kaggle.com/datasets/swaptr/layoffs-2022

---

## Tools Used

- MySQL Workbench
- SQL
- GitHub

---

## Skills Demonstrated

- Data Cleaning
- Exploratory Data Analysis
- SQL Queries
- Common Table Expressions (CTEs)
- Window Functions
- ROW_NUMBER()
- DENSE_RANK()
- Aggregate Functions
- JOINs
- Date Functions
- Rolling Calculations
- Data Standardisation
- Handling Null Values

---

## Data Cleaning Tasks

- Created staging tables to preserve raw data
- Removed duplicate records
- Standardised inconsistent values
- Converted date formats
- Handled null and blank values
- Removed unnecessary rows and columns

---

## Exploratory Data Analysis Tasks

- Analysed layoffs by company, country, industry, and year
- Identified companies with the highest layoffs
- Calculated rolling monthly layoff totals
- Ranked top companies by layoffs per year
- Explored trends and outliers in the dataset

---

## Project Files

### data_cleaning.sql
Contains all SQL queries used for cleaning and transforming the raw dataset.

### exploratory_data_analysis.sql
Contains SQL queries used for exploratory data analysis and trend identification.

---

## Key SQL Concepts Used

- CTEs
- Window Functions
- ROW_NUMBER()
- DENSE_RANK()
- GROUP BY
- Aggregate Functions
- CASE Statements
- JOINs
- STR_TO_DATE()
- DATE_FORMAT()

---

## Example Insights

- The United States recorded the highest number of layoffs in the dataset.
- Several startups experienced 100% workforce layoffs.
- Layoffs increased significantly during 2022.
- Certain industries experienced disproportionately high workforce reductions.
