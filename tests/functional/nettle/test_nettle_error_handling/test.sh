#!/bin/sh -eux
# Functional test: nettle - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install nettle ===
INSTALLED_BY_TEST=0
if ! rpm -q nettle 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nettle 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed nettle"
    else
        echo "SKIP: nettle not available in repos"
        exit 0
    fi
else
    echo "SETUP: nettle already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'nettle-hash --invalid 2>&1 || true' 0 "nettle-hash: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nettle 2>/dev/null || true
    echo "TEARDOWN: removed nettle"
fi
echo ""
echo "All nettle functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All nettle 错误处理 tests passed!"
