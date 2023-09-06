#!/bin/bash

sudo systemctl stop subspaced
sudo systemctl disable subspaced
sudo rm /etc/systemd/system/subspaced.service
sudo rm /usr/local/bin/pulsar

echo "Pulsar and all associated files have been uninstalled."
