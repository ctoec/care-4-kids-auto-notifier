# Care-4-Kids Auto Notifier

## Software Requirements 
* docker
* docker-compose

## Setup

### 1. Create .env file with keys
```bash 
cat << EOF > .env
CELLPHONENUMBER_ENCRYPTION_KEY=$(cat /dev/random | dd ibs=32 count=1 status=none | base64)
MESSAGE_TEXT_ENCRYPTION_KEY=$(cat /dev/random | dd ibs=32 count=1 status=none | base64)
DATABASE_URL=mysql2://root:password@db
UNITEDWAYDB_HOST=unitedwaydb
UNITEDWAYDB_ADMIN_USERNAME=root
UNITEDWAYDB_ADMIN_PASSWORD=password
UNITEDWAYDB_USERNAME=skylight
UNITEDWAYDB_PASSWORD=$(cat /dev/random | dd ibs=10 count=1 status=none | base64)
UNITEDWAYDB_DATABASE=unitedwayetl
C4K_SMS_NUMBER=<SMS Provider Number>
TWILIO_ACCOUNT_SID=<Account SID>
TWILIO_AUTH_TOKEN=<Auth Token>
SECRET_KEY_BASE=$(cat /dev/random | dd ibs=10 count=1 status=none | base64)
EOF
```

### 2. Start docker
docker-compose up -d


## Setting schedule notification with `crontab`/`whenever`

**In order to use `whenever` you first need to configure your production env.**
1. Ensure that the `SECRET_KEY_BASE` environment env has been set
2. Setup the production database
    ```
    RAILS_ENV=production rails db:setup && rails db:migrate && rails db:seed
    ```

**To see command in order run manually**
```
bundle exec whenever
```

**To add the command to cron**
```
bundle exec whenever --update-crontab
``` 

## Deploy app
1. set `SERVER_IP` env variable 
2. run `cap production deploy` or `cap production deploy:updated`