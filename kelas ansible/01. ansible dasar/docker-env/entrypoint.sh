#!/bin/bash

# start ssh
service ssh start

exec "$@"
