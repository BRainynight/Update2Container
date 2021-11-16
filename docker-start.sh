#!/bin/bash
set -e
export MACHINE_ID="NOT SET!"

git clone https://github.com/BRainynight/Update2Container.git
exec "$@"
