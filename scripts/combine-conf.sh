#!/bin/bash

# Combine .conf files from inside the repo and external to the repo
# Ensure all python, R, and vscode packages and extensions are installed

# Define directories
INTERNAL_CONF_DIR="./conf"
EXTERNAL_CONF_DIR="/path/to/external/conf"
COMBINED_CONF_DIR="./combined_conf"

# Create combined configuration directory if it doesn't exist
mkdir -p $COMBINED_CONF_DIR

# Combine .conf files
for conf_file in $(ls $INTERNAL_CONF_DIR/*.conf); do
  base_name=$(basename $conf_file)
  external_conf_file="$EXTERNAL_CONF_DIR/$base_name"
  combined_conf_file="$COMBINED_CONF_DIR/$base_name"

  # If external conf file exists, combine it with internal conf file
  if [ -f $external_conf_file ]; then
    cat $conf_file $external_conf_file > $combined_conf_file
  else
    cp $conf_file $combined_conf_file
  fi
done

# Install python packages
if [ -f "$COMBINED_CONF_DIR/python_packages.conf" ]; then
  pip install -r $COMBINED_CONF_DIR/python_packages.conf
fi

# Install R packages
if [ -f "$COMBINED_CONF_DIR/r_packages.conf" ]; then
  Rscript -e "install.packages(readLines('$COMBINED_CONF_DIR/r_packages.conf'))"
fi

# Install VSCode extensions
if [ -f "$COMBINED_CONF_DIR/vscode_extensions.conf" ]; then
  while IFS= read -r extension; do
    code --install-extension $extension
  done < $COMBINED_CONF_DIR/vscode_extensions.conf
fi
