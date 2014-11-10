#!/bin/bash
set -e
source /build/buildconfig
set -x

/build/enable_repos.sh
/build/prepare.sh
/build/utilities.sh
/build/java.sh

/build/finalize.sh
