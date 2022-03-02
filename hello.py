import psycopg2
from psycopg2.extras import DictCursor
from contextlib import closing
from psycopg2 import Error
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from flask import Flask, request, render_template

def get_db_connection():
  conn = psycopg2.connect(dbname='postgres', user='postgres',
                        password='test', host='localhost')
  return conn


app = Flask(__name__)


@app.route("/")
def index():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute("SELECT * from mes")
        posts = cursor.fetchall()
        conn.close()
        print(posts)
        return render_template('index.html', posts=posts)

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()
