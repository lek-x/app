"""
create table if not exist
"""
from __future__ import absolute_import
import psycopg2
import os
dname=os.environ.get("dname")
duser=os.environ.get("duser")
dpass=os.environ.get("dpass")
dbhost=os.environ.get("dbhost")
prt=os.environ.get("prt")

conn = psycopg2.connect(dbname=dname, user=duser, 
                        password=dpass, host=dbhost, port=prt)

cursor = conn.cursor()
cursor.execute("CREATE TABLE IF NOT EXISTS mes ( \
    id serial  PRIMARY KEY, \
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, \
    temperature_max INTEGER NOT NULL, \
    temperature_min INTEGER NOT NULL, \
    humidity  INTEGER NOT NULL, \
    stdate date NOT NULL);")
conn.commit()