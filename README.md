Olist Brazilian E-Commerce — End-to-End Data Analysis
Show Image Show Image Show Image Show Image

📌 Project Overview
An end-to-end data analyst portfolio project analysing 100,000+ orders from Olist, Brazil's largest e-commerce marketplace. This project covers the complete data analyst workflow — from raw data cleaning to SQL analysis to an interactive Power BI dashboard with actionable business insights.
Business Question: What patterns in revenue, customer behaviour, delivery performance and product satisfaction can help Olist grow and retain customers?

🗂️ Table of Contents

Dataset
Project Structure
Phase 1 — Data Cleaning
Phase 2 — SQL Analysis
Phase 3 — Power BI Dashboard
Phase 4 — Key Insights
Tools Used
How to Run
About Me


📦 Dataset
Source: Olist Brazilian E-Commerce on Kaggle
FileDescriptionRowsolist_orders_dataset.csvOrder status and timestamps99,441olist_order_items_dataset.csvProducts, price, freight112,650olist_customers_dataset.csvCustomer ID and location99,441olist_products_dataset.csvProduct categories32,951olist_sellers_dataset.csvSeller details3,095olist_order_payments_dataset.csvPayment type and value103,886olist_order_reviews_dataset.csvReview scores and text99,224olist_geolocation_dataset.csvZIP code coordinates1,000,163product_category_name_translation.csvPortuguese to English71

📁 Project Structure
olist-project/
│
├── data/
│   └── (all 9 raw CSV files from Kaggle)
│
├── notebooks/
│   └── 01_data_cleaning.ipynb
│
├── sql/
│   └── olist_queries.sql
│
├── outputs/
│   ├── olist_master.csv
│   ├── monthly_revenue.csv
│   ├── category_revenue.csv
│   ├── customer_by_state.csv
│   ├── delivery_vs_rating.csv
│   └── rating_distribution.csv
│
├── dashboard/
│   └── olist_dashboard.pbix
│   └── olist_dashboard.pdf
│   └── dashboard_preview.png
│
└── README.md

🧹 Phase 1 — Data Cleaning
Tool: Python · Pandas · Jupyter Notebook
Steps performed:

Loaded all 9 CSV files and inspected nulls, duplicates and data types
Handled missing delivery dates for cancelled and pending orders
Converted all date columns from string to datetime format
Extracted Year, Month, Month Name and Day of Week from timestamps
Calculated delivery_days as difference between purchase and delivery dates
Translated Portuguese category names to English
Merged all 9 tables into one master DataFrame
Removed cancelled orders from final dataset
Exported olist_master.csv with 99,441 rows and 28 columns

Result: Clean master table with less than 2% null values and zero duplicates

🗄️ Phase 2 — SQL Analysis
Tool: MySQL 8.0 · MySQL Workbench
18 queries written across 6 analysis categories:
CategoryQueriesRevenueTotal revenue, monthly trend, payment breakdownProductsTop categories, seller ranking, revenue shareCustomersOrders by state, repeat buyers, acquisition trendDeliveryOn-time rate, avg days, worst performing statesReviewsRating distribution, low rated categoriesAdvancedRunning total (SUM OVER), MoM growth (LAG), category rank (RANK)
Advanced SQL techniques used:

Window functions — SUM() OVER, LAG(), RANK()
Common Table Expressions (CTEs)
CASE WHEN for delivery speed bucketing
IFNULL() and DATE_FORMAT() for MySQL syntax


📊 Phase 3 — Power BI Dashboard
Tool: Power BI Desktop · DAX
4-page interactive dashboard with Warm Sand light theme
Page 1 — Overview

4 KPI cards (Revenue, Orders, Avg Order Value, Avg Review Score)
Monthly revenue line chart
Payment type donut chart
Top 8 categories bar chart
Review score distribution

Page 2 — Customer Analysis

4 KPI cards (Customers, Avg Spend, Repeat Buyers, Top State)
Brazil map — orders by state
Top 10 states bar chart
Customer type donut (one-time vs returning)
New customers per month line chart
Avg spend by state table

Page 3 — Delivery & Logistics

4 KPI cards (On-Time Rate, Avg Days, Late Orders, Within 1 Week)
Delivery speed vs rating column chart
On-time vs late donut chart
Worst states bar chart
Best states bar chart
Delivery days distribution

Page 4 — Product Performance

4 KPI cards (Top Category, Total Products, Top 5 Share, Lowest Rated)
Revenue by top 10 categories bar chart
Revenue share donut chart
Avg rating by category bar chart
Monthly revenue by top 5 categories line chart
Orders vs revenue table

DAX Measures Created:

Repeat Buyers %
On-Time Rate %
Avg Delivery Days
Late Orders
Within 1 Week %
Top 5 Category Share %
Top Category Name
Lowest Rated Category

Theme colours:

Background: #FAF7F2
Cards: #FFFFFF
Accent: #E07B39
Text: #2C1810
Muted: #A08060


💡 Phase 4 — Key Insights
Revenue

Total revenue: R$16.0 million across 2016–2018
Revenue grew by 137% from 2017 to 2018
November 2017 peak driven by Black Friday
74% of payments made by credit card

Customers

42% of all orders from São Paulo alone
97% of customers are one-time buyers — retention is critical
Customer acquisition grew by 68% in 2018
Only 3.1% of customers placed more than one order

Delivery

92.1% of orders delivered on time
Average delivery time: 12.1 days
Northern states average 26–29 days — 3.5x slower than São Paulo
Fast delivery (under 7 days) = 4.3 stars average rating
Slow delivery (over 30 days) = 2.8 stars average rating

Products

Health and Beauty is the top revenue category at R$1.4M
Top 5 categories = 52% of total revenue
Books rated highest at 4.6 stars
Security Services rated lowest at 2.9 stars


📋 Business Recommendations
PriorityRecommendation🔴 HighLaunch targeted Black Friday campaign — peak month drives 3x normal orders🔴 HighBuild customer retention programme — 97% never return after first purchase🔴 HighImprove logistics in northern states — 3.5x slower than São Paulo🟡 MediumExpand marketing in RJ and MG — strong second and third position states🟡 MediumInvestigate Security Services category — lowest rated at 2.9 stars🟢 LowPromote credit card instalment options — 74% already prefer credit

🛠️ Tools Used
ToolVersionPurposePython3.10Data cleaning and preprocessingPandas2.0DataFrame operationsMySQL8.0Database and SQL queriesSQLAlchemy2.0Python to MySQL connectionPyMySQL1.1MySQL driverPower BI DesktopLatestDashboard and visualisationDAX—Calculated measures and columnsJupyter Notebook—Python development environment

▶️ How to Run
Step 1 — Clone the repository
git clone https://github.com/yourusername/olist-analysis.git
cd olist-analysis
Step 2 — Install Python dependencies
pip install pandas numpy sqlalchemy pymysql jupyter
Step 3 — Download the dataset

Go to kaggle.com/datasets/olistbr/brazilian-ecommerce
Download and unzip all CSV files into the data/ folder

Step 4 — Run data cleaning

Open notebooks/01_data_cleaning.ipynb in Jupyter Notebook
Run all cells in order
olist_master.csv will be saved to outputs/

Step 5 — Set up MySQL

Install MySQL 8.0 and create database: CREATE DATABASE olist_db;
Update your password in the connection string
Run the Python cell in the notebook to load data into MySQL

Step 6 — Run SQL queries

Open MySQL Workbench and connect to olist_db
Open sql/olist_queries.sql
Run queries by section

Step 7 — Open the dashboard

Open dashboard/olist_dashboard.pbix in Power BI Desktop
Refresh data connection if prompted


👩‍💻 About Me
Fathima Sherin P
Data Analyst · Bengaluru, India

🎓 MSc AI, ML & Data Science — Yenepoya University
🎓 BSc Mathematics with Statistics — Calicut University
🏅 IBM Data Analyst Professional Certificate — Silver Medal 2024
💼 Data Analyst Intern — Camerin Innovate Pvt. Ltd.

Skills: Python · SQL · Power BI · Excel · Statistics · Data Cleaning · Dashboard Development
Other Projects:

Customer Behavior Analysis — SQL, Python, Excel (3,900+ records)
Global Digital Advertising Performance Dashboard — Power BI, Excel


📄 License
This project is open source and available under the MIT License.
