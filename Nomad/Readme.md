## Description:
This code deploys my python application and DB with Nomad.

## Requrements: 
  - Docker on host OS
  - Vault
  - Consul
  - Nomad

## Main files:
1. myapp.nomad - job file for Nomad
2. myapp_policy.hcl - policy for Nomad
3. secrets_path.example - example where secrets are placed

## Quick start:
1. Build Docker image with app
3. Customize your registry settings in myapp.nomad
4. Create Vault policy for Nomad 
5. Generate Vault Token for Nomad 
6. Deploy by commands
    ```
    nomad plan myapp.nomad
    ```
	```
    nomad run myapp.nomad
    ```

## License
GNU GPL v3