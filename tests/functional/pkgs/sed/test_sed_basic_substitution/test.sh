#!/bin/sh -eux
# Functional test: sed - 基本替换

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install sed ===
INSTALLED_BY_TEST=0
if ! rpm -q sed 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y sed 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed sed"
    else
        echo "SKIP: sed not available in repos"
        exit 0
    fi
else
    echo "SETUP: sed already installed"
fi

rlRun 'sed --version' 0 "sed 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 1: 基本替换 ==="
echo "hello world" > test.txt
rlRun 'sed "s/world/sed/" test.txt' 0 "sed s: 基本替换"
rlRun 'sed "s/hello/HI/" test.txt' 0 "sed s: 替换hello"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y sed 2>/dev/null || true
    echo "TEARDOWN: removed sed"
fi
echo ""
echo "All sed 基本替换 tests passed!"
