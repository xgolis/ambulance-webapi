#!/bin/bash

# Assign the first command line argument to the variable 'command'
command=$1

# If no command is provided, default to "start"
if [ -z "$command" ]; then
    command="start"
fi

# Define the project root directory relative to the script location
ProjectRoot="$(dirname "$0")/.."

# Set environment variables
export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"

# Execute actions based on the command
case $command in
    "start")
        go run "${ProjectRoot}/cmd/ambulance-api-service"
        ;;
    "openapi")
        docker run --rm -ti -v "${ProjectRoot}:/local" openapitools/openapi-generator-cli generate -c /local/scripts/generator-cfg.yaml
        ;;
    *)
        echo "Unknown command: $command"
        exit 1
        ;;
esac

