#!/bin/sh -eux
# Functional test: clang - C---standards

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install clang ===
INSTALLED_BY_TEST=0
if ! rpm -q clang 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y clang 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed clang"
    else
        echo "SKIP: clang not available in repos"
        exit 0
    fi
else
    echo "SETUP: clang already installed"
fi

rlRun 'clang --version' 0 "clang version"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 7: C++ standards ==="
for std in c++11 c++14 c++17; do
    rlRun "clang++ -std=$std -x c++ -c hello.c -o cpp_$std.o" 0 "C++ standard: $std"
done



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y clang 2>/dev/null || true
    echo "TEARDOWN: removed clang"
fi
echo ""
echo "All clang C---standards tests passed!"
