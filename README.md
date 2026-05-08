# SQL Data Cleaning Project – Layoffs Dataset (2022)

## Project Overview
This project focuses on cleaning and transforming a real-world layoffs dataset using SQL.  
The dataset contains information about company layoffs across different industries and countries.

The goal of this project was to simulate a real data analyst workflow by preparing raw data for analysis through structured SQL cleaning techniques.

---

## 📊 Dataset Source
- Kaggle

---

## 🛠 Tools Used
- MySQL Workbench

---

## 📈 Skills Demonstrated
- Data cleaning in SQL
- Handling duplicates using ROW_NUMBER() and CTEs
- Data standardisation (industry, country fields)
- Handling null values
- Date conversion using STR_TO_DATE()
- Using UPDATE, DELETE, ALTER TABLE
- Staging tables for safe data transformation

---

## 🧹 Data Cleaning Process

### 1. Data Exploration
- Loaded raw dataset
- Created staging table to preserve original data

### 2. Removing Duplicates
- Used ROW_NUMBER() with partitioning
- Identified and removed duplicate records

### 3. Standardising Data
- Cleaned industry values (e.g. Crypto variations)
- Removed trailing punctuation in country names
- Filled missing industry values where possible

### 4. Handling Dates
- Converted string date format into proper DATE type
- Standardised format for analysis readiness

### 5. Cleaning Null Values
- Removed rows with no meaningful layoff data

### 6. Final Cleanup
- Removed helper columns used during transformation

---

## Key Outcome
This project demonstrates how raw, messy data can be transformed into a structured dataset ready for analysis using SQL.

---

## Next Steps
- Build visual dashboard using Power BI
- Perform exploratory data analysis (EDA)
- Identify trends in layoffs by industry and time
