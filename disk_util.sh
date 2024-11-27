#!/bin/bash

#this script will return mount name and usage percent 
THRESHOLD=15

# Loop through all mounted filesystems
df -h | awk 'NR>1 {print $1, $5, $6}' | while read filesystem usage mountpoint; do
  # Remove the percentage sign from usage
  usage_percent=$(echo "$usage" | sed 's/%//')
  
  # Check if the usage exceeds the threshold
  if [ "$usage_percent" -gt "$THRESHOLD" ]; then
    echo "1"
    exit
    # Optional: Take action, such as sending an email or cleaning temporary files
  fi  
done
