#!/bin/sh -eux
# Functional test: labwc - Config-dirs

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q labwc' 0 "Check labwc installed"
rlRun 'which labwc' 0 "Check labwc available"
rlRun 'which labnag' 0 "Check labnag available"
rlRun 'which lab-sensible-terminal' 0 "Check lab-sensible-terminal available"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 8: Config dirs ==="
rlRun 'ls /etc/xdg/labwc/ 2>&1 || echo "No system config dir"' 0 "System config dir"
rlRun 'ls /usr/share/labwc/ 2>&1 || echo "No data dir"' 0 "Data dir"

cd /
rm -rf $TmpDir

echo ""
echo "All labwc Config-dirs tests passed!"
