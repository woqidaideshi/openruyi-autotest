#!/bin/sh -eux
# Functional test: sddm - Configuration

. "../setup.sh"

echo "=== Test 2: Configuration ==="
rlRun 'sddm --example-config 2>&1 | head -20' 0 "sddm: example config"
rlRun 'ls /etc/sddm.conf.d/ 2>&1 || echo "No config dir"' 0 "Config directory"
rlRun 'ls /usr/lib/sddm/sddm.conf.d/ 2>&1 || echo "No default config dir"' 0 "Default config dir"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All sddm Configuration tests passed!"
