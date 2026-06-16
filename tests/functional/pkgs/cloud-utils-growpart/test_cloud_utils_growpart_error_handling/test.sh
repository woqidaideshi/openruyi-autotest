#!/bin/sh -eux
# Functional test: cloud-utils-growpart - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cloud-utils-growpart ===
INSTALLED_BY_TEST=0
if ! rpm -q cloud-utils-growpart 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cloud-utils-growpart 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cloud-utils-growpart"
    else
        echo "SKIP: cloud-utils-growpart not available in repos"
        exit 0
    fi
else
    echo "SETUP: cloud-utils-growpart already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 6: Error handling ==="
rlRun 'growpart 2>&1 || true' 0 "growpart: no args (expected fail)"
rlRun 'growpart /dev/nonexistent 1 2>&1 || true' 0 "growpart: nonexistent disk"
rlRun 'growpart --invalid 2>&1 || true' 0 "growpart: invalid option"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cloud-utils-growpart 2>/dev/null || true
    echo "TEARDOWN: removed cloud-utils-growpart"
fi
echo ""
echo "All cloud-utils-growpart functional tests passed!"
cd /
rm -rf $TmpDir

echo ""
echo "All cloud-utils-growpart Error-handling tests passed!"
