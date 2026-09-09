# E-Commerce Sales & Customer Intelligence Analytics

An end-to-end data analytics project analyzing e-commerce sales, profitability, customers, products, regions, discounts, and returns using **SQL, Python, and Power BI**.

The goal of this project is to transform raw transactional data into actionable business insights and demonstrate a complete analytics workflow from data preparation to dashboarding.

---

## Project Overview

This project analyzes the **Tableau Sample Superstore** dataset to answer key business questions around:

* Sales and profit performance
* Customer value and profitability
* Customer segmentation
* Repeat purchasing behavior
* Product and category performance
* Regional performance
* Discount and profitability relationships
* Returns
* Historical Customer Lifetime Value (CLV)

### Analytics Workflow

```text
Raw Dataset
     ↓
SQLite Database
     ↓
SQL Analysis
     ↓
Python Analysis & Data Export
     ↓
Power BI Dashboard
     ↓
Business Insights & Recommendations
```

---

## Tech Stack

| Tool         | Purpose                                       |
| ------------ | --------------------------------------------- |
| Python       | Data loading, validation, analysis and export |
| Pandas       | Data manipulation and analysis                |
| SQLite       | Analytical database                           |
| SQL          | Business analysis and KPI calculations        |
| Power BI     | Interactive dashboard and visualization       |
| Git & GitHub | Version control and portfolio management      |

---

## Dataset

The project uses the **Tableau Sample Superstore** dataset.

The dataset contains:

* `Orders` — transactional sales data
* `Returns` — returned orders
* `People` — regional manager information

The main `Orders` table contains **10,194 rows and 21 columns**.

Important fields include:

* Order ID
* Order Date
* Ship Date
* Customer ID
* Customer Name
* Segment
* Region
* Category
* Sub-Category
* Product Name
* Sales
* Quantity
* Discount
* Profit

Returns are connected to orders using `Order ID`.

---

## Key Business KPIs

Across the observed dataset:

| KPI                   |         Value |
| --------------------- | ------------: |
| Total Sales           | $2,326,534.35 |
| Total Profit          |   $292,296.81 |
| Total Quantity        |        38,654 |
| Total Orders          |         5,111 |
| Total Customers       |           804 |
| Overall Profit Margin |        12.56% |
| Return Rate           |         5.79% |
| Repeat Customer Rate  |        98.51% |

---

## SQL Analysis

SQL was used to perform the core business analysis inside SQLite.

Major analyses include:

### Sales Analysis

* Monthly sales and profit
* Yearly sales and profit
* Year-over-year growth
* Profit margin
* Order trends

### Customer Analysis

* Top customers by sales
* Top customers by profit
* Negative-profit customers
* Average order value
* Customer RFM segmentation
* Repeat customer analysis
* Historical CLV

### Product Analysis

* Category performance
* Sub-category performance
* Product profitability
* Loss-making products
* Discount analysis

### Regional Analysis

* Regional sales
* Regional profit
* Regional profit margins
* Region × category performance

### Returns Analysis

* Overall return rate
* Regional return rate
* Category return analysis
* Sub-category return analysis

---

## Python Analysis

Python was used for data validation, exploratory analysis and preparing data for Power BI.

The Python workflow includes:

1. Loading data from SQLite
2. Converting date columns
3. Checking dataset shape
4. Checking missing values
5. Checking duplicates
6. Calculating business KPIs
7. Performing monthly sales and profit analysis
8. Identifying best and worst performing months
9. Exporting SQLite tables to CSV for Power BI

### Python Validation Results

* Dataset shape: `10,194 × 21`
* Missing values: `0`
* Duplicate rows: `0`

Python also identified:

* Best sales month: **November 2026**
* Worst sales month: **February 2023**
* Best profit month: **December 2025**
* Worst profit month: **January 2024**

An important observation was that the month with the highest sales was not the month with the highest profit.

---

## Customer Intelligence

Customer analysis was performed using RFM segmentation and historical CLV.

### RFM Segmentation

RFM stands for:

* **Recency** — how recently a customer purchased
* **Frequency** — how often a customer purchased
* **Monetary** — how much a customer spent

The analysis segmented 804 customers into:

| Segment           | Customers |
| ----------------- | --------: |
| Regular Customers |       187 |
| Lost Customers    |       157 |
| Big Spenders      |       155 |
| Loyal Customers   |       123 |
| Champions         |       114 |
| At Risk           |        68 |

The segmentation highlights opportunities for customer retention, reactivation and high-value customer engagement.

### Repeat Purchasing

**792 of 804 customers** placed more than one order during the observed period.

This results in a repeat customer rate of approximately:

**98.51%**

This metric represents repeat purchasing across the full observed dataset rather than a specific retention cohort.

### Historical CLV

Historical CLV was calculated as a **sales-based historical proxy**, rather than a predictive CLV model.

This approach was chosen because the dataset does not contain information such as:

* Customer acquisition cost
* Retention cost
* Expected customer lifespan
* Future purchase probability

A key finding was that the highest-revenue customer was not necessarily the most profitable customer.

For example, **Sean Miller** generated approximately $25K in sales but had negative total profit, while **Tamara Chand** generated approximately $19K in sales with approximately $9K in profit.

---

## Product & Category Insights

### Category Performance

| Category        |   Sales |  Profit | Profit Margin |
| --------------- | ------: | ------: | ------------: |
| Technology      | $839.9K | $146.5K |        17.45% |
| Furniture       | $754.7K |  $19.7K |         2.61% |
| Office Supplies | $731.9K | $126.0K |        17.22% |

### Key Insight

Furniture generates sales comparable to Technology and Office Supplies, but its profitability is significantly weaker.

Further analysis showed that:

* Tables had an approximately **-8.53%** profit margin
* Bookcases had an approximately **-3.15%** profit margin
* Machines had an approximately **1.82%** profit margin

This indicates that revenue alone is not sufficient for evaluating product performance.

---

## Discount & Profitability

The analysis found a strong association between higher discount levels and weaker profitability.

Examples:

* 0% discount → approximately 29.56% profit margin
* 30% discount → approximately -10.06%
* 50% discount → approximately -34.80%
* 80% discount → approximately -180.01%

These results show that heavily discounted transactions can be associated with substantial profitability pressure.

This analysis describes an **association, not causation**.

---

## Regional Performance

| Region  |   Sales |  Profit | Margin |
| ------- | ------: | ------: | -----: |
| West    | $739.8K | $110.8K | 14.98% |
| East    | $691.8K |  $94.9K | 13.71% |
| South   | $391.7K |  $46.7K | 11.93% |
| Central | $503.2K |  $39.9K |  7.92% |

### Key Insight

The **Central region** has a relatively weak profit margin compared with the other regions.

Central Furniture was particularly weak:

* Sales: approximately $164.5K
* Profit: approximately -$2.8K
* Margin: approximately -1.70%

---

## Returns Analysis

The overall return rate was:

**5.79%**

Regional return rates:

| Region  | Return Rate |
| ------- | ----------: |
| West    |      11.56% |
| Central |       3.31% |
| East    |       2.98% |
| South   |       2.92% |

At the sub-category level, some of the highest return rates included:

* Machines — 11.40%
* Tables — 9.55%
* Appliances — 8.71%
* Phones — 8.60%

Return counts across categories/subcategories are not mutually exclusive because a single returned order can contain multiple categories or subcategories.

---

## Power BI Dashboard

The Power BI dashboard is being developed to provide an executive-friendly view of the analysis.

Current dashboard elements include:

### Executive Overview

* Total Sales
* Total Profit
* Total Orders
* Total Customers
* Overall Profit Margin
* Monthly Sales Trend
* Monthly Profit Trend
* Sales & Profit by Category
* Sales & Profit by Region
* Profit Margin by Category

### Customer Intelligence

Planned analysis includes:

* Top customers
* Customer profitability
* RFM segmentation
* Customer value
* Repeat purchasing
* Historical CLV

The Power BI file is located in:

```text
power bi/ecommerce_sales_intelligence.pbix
```

---

## Project Structure

```text
ecommerce-sales-intelligence/
│
├── data/
│   ├── raw/
│   │   └── sample_-_superstore.xls
│   │
│   └── processed/
│       ├── orders.csv
│       └── returns.csv
│
├── sql/
│   ├── 01_sales_analysis.sql
│   └── 02_customer_analysis.sql
│
├── python/
│   ├── load_data.py
│   ├── run_sql.py
│   ├── analysis.py
│   └── export_data.py
│
├── power bi/
│   └── ecommerce_sales_intelligence.pbix
│
├── screenshots/
│
├── README.md
└── .gitignore
```

---

## How to Run the Project

### 1. Clone the repository

```bash
git clone https://github.com/tankidunki/ecommerce-sales-intelligence.git
cd ecommerce-sales-intelligence
```

### 2. Create a virtual environment

```bash
python -m venv .venv
```

Activate it on Windows:

```powershell
.venv\Scripts\Activate.ps1
```

### 3. Install dependencies

```bash
python -m pip install pandas xlrd
```

### 4. Load the dataset into SQLite

```bash
python python/load_data.py
```

This creates:

```text
data/superstore.db
```

### 5. Run SQL analysis

Example:

```bash
python python/run_sql.py sql/01_sales_analysis.sql
```

or:

```bash
python python/run_sql.py sql/02_customer_analysis.sql
```

### 6. Run Python analysis

```bash
python python/analysis.py
```

### 7. Export data for Power BI

```bash
python python/export_data.py
```

This creates:

```text
data/processed/orders.csv
data/processed/returns.csv
```

### 8. Open the Power BI dashboard

Open:

```text
power bi/ecommerce_sales_intelligence.pbix
```

---

## Business Recommendations

Based on the analysis:

### 1. Investigate Furniture profitability

Furniture produces substantial revenue but has a significantly lower profit margin than Technology and Office Supplies.

Management should investigate pricing, discounting and product-level profitability within Furniture.

### 2. Review high-value but unprofitable customers

Some customers generate significant revenue while producing negative profit.

Customer-level profitability should therefore be considered alongside revenue when designing retention or promotional strategies.

### 3. Review high-discount transactions

Higher discount levels are associated with substantially weaker profitability.

Discount policies should be reviewed to understand where promotions are eroding margins.

### 4. Investigate Central-region performance

The Central region has the weakest overall profit margin.

Central Furniture is especially important for further investigation.

### 5. Monitor high-return products

Products and subcategories with high return rates should be investigated for potential product, fulfillment or customer-experience issues.

---

## Limitations

This project has several analytical limitations:

* The dataset does not contain a direct cost column.
* Profitability is therefore based on the provided `Profit` field.
* Historical CLV is a sales-based proxy rather than predictive CLV.
* RFM segment definitions are analyst-defined.
* Repeat customer rate is calculated over the full observed period and is not a cohort-based retention metric.
* Return analysis is based on returned orders and does not establish the reason for returns.
* Relationships between discounts and profitability are observational and should not be interpreted as causal without further analysis.

---

## Future Improvements

Potential future enhancements include:

* Predictive customer churn modeling
* Predictive CLV
* Customer cohort retention analysis
* Product-level return impact analysis
* Automated Power BI data refresh
* More advanced customer segmentation
* Profitability forecasting
* Statistical testing of discount and profitability relationships

---

## Author

**Tanishk**

Data Analytics Portfolio Project

**Skills demonstrated:** SQL • Python • Pandas • SQLite • Power BI • Data Visualization • Business Analysis • Git/GitHub

