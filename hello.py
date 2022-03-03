import psycopg2
from psycopg2.extras import DictCursor
from contextlib import closing
from psycopg2 import Error
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from flask import Flask, request, render_template
import sys
import requests
import json
from datetime import datetime
from dateutil.relativedelta import relativedelta

today=datetime.today().strftime('%Y-%m-%d')
yearago=datetime.today() - relativedelta(years=1)
yearago=(str(yearago))[0:10]
city = 2123260


def get_today():
    url = 'https://www.metaweather.com/api/location/'+str(city)
    params = { 'format': 'json'}
    r = requests.get(url, params=params)
    data = json.loads(r.text)
    max_temp=data['consolidated_weather'][0]['max_temp']
    min_temp=data['consolidated_weather'][0]['min_temp']
    humidity=data['consolidated_weather'][0]['humidity']
    id=data['consolidated_weather'][0]['id']
    print('DEBUG hum:',humidity)
    global td
    td = (max_temp,min_temp,humidity,today)
    return td

def get_yearago():
    url = 'https://www.metaweather.com/api/location/'+str(city)+'/'+yearago[0:4]+'/'+yearago[6]+'/'+yearago[8:10]+'/'
    params = { 'format': 'json'}
    r2 = requests.get(url, params=params)
    data2 = json.loads(r2.text)

    max_temp_y=data2[0]['max_temp']
    min_temp_y=data2[0]['min_temp']
    humidity_y=data2[0]['humidity']
    id=data2[0]['id']
    print('Debug temp',max_temp_y)
    global yg
    yg = (max_temp_y,min_temp_y,humidity_y,yearago)
    return yg




def get_db_connection():
  conn = psycopg2.connect(dbname='postgres', user='postgres',
                        password='test', host='localhost')
  return conn


app = Flask(__name__)


@app.route("/", methods=('GET', 'POST'))
def index():
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
            query = "INSERT INTO mes (temperature_max, temperature_min, humidity, stdate)  VALUES (%s , %s, %s, %s);"
            #td returns from get_today()
            data = td
            print("debug",data)
            #do insert
            cursor.execute(query,data)
            #cursor.execute("INSERT INTO mes (temperature_max, temperature_min, humidity,stdate)  VALUES (01 , 66, 55, '1999-01-01');")
            conn.commit()
            #do insert of data year ago
            data2 = yg
            print('debug',data2) 
            query2 = "INSERT INTO mes (temperature_max, temperature_min, humidity, stdate)  VALUES (%s , %s, %s, %s);"
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
