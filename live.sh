#!/usr/bin/env bash
# Attempts to start the server ever 10 seconds.
sudo nohup java -cp ./bin/live Main ./start.sh 10000 &