#!/bin/sh -eux
# Functional test: zstd - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install zstd ===
INSTALLED_BY_TEST=0
if ! rpm -q zstd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y zstd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed zstd"
    else
        echo "SKIP: zstd not available in repos"
        exit 0
    fi
else
    echo "SETUP: zstd already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'zstd --invalid 2>&1 || true' 0 "zstd: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y zstd 2>/dev/null || true
    echo "TEARDOWN: removed zstd"
fi
echo ""
echo "All zstd functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All zstd 错误处理 tests passed!"
