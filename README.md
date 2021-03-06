# Care-4-Kids Auto Notifier

## Software Requirements 
* docker
* docker-compose

## Local development setup

### 1. Create .env file with keys
```bash 
cat << EOF > .env
CELLPHONENUMBER_ENCRYPTION_KEY=$(cat /dev/random | dd ibs=32 count=1 status=none | base64)
MESSAGE_TEXT_ENCRYPTION_KEY=$(cat /dev/random | dd ibs=32 count=1 status=none | base64)
DATABASE_URL=mysql2://root:password@db
DATABASE_NAME=unitedwayetl
UNITEDWAYDB_HOST=docuclassdb
UNITEDWAYDB_USERNAME=skylight
UNITEDWAYDB_PASSWORD=$(cat /dev/random | dd ibs=10 count=1 status=none | base64)
SA_USERNAME=SA
SA_PASSWORD=A*Strong@Password!
ACCEPT_EULA=Y
C4K_SMS_NUMBER=<SMS Provider Number>
TWILIO_ACCOUNT_SID=<Account SID>
TWILIO_AUTH_TOKEN=<Auth Token>
SECRET_KEY_BASE=$(cat /dev/random | dd ibs=10 count=1 status=none | base64)
SERVER_IP="See production deploy section"
SLACK_WEBHOOK="for slack notifications"
EOF
```

### 2. Start docker
```bash
make setup-dev && make start-dev
```

## Useful commands
| command    | description |
| -------    | ----------- |
| setup-dev  |Setup for local development|
| start-dev  |Start application for local development (required to run tests)|
| stop-dev   |Stop application|
| run-tests  |Run all tests|
| deploy     |Deploy application to production (see [Deploy App section](#deploy-app)) |

## Setting schedule notification with `crontab`/`whenever`

**In order to use `whenever` you first need to configure your production env.**
1. Ensure that the `SECRET_KEY_BASE` environment env has been set
1. Exec into docker container
    ```bash
    docker-compose exec app bash
    ```
1. Setup the production database
    ```bash
    RAILS_ENV=production rails db:setup && rails db:migrate && rails db:seed
    ```

1. To see command in order run manually
    ```
    bundle exec whenever
    ```

1. To add the command to cron
    ```
    bundle exec whenever --update-crontab
    ``` 

## Deploy App
### First deploy
1. ssh into server and install dependencies
    ``` bash
    sudo apt-get install build-essential libxml2-dev libxslt1-dev  libqtwebkit4  libqt4-dev xvfb libmysqlclient-dev freetds-dev
    ```
1. Set `SERVER_IP` env variable in the `.env` file. This is the target server IP address.
1. Run 
    ```bash
    make deploy-production
    ```
1. ssh into server and add .env from lastpass file into the `/home/rails/railsapps/care-4-kids-auto-notifier/shared` folder
1. return to your local machine and run 
    ```bash
    make deploy-production
    ```


### Deploys after the inital deploy
1. Set `SERVER_IP` env variable. This is the target server IP address.
1. Run
    ```bash
    make deploy-production
    ```


## Pushing Container image for CircleCI to Docker Hub
This container is required for CI/CD
```
docker login
docker build . -t stateofct/ctoec-care-4-kids-notifier
docker push stateofct/ctoec-care-4-kids-notifier
```