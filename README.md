# 📊 Blinkit Sales Insights – SQL Analytics Project

This project is a comprehensive SQL-based analysis of a fictional Blinkit dataset, designed to explore trends in retail performance, customer behavior, and sales patterns. The queries uncover insights such as sales efficiency, rating inconsistencies, outlet performance over time, and much more.

---

## 📁 Dataset Overview

The dataset `blinkit_data` contains structured information on various product attributes and outlet metrics including:

- `Item_Identifier`, `Item_Type`, `Item_Fat_Content`
- `Outlet_Identifier`, `Outlet_Type`, `Outlet_Size`, `Outlet_Location_Type`, `Outlet_Establishment_Year`
- `Item_Visibility`, `Item_Weight`, `Sales`, `Rating`

---

## 🛠️ Skills & Concepts Used

- SQL Aggregations & Grouping
- Window Functions
- CTEs (Common Table Expressions)
- Case Statements
- Ranking Functions (`RANK()`, `ROW_NUMBER()`, `NTILE`)
- Percentile Analysis using `PERCENTILE_CONT`
- Data Cleaning & Transformation

---

## 🔍 Key Insights & Business Questions

### 1. 🧹 Data Cleaning
- Standardized values for `Item_Fat_Content` (`low fat`, `LF`, `reg` → `Low Fat`, `Regular`).

---

### 2. 💰 Sales Metrics
- **Total Sales in Millions**
- **Average Sales**
- **Total Number of Items by Year**
- **Sales & Ratings by Fat Content & Item Type**

---

### 3. 📍 Outlet Performance
- **Sales, Ratings, and Distribution by:**
  - Outlet Type
  - Outlet Size
  - Outlet Establishment Year
  - Outlet Location Type

---

### 4. 🥇 Top Products by Location
Identify top 3 selling item types in each outlet location type along with their contribution to total sales in that location.

---

### 5. 📈 Sales Efficiency by Visibility
Divide products into 4 quantiles based on visibility and analyze how visibility influences sales and item ratings. 
> **Insight:** Higher visibility doesn't always translate to better performance.

---

### 6. 🏪 Outlet Age vs Performance
Analyzes how outlet age (grouped as 0–5, 6–10, 10+ years) affects:
- Average Sales
- Average Ratings
- Most common outlet type per age bucket

---

### 7. 🎯 High Sales but Low Ratings
Identify products with top 10% sales but below-average ratings.
> **Use case:** Detect products that are popular but underperform in customer satisfaction — ideal for quality audits or marketing adjustments.

---

## 📂 Project Structure

- `blinkit_analysis.sql`: Main query file with all insights
- `README.md`: Documentation and explanation

---

## 📌 How to Use

1. Import the dataset into your local SQL environment (PostgreSQL, MySQL, or compatible engine).
2. Run the queries in the provided order for a full walkthrough of insights.
3. You can further visualize the results using tools like Power BI, Tableau, or Python notebooks.

---

## 🔧 Tools Used

- SQL (Tested on PostgreSQL)
- DBMS: Any supported engine
- GitHub for version control

---

## 📚 Future Improvements

- Visual dashboards with Power BI / Tableau
- ML model to predict sales based on outlet and product features
- Integration with real-time APIs for inventory tracking

---

## 🤝 Connect

Feel free to fork, explore, and contribute to improve this analysis!  
If you'd like to collaborate or discuss enhancements:

📬 [LinkedIn](https://www.linkedin.com/in/nehasharma2103)  

---

## ⭐ If you found this helpful, give this repo a star!

