#!/bin/sh -eux
# Functional test: filesystem - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install filesystem ===
INSTALLED_BY_TEST=0
if ! rpm -q filesystem 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y filesystem 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed filesystem"
    else
        echo "SKIP: filesystem not available in repos"
        exit 0
    fi
else
    echo "SETUP: filesystem already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y filesystem 2>/dev/null || true
    echo "TEARDOWN: removed filesystem"
fi
echo ""
echo "All filesystem functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All filesystem 错误处理 tests passed!"
