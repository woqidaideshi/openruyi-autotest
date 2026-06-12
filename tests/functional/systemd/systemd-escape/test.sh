#!/bin/sh -eux
# Functional test: systemd - systemd-escape

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q systemd' 0 "Check systemd package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 17: systemd-escape ==="

rlRun 'systemd-escape "hello world"' 0 "systemd-escape: basic escape"
rlRun 'systemd-escape --path "/usr/bin/test"' 0 "systemd-escape --path: path escape"
rlRun 'systemd-escape -u "hello\\x20world"' 0 "systemd-escape -u: unescape"
rlRun 'systemd-escape --suffix=mount "/mnt/data"' 0 "systemd-escape --suffix"
rlRun 'systemd-escape --template="test@.service" instance' 0 "systemd-escape --template"

# ===================================================================

echo ""
echo "All systemd systemd-escape tests passed!"
