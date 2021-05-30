#!/bin/bash

# Welcome
echo 'Server start script initialized...'

# Set the port
PORT=8080

# Change directories to the release folder
cd build/web/

# Start the server
echo 'Starting server on port' $PORT '...'
python3 -m http.server $PORT

# Exit
echo 'Server exited...'
