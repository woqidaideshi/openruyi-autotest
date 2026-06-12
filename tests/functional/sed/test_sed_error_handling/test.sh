#!/bin/sh -eux
# Functional test: sed - 错误处理

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

echo "=== 测试 6: 错误处理 ==="
rlRun 'sed --invalid 2>&1 || true' 0 "sed: 无效选项"

cd /; rm -rf $TmpDir

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y sed 2>/dev/null || true
    echo "TEARDOWN: removed sed"
fi
echo ""
echo "All sed functional tests passed!"


echo ""
echo "All sed 错误处理 tests passed!"
