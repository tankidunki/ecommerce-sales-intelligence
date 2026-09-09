import sqlite3
import sys

database_path = "data/superstore.db"

# Get SQL file from command line
if len(sys.argv) < 2:
    print("Please provide a SQL file.")
    print("Example: python python/run_sql.py sql/02_customer_analysis.sql")
    sys.exit()

sql_file = sys.argv[1]

# Connect to database
connection = sqlite3.connect(database_path)
cursor = connection.cursor()

# Read SQL file
with open(sql_file, "r", encoding="utf-8") as file:
    sql_script = file.read()

# Split into individual SQL statements
statements = [
    statement.strip()
    for statement in sql_script.split(";")
    if statement.strip()
]

# Execute each query
for i, statement in enumerate(statements, start=1):
    cursor.execute(statement)
    results = cursor.fetchall()

    print(f"\n--- Query {i} ---")

    for row in results:
        print(row)

connection.close()