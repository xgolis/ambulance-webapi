#!/bin/bash

# Assign the first command line argument to the variable 'command'
command=$1

# Define the project root directory relative to the script location
ProjectRoot="$(dirname "$0")/.."

# Set environment variables
export AMBULANCE_API_PORT="8080"
export AMBULANCE_API_MONGODB_USERNAME="root"
export AMBULANCE_API_MONGODB_PASSWORD="neUhaDnes"

# Define the 'mongo' function to handle Docker Compose operations
mongo() {
    docker compose --file "${ProjectRoot}/deployments/docker-compose/compose.yaml" "$@"
}

# Execute actions based on the command
case $command in
    "openapi")
        docker run --rm -ti -v "${ProjectRoot}:/local" openapitools/openapi-generator-cli generate -c /local/scripts/generator-cfg.yaml
        ;;
    "start")
        # Try to start MongoDB and run the service, then ensure MongoDB is stopped
        mongo up --detach
        if go run "${ProjectRoot}/cmd/ambulance-api-service"; then
            mongo down
        else
            mongo down
            exit 1
        fi
        ;;
    "mongo")
        mongo up
        ;;
    "docker")
        docker build -t xgolis/ambulance-wl-webapi:local-build -f ${ProjectRoot}/build/docker/Dockerfile .
        ;;
    *)
        echo "Unknown command: $command"
        exit 1
        ;;
esac
