# Care-4-Kids Auto Notifier

## Software Requirements 
* docker
* docker-compose

## Setup

### 1. Create .env file with keys
```bash 
cat << EOF > .env
CELLPHONENUMBER_ENCRYPTION_KEY=$(cat /dev/random | dd ibs=32 count=1 status=none | base64)
EOF
```

### 2. Start docker
docker-compose up -d