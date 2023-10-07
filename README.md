# Deployment-Files
Holds any files revelent to deployment

# Install
```bash
go install sigs.k8s.io/kind@v0.20.0
```

# Setup
Create a `.env` for each microservice
```bash
touch ./web-api/.web-api-env
```

# Run
```bash
./scripts/start.sh
```

# Stop
```bash
./scripts/stop.sh
```