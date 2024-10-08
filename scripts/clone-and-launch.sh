#!/bin/bash

# Clone the repository
git clone https://github.com/mountainash-io/rstudio-docker-products.git
cd rstudio-docker-products

# Set environment variables
source scripts/set-env.sh

# Combine configuration files
source scripts/combine-conf.sh

# Launch the docker compose file
docker-compose up -d
