import pandas as pd
import sqlite3

# Database location
database_path = "data/superstore.db"

# Connect to SQLite
connection = sqlite3.connect(database_path)

# Load Orders table into pandas
orders = pd.read_sql_query(
    "SELECT * FROM orders",
    connection
)

# Convert date columns to datetime
orders["Order Date"] = pd.to_datetime(orders["Order Date"])
orders["Ship Date"] = pd.to_datetime(orders["Ship Date"])

connection.close()

# Close connection
connection.close()

# Display basic information
print("Dataset shape:", orders.shape)

print("\nColumns:")
print(orders.columns.tolist())

print("\nFirst 5 rows:")
print(orders.head())

print("\nMissing values:")
print(orders.isnull().sum())

print("\nDuplicate rows:")
print(orders.duplicated().sum())

print("\nData types:")
print(orders.dtypes)

# Basic business KPIs
total_sales = orders["Sales"].sum()
total_profit = orders["Profit"].sum()
total_quantity = orders["Quantity"].sum()
total_orders = orders["Order ID"].nunique()
total_customers = orders["Customer ID"].nunique()

print("\n--- Basic Business KPIs ---")
print(f"Total Sales: ${total_sales:,.2f}")
print(f"Total Profit: ${total_profit:,.2f}")
print(f"Total Quantity: {total_quantity:,}")
print(f"Total Orders: {total_orders:,}")
print(f"Total Customers: {total_customers:,}")

# Overall profit margin
profit_margin = (total_profit / total_sales) * 100

print(f"Overall Profit Margin: {profit_margin:.2f}%")

# Monthly sales and profit analysis
monthly_sales = (
    orders
    .groupby(orders["Order Date"].dt.to_period("M"))
    .agg(
        total_sales=("Sales", "sum"),
        total_profit=("Profit", "sum"),
        total_orders=("Order ID", "nunique")
    )
    .reset_index()
)

print("\n--- Monthly Sales and Profit ---")
print(monthly_sales.head(12))

# ============================================================
# 6. MONTHLY SALES AND PROFIT ANALYSIS
# ============================================================

monthly_sales = (
    orders
    .groupby(orders["Order Date"].dt.to_period("M"))
    .agg(
        total_sales=("Sales", "sum"),
        total_profit=("Profit", "sum"),
        total_orders=("Order ID", "nunique")
    )
    .reset_index()
)

print("\n--- Monthly Sales and Profit ---")
print(monthly_sales.head(12))


# ============================================================
# 7. BEST AND WORST SALES MONTHS
# ============================================================

best_sales_month = monthly_sales.loc[
    monthly_sales["total_sales"].idxmax()
]

worst_sales_month = monthly_sales.loc[
    monthly_sales["total_sales"].idxmin()
]

print("\n--- Sales Performance ---")

print("Best sales month:")
print(best_sales_month)

print("\nWorst sales month:")
print(worst_sales_month)

# Best and worst months by profit
best_profit_month = monthly_sales.loc[
    monthly_sales["total_profit"].idxmax()
]

worst_profit_month = monthly_sales.loc[
    monthly_sales["total_profit"].idxmin()
]

print("\n--- Profit Performance ---")

print("Best profit month:")
print(best_profit_month)

print("\nWorst profit month:")
print(worst_profit_month)

