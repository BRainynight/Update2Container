#!/bin/bash
set -e
export MACHINE_ID=${MACHINE_ID:-"Not Set"}

git clone https://github.com/BRainynight/Update2Container.git
exec "$@"
