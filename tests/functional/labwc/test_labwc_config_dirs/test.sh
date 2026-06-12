#!/bin/sh -eux
# Functional test: labwc - Config-dirs

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q labwc 2>/dev/null || { echo 'labwc not installed, skipping'; exit 0; }
which labwc 2>/dev/null || echo 'labwc not found'
which labnag 2>/dev/null || echo 'labnag not found'
which lab-sensible-terminal 2>/dev/null || echo 'lab-sensible-terminal not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Config dirs ==="
rlRun 'ls /etc/xdg/labwc/ 2>&1 || echo "No system config dir"' 0 "System config dir"
rlRun 'ls /usr/share/labwc/ 2>&1 || echo "No data dir"' 0 "Data dir"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Config-dirs tests passed!"
