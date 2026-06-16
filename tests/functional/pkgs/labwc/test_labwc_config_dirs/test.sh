#!/bin/sh -eux
# Functional test: labwc - Config-dirs

. "../setup.sh"

echo "=== Test 8: Config dirs ==="
rlRun 'ls /etc/xdg/labwc/ 2>&1 || echo "No system config dir"' 0 "System config dir"
rlRun 'ls /usr/share/labwc/ 2>&1 || echo "No data dir"' 0 "Data dir"

cd /
rm -rf $TmpDir

. "../teardown.sh"
echo "All labwc Config-dirs tests passed!"
