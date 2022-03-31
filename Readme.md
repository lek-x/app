# This is My Diploma project of Deploying Python App in k8s. 

## Description:
This code deploys my python application in k8s cluster in AWS EKS. Also it has:

**Logging system** - Fleuntd, Elasticsearch, Kibana

**Monitoring system** - Prometheus, AlertManager, Node Exporter, Grafana, TelegramBot support container.

## About App:
It is a python based app to retrive data about Wheather in St.Petersburg for yesterday and year ago. It stores data in DB.


## Requrements: 
  - AWS account
  - Terraform >= 1.0
  - kubectl on host OS
  - aws cli tool
  - pylinter
  - Anchore Grype tool 
  - Docker on host OS
  - k8s cluster 
  - Vault [optional]
  - Jenkins server [optional]

**[Optional]**

Jenkins uses to automatic deploy new versions of app.
Vault uses to recieve secretes to the Jenkins. If you won't use Vault, edit **"Logging into Github registry"** step in Jenkinsfile, remove/replace **"withCredentionals"** statement. 


For deploy k8s you may use this [terraform code](https://github.com/lek-x/eks_cluster_terr)

## Directory structure:
1. k8s/ - contains manifests to deploy App and other services
2. Static/ - files for web page
3. templates/ - html templates for rendering web pages

## Main files:
1. Dockerfile - to build app
2. hello.py - app core
3. init_db.py - scirpt for migrating DB
4. Jenkinsfile.app - pipeline code for deploy app

## Quick start:
1. Deploy k8s cluster
2. Clone this repo
3. Customize your settings
4. Set context to current cluster
5. Go to k8s directory and run
    ```
    one_step_run.sh
    ```
6. Wait some time
7. Use http address which shows in terminal to access to App

## Http routes:
1. / - main app route
2. /kibana - route to access to Elasticsearch **[need user/pass see security section]**
3. /prom/graph - route to access to Prometheus **[need user/pass see security section]**
4. /alertm - route to access to Alertmanager **[need user/pass see security section]**
5. /grafana - route to access to Grafana


## Customizing:
## 1. Application

1. **City**: In hello.py app you can change desired city. See https://www.metaweather.com/api/location/ 
2. **Dates for weather**: In hello.py see ***def calc_date()*** to change wheather's dates.
3. **User/pass for DB**: It sets by k8s/app/**app_configmap.yaml** and **app_secret.yaml**, don't forget to change **postgres_configmap.yaml** and **postgres_secret.yaml**.
    ```
    echo -n "your_data" | base64
    ```
## 2. Telegram Bot container
To use alertS through Telegram Bot you need to create a new Bot with **BotFather**, get ID and token from **BotFather**. Then insert your Token and ID in **k8s/prom/prom_bot_depl.yaml.example** and rename it to **prom_bot_depl.yaml**

## 3. Security
1. To change **base_auth** to access to services set new **user:pass** in k8s/nginx_ingress/**nginx_base_auth_secret.yaml**. Use next commands to generate basict_auth string.
    ```
    htpasswd -c auth username
    ```
    ```
    cat auth | base64
    ```
    There are two strings in **nginx_base_auth_secret.yaml** for access to different services.
    **basic-auth:** 
         - for route /kibana
    **basic-auth-def:** 
         - for route /prom, 
         - for route /alertm, 



## License
GNU GPL v3