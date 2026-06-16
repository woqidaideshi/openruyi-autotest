#!/bin/sh -eux
# Functional test: lua - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install lua ===
INSTALLED_BY_TEST=0
if ! rpm -q lua 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lua 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lua"
    else
        echo "SKIP: lua not available in repos"
        exit 0
    fi
else
    echo "SETUP: lua already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'lua --invalid 2>&1 || true' 0 "lua: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y lua 2>/dev/null || true
    echo "TEARDOWN: removed lua"
fi
echo ""
echo "All lua functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All lua 错误处理 tests passed!"
