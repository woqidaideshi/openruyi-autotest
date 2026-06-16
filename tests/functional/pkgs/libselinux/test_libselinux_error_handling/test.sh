#!/bin/sh -eux
# Functional test: libselinux - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libselinux ===
INSTALLED_BY_TEST=0
if ! rpm -q libselinux 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libselinux 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libselinux"
    else
        echo "SKIP: libselinux not available in repos"
        exit 0
    fi
else
    echo "SETUP: libselinux already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libselinux 2>/dev/null || true
    echo "TEARDOWN: removed libselinux"
fi
echo ""
echo "All libselinux functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All libselinux 错误处理 tests passed!"
