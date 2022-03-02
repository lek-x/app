import psycopg2

conn = psycopg2.connect(dbname='postgres', user='postgres', 
                        password='test', host='localhost')

cursor = conn.cursor()
