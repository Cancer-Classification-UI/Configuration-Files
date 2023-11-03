# Deployment-Files
Holds any files revelent to deployment. Scripts will generate the needed kubernetes configuration files to configure and launch the microservices and connect them together.

Resulting Frontend will be accessible at [http://localhost:30082](http://localhost:30082)

# Install
```bash
go install sigs.k8s.io/kind@v0.20.0
```

# Setup
Create a `.env` for each microservice
```bash
touch ./web-api/.web-api-env
touch ./login-api/.login-api-env
```
See samples in the samples folder for template env configurations for each service


# Run
```bash
./scripts/start.sh
```

# Stop
```bash
./scripts/stop.sh
```

# Misc
View current running pods with
```bash
kubectl get pods
```
```bash
kubectl get services
```

And view logs of each pod with
```bash
kubectl describe <pod name>
```
```bash
kubectl logs <pod name>
```