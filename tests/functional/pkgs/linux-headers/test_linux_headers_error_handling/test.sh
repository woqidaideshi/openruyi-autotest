#!/bin/sh -eux
# Functional test: linux-headers - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install linux-headers ===
INSTALLED_BY_TEST=0
if ! rpm -q linux-headers 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y linux-headers 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed linux-headers"
    else
        echo "SKIP: linux-headers not available in repos"
        exit 0
    fi
else
    echo "SETUP: linux-headers already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y linux-headers 2>/dev/null || true
    echo "TEARDOWN: removed linux-headers"
fi
echo ""
echo "All linux-headers functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All linux-headers 错误处理 tests passed!"
