import pandas as pd
import sqlite3

# Database location
database_path = "data/superstore.db"

# Connect to SQLite
connection = sqlite3.connect(database_path)

# Load tables from SQLite
orders = pd.read_sql_query("SELECT * FROM orders", connection)
returns = pd.read_sql_query("SELECT * FROM returns", connection)

# Close connection
connection.close()

# Export to CSV
orders.to_csv(
    "data/processed/orders.csv",
    index=False
)

returns.to_csv(
    "data/processed/returns.csv",
    index=False
)

print(f"Exported {len(orders):,} rows to orders.csv")
print(f"Exported {len(returns):,} rows to returns.csv")