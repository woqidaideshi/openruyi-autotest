#!/bin/sh -eux
# Functional test: gxx - Debug-and-warnings

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

echo "=== Test 5: Debug and warnings ==="
rlRun 'g++ -g -c hello.cpp -o hello_g.o' 0 "Debug symbols"
rlRun 'g++ -Wall -c hello.cpp -o hello_Wall.o' 0 "-Wall warnings"
rlRun 'g++ -Wextra -c hello.cpp -o hello_Wextra.o' 0 "-Wextra warnings"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gxx 2>/dev/null || true
    echo "TEARDOWN: removed gxx"
fi
echo ""
echo "All gxx Debug-and-warnings tests passed!"
