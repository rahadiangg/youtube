#!/bin/bash

SOURCE_POD=""
TARGET=www.google.com

if [ -n "$1" ]; then
    TARGET="$1"
fi

for ((i=0; i<10; i++))  # You can adjust the number of retries
do
    sleep 2
    echo "Trying to get pod name, attempt $((i+1))..."

    SOURCE_POD=$(kubectl get pod -l app=sleep -o jsonpath='{.items..metadata.name}')

    if [ -n "$SOURCE_POD" ]
    then
        echo "Pod found: $SOURCE_POD"
        break  # Exit the loop if a pod is found
    fi

    if [ "$i" -eq 9 ]
    then
        echo "Pod not found after 10 attempts. Exiting..."
        exit 1
    fi
done

kubectl exec "$SOURCE_POD" -c sleep -- curl -sSI "https://$TARGET" | grep  "HTTP/";