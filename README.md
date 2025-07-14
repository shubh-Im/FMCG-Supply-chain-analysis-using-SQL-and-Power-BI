# 📦 FMCG Supply Chain Service-Level Analysis | AtliQ Mart

This project analyzes the supply chain service performance of AtliQ Mart, a growing FMCG company in India, to uncover root causes behind customer dissatisfaction and contract non-renewals. Using SQL and Power BI, the project focuses on key service KPIs—**On-Time (OT%)**, **In-Full (IF%)**, and **On-Time In-Full (OTIF%)**—to track delivery performance and recommend improvements before business expansion.

---

## 🔶 Problem Statement

AtliQ Mart, headquartered in Gujarat, is operational in Surat, Ahmedabad, and Vadodara. Recently, some key customers did not renew their annual contracts due to poor service—particularly late deliveries and incomplete orders. 

To address this, the supply chain team decided to monitor the following KPIs for each customer on a daily basis:
- **OT% (On-Time Delivery)**
- **IF% (In-Full Delivery)**
- **OTIF% (On-Time In-Full Delivery)**

This analysis aims to track service performance, identify inefficiencies, and enable data-driven decision-making for future growth.

---

## 🚀 Approach

- Utilized **SQL** to clean, transform, and aggregate order data from multiple relational tables.
- Created calculated KPIs and targets at customer and order line levels.
- Used **Power BI** to:
  - Build custom **DAX measures** and calculated columns.
  - Design a **user-friendly, interactive dashboard** for quick insights and drill-downs.
- Focused the analysis on actionable insights to guide improvements in supply chain operations and customer service.

---

## 🧰 Tools & Technologies

- **SQL** – Data cleaning, transformation, KPI calculations
- **Power BI** – Data modeling, visualization, interactive dashboard creation
- **DAX** – Custom metrics and calculations within Power BI

---

## 📊 Dashboard Highlights

- KPI cards showing OT%, IF%, OTIF% vs target
- Month-wise performance trends
- City-level and product-level breakdowns
- Bottleneck identification by customer and SKU
- Filter by region, customer, and product categories

<img width="1749" height="902" alt="Screenshot 2025-07-13 101443" src="https://github.com/user-attachments/assets/d9d9dd41-a736-48cf-bc58-34cf578db62d" />
<img width="1391" height="784" alt="Screenshot 2025-07-13 103543" src="https://github.com/user-attachments/assets/fc1e7a9d-b05b-4948-bbf1-7496103f849f" />
<img width="1397" height="782" alt="Screenshot 2025-07-13 103217" src="https://github.com/user-attachments/assets/d1bf4d9c-4494-461e-9dd0-1ed3cac4593b" />


---

## 📌 Insights & Findings

- **Performance Gaps**: OT%, IF%, and OTIF% are below target for many customers.
- **City-wise Performance**: Vadodara performs the worst, followed by Ahmedabad; Surat is the best.
- **Client Rankings**: "Propel Mart" has the best OTIF; "Cool Blue Mart" and "Acclaimed Stores" perform the worst.
- **Product Insights**: 
  - "AM Butter 500" is highly demanded.
  - "AM Biscuits 750" has the highest LIFR, indicating reliability in quantity.
  - VOFR is consistent across most products.
- **Category-Wise Issues**: Dairy products have high undelivered quantities and low fulfillment performance.
- **Monthly Trends**: May recorded the highest deliveries, while August had the lowest.

---

## ✅ Proposed Solutions

### 1. Improve On-Time Deliveries
- Eliminate bottlenecks across supply chain stages.
- Improve coordination with transport and warehouse partners.
- Use predictive analytics for proactive delay management.

### 2. Enhance In-Full Deliveries
- Optimize inventory to match demand forecasts.
- Implement real-time inventory tracking.

### 3. Focus on City-Specific Performance
- Prioritize service improvements in Vadodara and Ahmedabad.
- Conduct root cause analysis for poor regional performance.

### 4. Tailor Client-Focused Strategies
- Develop personalized service improvements for key clients.
- Address service lapses for "Cool Blue Mart" and "Acclaimed Stores".

### 5. Optimize Product Supply Chains
- Ensure continuous supply for high-demand items like "AM Butter 500".
- Investigate supply gaps in products like "AM Ghee 100".

### 6. Category & Line-Level Optimization
- Apply best practices from high-performing product lines to others.
- Conduct in-depth analysis of Dairy category and fix inefficiencies.

### 7. Manage Seasonal Demand
- Investigate demand variation between May and August.
- Develop flexible supply plans to handle seasonality.

---


