import sys
import requests
import json
from datetime import datetime
from dateutil.relativedelta import relativedelta

today=datetime.today().strftime('%Y-%m-%d')
yearago=datetime.today() - relativedelta(years=1)
yearago=(str(yearago))[0:10]
city = 2123260


def sync():
    def get_today():
        url = 'https://www.metaweather.com/api/location/'+str(city)
        params = { 'format': 'json'}
        r = requests.get(url, params=params)
        data = json.loads(r.text)
        max_temp=data['consolidated_weather'][0]['max_temp']
        min_temp=data['consolidated_weather'][0]['min_temp']
        humidity=data['consolidated_weather'][0]['humidity']
        id=data['consolidated_weather'][0]['id']
        #print('max temp',max_temp)
        #print('min temp',min_temp)
        #print('hum',humidity)
        #print(id)
        #print(today)
        global td
        td = (max_temp,min_temp,humidity,today)
        print(td)
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
        #print('year ago max temp',max_temp_y)
        #print('year ago min temp',min_temp_y)
        #print('year ago hum',humidity_y)
        #print(id)
        #print(yearago)
        yg = (max_temp_y,min_temp_y,humidity_y,yearago)
        return yg
    get_today()
    print(td)
sync()

