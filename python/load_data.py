import pandas as pd
import sqlite3

# File locations
file_path = "data/raw/sample_-_superstore.xls"
database_path = "data/superstore.db"

# Read Orders sheet
orders = pd.read_excel(
    file_path,
    sheet_name="Orders"
)

# Connect to SQLite database
connection = sqlite3.connect(database_path)

# Load data into SQLite
orders.to_sql(
    "orders",
    connection,
    if_exists="replace",
    index=False
)

# Close connection
connection.close()

print(f"Loaded {len(orders):,} rows into the orders table.")