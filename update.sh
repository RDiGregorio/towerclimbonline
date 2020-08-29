#!/usr/bin/env bash
git pull
./pub_get.sh
./pub_build.sh
./deploy_web.sh