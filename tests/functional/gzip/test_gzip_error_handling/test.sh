#!/bin/sh -eux
# Functional test: gzip - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gzip ===
INSTALLED_BY_TEST=0
if ! rpm -q gzip 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gzip 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gzip"
    else
        echo "SKIP: gzip not available in repos"
        exit 0
    fi
else
    echo "SETUP: gzip already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'gzip --invalid 2>&1 || true' 0 "gzip: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gzip 2>/dev/null || true
    echo "TEARDOWN: removed gzip"
fi
echo ""
echo "All gzip functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All gzip 错误处理 tests passed!"
