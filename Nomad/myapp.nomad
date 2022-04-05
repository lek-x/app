job "myapp2" {
  type        = "service"
  datacenters = ["dc1"]
  vault {
    policies = ["myapp","nomad-server"]
    change_mode   = "signal"
    change_signal = "SIGUSR1"
  }
  group "myapp-db" {

    network {
      port "db" {
        to = 5432
      }
      port "app" {
        static = 5000
      }
    }


    task "psql"{
	    driver = "docker"
	 
	    config {
	      image = "postgres:latest"
	      ports = ["db"]
		  }
	  

		  env {
		    POSTGRES_PASSWORD = "${dpass}"
		    POSTGRES_USER = "${duser}"
		    POSTGRES_DB = "${dname}"
		} 
      resources {
		}
		   lifecycle {
        hook    = "prestart"
        sidecar = false
      }
	    service {
	      name = "postgres"
		    port = "db"
		    check {
           name     = "alive_db"
           type     = "tcp"
           interval = "10s"
           timeout  = "2s"
        }
	   }	
	  }
  

    task "app" {
      driver = "docker"
     
      config {
        image = URL-TO-IMAGE"
        ports = ["app"]
        auth {
          username = "USERNAME"
          password = "Password/Token"
        }
      }
	    env {
		    dname = "${dname}"
		    duser = "${duser}"
		    dbhost = "${NOMAD_IP_db}"
		    dpass = "${dpass}"
        dport = 5432
		  } 
	  
	    service {
	      name = "myapp"
	      port = "app"
	      check {
            name = "Check that wheather app is running"
            interval = "10s"
            timeout  = "5s"
            type     = "http"
            protocol = "http"
            path     = "/"
        }
	  
	  }
     template {
          destination = "secrets/app.env"
          env         = true
          change_mode = "restart"
          data        = <<EOF
            {{ with secret  "secrets/creds/app"}}
          dname = {{.Data.dbname}}
          duser = {{.Data.dbuser}}
          dpass = {{.Data.dbpass}}
            {{end}}
          EOF
        }
  

      resources {
        cpu    = 200
        memory = 100
        }
      lifecycle {
        hook    = "poststart"
        sidecar = false
      }

      }
  }
}

