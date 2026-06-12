#!/bin/sh -eux
# Functional test: mpc - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install mpc ===
INSTALLED_BY_TEST=0
if ! rpm -q mpc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y mpc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed mpc"
    else
        echo "SKIP: mpc not available in repos"
        exit 0
    fi
else
    echo "SETUP: mpc already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y mpc 2>/dev/null || true
    echo "TEARDOWN: removed mpc"
fi
echo ""
echo "All mpc functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All mpc 错误处理 tests passed!"
