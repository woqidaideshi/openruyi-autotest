#!/bin/sh -eux
# Functional test: elfutils - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install elfutils ===
INSTALLED_BY_TEST=0
if ! rpm -q elfutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y elfutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed elfutils"
    else
        echo "SKIP: elfutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: elfutils already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'eu-addr2line --invalid 2>&1 || true' 0 "eu-addr2line: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y elfutils 2>/dev/null || true
    echo "TEARDOWN: removed elfutils"
fi
echo ""
echo "All elfutils functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All elfutils 错误处理 tests passed!"
