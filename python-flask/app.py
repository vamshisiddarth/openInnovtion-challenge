from flask import Flask, render_template, request
import psycopg2
import os

app = Flask(__name__)

def check_db_connection():
    try:
        conn = psycopg2.connect(
            dbname="challenge",
            user="dbuser",
            password=os.getenv("DB_PASSWORD"),
            host=os.getenv("DB_HOST"),
            port="5432"
        )
        conn.close()
        return "Connection Successful!!"
    except Exception as e:
        return f"Connection Unsuccessful!! Error: {e}"

@app.route("/", methods=["GET", "POST"])
def home():
    message = ""
    if request.method == "POST":
        message = check_db_connection()
    return render_template("index.html", message=message)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=False)