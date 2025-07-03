#!/bin/bash

# Step-CA Manager Deploy Script

# Check for --dns parameter
USE_DNS=false
if [[ "$*" == *"--dns"* ]]; then
    USE_DNS=true
fi

case "$1" in
    "up")
        if [[ "$USE_DNS" == "true" ]]; then
            docker-compose -f docker-compose.yml -f docker-compose.dns.yml up --build -d
        else
            docker-compose up --build -d
        fi
        ;;
    *)
        echo "Step-CA Manager Deploy"
        echo ""
        echo "Usage:"
        echo "  ./deploy.sh up       # Basic stack"
        echo "  ./deploy.sh up --dns # Stack with DNS"
        echo ""
        echo "Commands:"
        echo "  docker-compose up -d"
        echo "  docker-compose -f docker-compose.yml -f docker-compose.dns.yml up -d"
        ;;
esac