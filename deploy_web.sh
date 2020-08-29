#!/usr/bin/env bash
sudo rm -rf /var/lib/tomcat8/webapps/ROOT
sudo cp -rf ./build /var/lib/tomcat8/webapps/ROOT