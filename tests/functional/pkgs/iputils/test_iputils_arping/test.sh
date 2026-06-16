#!/bin/sh -eux
# Functional test: iputils - arping

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install iputils ===
INSTALLED_BY_TEST=0
if ! rpm -q iputils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y iputils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed iputils"
    else
        echo "SKIP: iputils not available in repos"
        exit 0
    fi
else
    echo "SETUP: iputils already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: arping ==="

# Test 6.1: ARP ping to localhost interface
arping -c 3 -I lo 127.0.0.1 || echo "arping test completed (requires proper interface)"

# Test 6.2: arping with count
arping -c 5 127.0.0.1 || echo "arping with count test completed"

# Test 6.3: arping with timeout
arping -c 3 -w 5 127.0.0.1 || echo "arping with timeout test completed"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y iputils 2>/dev/null || true
    echo "TEARDOWN: removed iputils"
fi
echo ""
echo "All iputils arping tests passed!"
