#!/bin/sh -eux
# Functional test: sddm - Config-values

. "../setup.sh"

echo "=== Test 5: Config values ==="
rlRun 'sddm --example-config 2>&1 | grep -E "^(Current|Display|Session|User)=" | head -10' 0 "sddm: key config values"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All sddm Config-values tests passed!"
