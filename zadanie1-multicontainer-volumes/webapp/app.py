import os
import time
from datetime import datetime, timezone

import psycopg
from flask import Flask, render_template


DB_HOST = os.getenv("DB_HOST", "lesson21-db")
DB_NAME = os.getenv("DB_NAME", "lesson21")
DB_USER = os.getenv("DB_USER", "lesson21")
DB_PASSWORD = os.getenv("DB_PASSWORD", "lesson21pass")
STATIC_VOLUME_PATH = os.getenv("STATIC_VOLUME_PATH", "/app/static-volume")

app = Flask(__name__)


def connect_with_retry(retries=30, delay=1):
    last_error = None
    for _ in range(retries):
        try:
            return psycopg.connect(
                host=DB_HOST,
                dbname=DB_NAME,
                user=DB_USER,
                password=DB_PASSWORD,
                connect_timeout=3,
            )
        except Exception as exc:
            last_error = exc
            time.sleep(delay)
    raise last_error


def init_db():
    with connect_with_retry() as conn:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS visits (
                id SERIAL PRIMARY KEY,
                created_at TIMESTAMPTZ NOT NULL,
                note TEXT NOT NULL
            )
            """
        )


@app.route("/")
def index():
    init_db()
    now = datetime.now(timezone.utc)
    with connect_with_retry() as conn:
        conn.execute(
            "INSERT INTO visits (created_at, note) VALUES (%s, %s)",
            (now, "visit from Flask container"),
        )
        count = conn.execute("SELECT COUNT(*) FROM visits").fetchone()[0]

    static_note_path = os.path.join(STATIC_VOLUME_PATH, "note.txt")
    static_note = "Static volume is mounted, but note.txt does not exist yet."
    if os.path.exists(static_note_path):
        with open(static_note_path, encoding="utf-8") as handle:
            static_note = handle.read().strip()

    return render_template("index.html", count=count, static_note=static_note)


@app.route("/health")
def health():
    init_db()
    return {"status": "ok", "database": DB_HOST}


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)
