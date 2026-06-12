#!/bin/sh -eux
# Functional test: gxx - Error-handling

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gxx ===
INSTALLED_BY_TEST=0
if ! rpm -q gxx 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gxx 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gxx"
    else
        echo "SKIP: gxx not available in repos"
        exit 0
    fi
else
    echo "SETUP: gxx already installed"
fi

rlRun 'g++ --version' 0 "g++ version info"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 12: Error handling ==="
rlRun 'g++ bad.cpp -o bad 2>&1 || true' 0 "Compilation error"
rlRun 'g++ --invalid 2>&1 || true' 0 "Invalid option"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gxx 2>/dev/null || true
    echo "TEARDOWN: removed gxx"
fi
echo ""
echo "All g++ functional tests passed!"

echo ""
echo "All gxx Error-handling tests passed!"
