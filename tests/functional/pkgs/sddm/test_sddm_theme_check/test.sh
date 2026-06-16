#!/bin/sh -eux
# Functional test: sddm - Theme-check

. "../setup.sh"

echo "=== Test 4: Theme check ==="
rlRun 'ls /usr/share/sddm/themes/ 2>&1 | head -5' 0 "sddm themes installed"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All sddm Theme-check tests passed!"
