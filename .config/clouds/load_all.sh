#!/bin/bash

if [[ $1 == "centerfield" ]]; then
  source ~/.config/clouds/aws/centerfield/load_centerfield.sh
else
  echo "Usage: $0 {centerfield}"
fi
