# Care-4-Kids Auto Notifier

## Software Requirements 
* docker
* docker-compose

## Setup

### 1. Create .env file with keys
```bash 
cat << EOF > .env
CELLPHONENUMBER_ENCRYPTION_KEY=$(cat /dev/random | dd ibs=32 count=1 status=none | base64)
DATABASE_URL=mysql2://root:password@db
UNITEDWAYDB_HOST=unitedwaydb
UNITEDWAYDB_ADMIN_USERNAME=root
UNITEDWAYDB_ADMIN_PASSWORD=password
UNITEDWAYDB_USERNAME=skylight
UNITEDWAYDB_PASSWORD=$(cat /dev/random | dd ibs=10 count=1 status=none | base64)
UNITEDWAYDB_DATABASE=unitedwayetl
EOF
```

### 2. Start docker
docker-compose up -d