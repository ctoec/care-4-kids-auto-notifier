# Twilio Studio Serverless Environment

Create a `.env` file with the below structure:
```
ACCOUNT_SID=<Twilio Account SID>
AUTH_TOKEN=<Twilio Auth Token>
```

# Starting Docker

To start the Docker containers, run `docker-compose up -d`.

To connect to the `twilio-studio` container, run `docker-compose exec twilio-studio bash`.

# Developing

Start the Docker containers and connect to the `twilio-studio` container.

Once connected, start the development environment with `npx twilio-run start --live`.

The function endpoints will be available on `localhost:3000`.

# Deploying

Start the Docker containers and connect to the `twilio-studio` container.

Once connected, deploy the functions and assets with `npx twilio-run deploy`.
