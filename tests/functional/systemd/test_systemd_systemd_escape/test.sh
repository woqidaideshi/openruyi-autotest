#!/bin/sh -eux
# Functional test: systemd - systemd-escape

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install systemd ===
INSTALLED_BY_TEST=0
if ! rpm -q systemd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y systemd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed systemd"
    else
        echo "SKIP: systemd not available in repos"
        exit 0
    fi
else
    echo "SETUP: systemd already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 17: systemd-escape ==="

rlRun 'systemd-escape "hello world"' 0 "systemd-escape: basic escape"
rlRun 'systemd-escape --path "/usr/bin/test"' 0 "systemd-escape --path: path escape"
rlRun 'systemd-escape -u "hello\\x20world"' 0 "systemd-escape -u: unescape"
rlRun 'systemd-escape --suffix=mount "/mnt/data"' 0 "systemd-escape --suffix"
rlRun 'systemd-escape --template="test@.service" instance' 0 "systemd-escape --template"

# ===================================================================


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y systemd 2>/dev/null || true
    echo "TEARDOWN: removed systemd"
fi
echo ""
echo "All systemd systemd-escape tests passed!"
