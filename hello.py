"""
weather small app
"""
from __future__ import absolute_import
import os
import json
from datetime import datetime
import psycopg2
from psycopg2.extras import DictCursor
from flask import Flask, request, render_template
import requests
from dateutil.relativedelta import relativedelta

####Date section
today=datetime.today().strftime('%Y-%m-%d')
year_ago=datetime.today() - relativedelta(years=1)
year_ago=(str(year_ago))[0:10]
city = 2123260
##### Env. section
dname=os.environ.get("dname")
duser=os.environ.get("duser")
dpass=os.environ.get("dpass")
dbhost=os.environ.get("dbhost")
prt=os.environ.get("prt")


def get_today():
    "get data today weather"
    url = 'https://www.metaweather.com/api/location/'+str(city)
    params = { 'format': 'json'}
    r = requests.get(url, params=params)
    data = json.loads(r.text)
    max_temp=data['consolidated_weather'][0]['max_temp']
    min_temp=data['consolidated_weather'][0]['min_temp']
    humidity=data['consolidated_weather'][0]['humidity']
    print('DEBUG hum:',humidity)
    global td
    td = (max_temp,min_temp,humidity,today)
    return td

def get_yearago():
    "get data year ago weather"
    url = 'https://www.metaweather.com/api/location/'+str(city)+'/' \
	+year_ago[0:4]+'/'+year_ago[6]+'/'+year_ago[8:10]+'/'
    params = { 'format': 'json'}
    r2 = requests.get(url, params=params)
    data2 = json.loads(r2.text)

    max_temp_y=data2[0]['max_temp']
    min_temp_y=data2[0]['min_temp']
    humidity_y=data2[0]['humidity']
    print('Debug temp',max_temp_y)
    global yg
    yg = (max_temp_y,min_temp_y,humidity_y,year_ago)
    return yg




def get_db_connection():
    "settings to connect to db"
    conn = psycopg2.connect(dbname=dname, user=duser,
                        password=dpass, host=dbhost, port=prt)
    return conn

app = Flask(__name__)

@app.route("/", methods=('GET', 'POST'))
def index():
    "main page func."
    if request.method == 'GET':
        try:
            conn = get_db_connection()
            cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            cursor.execute("SELECT * from mes")
            posts = cursor.fetchall()
            conn.close()
            print("DEBUG",posts)
            return render_template('index.html', posts=posts)
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
    if request.method == 'POST':
        get_today()
        get_yearago()
        print("debug-post",td)
        try:
            #connect to db
            conn = get_db_connection()
            cursor = conn.cursor()
            #prepare query
            query = "INSERT INTO mes (temperature_max, temperature_min, humidity, stdate) \
			VALUES (%s , %s, %s, %s);"
            #td returns from get_today()
            data = td
            print("debug",data)
            #do insert
            cursor.execute(query,data)
            conn.commit()
            #do insert of data year ago
            data2=yg
            print('debug',data2)
            query2 = "INSERT INTO mes (temperature_max, temperature_min, humidity, stdate) \
			VALUES (%s , %s, %s, %s);"
            cursor.execute(query2,data2)
            conn.commit()
            #read from db
            cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            cursor.execute("SELECT * from mes")
            posts = cursor.fetchall()
            conn.close()
            print("DEBUG",posts)
            return render_template('index.html', posts=posts)
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
        finally:
            if conn is not None:
                conn.close()
