# Care-4-Kids Auto Notifier

## Software Requirements 
* docker
* docker-compose

## Setup

### 1. Create .env file with keys
```bash 
cat << EOF > .env
CASEID_ENCRYPTION_KEY=$(echo -n date | base64)
CELLPHONENUMBER_ENCRYPTION_KEY=$(echo -n date | base64)
EOF
```

### 2. Start docker
docker-compose up -d 