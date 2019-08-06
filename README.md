# Care-4-Kids Auto Notifier

## Setup and Start Local Dev Env
```bash
docker build . -t auto-notifier
docker run -it -v $PWD:/app -p 3000:3000/tcp auto-notifier bash
```