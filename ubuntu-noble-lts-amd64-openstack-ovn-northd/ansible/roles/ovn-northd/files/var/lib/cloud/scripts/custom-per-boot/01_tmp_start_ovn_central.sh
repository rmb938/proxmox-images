#!/bin/bash

set -exuo pipefail

# TODO: this is temp until we have consul template doing this
systemctl start ovn-central.service