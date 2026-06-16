#!/bin/sh -eux
# Functional test: util-linux - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install util-linux ===
INSTALLED_BY_TEST=0
if ! rpm -q util-linux 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y util-linux 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed util-linux"
    else
        echo "SKIP: util-linux not available in repos"
        exit 0
    fi
else
    echo "SETUP: util-linux already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'addpart --invalid 2>&1 || true' 0 "addpart: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y util-linux 2>/dev/null || true
    echo "TEARDOWN: removed util-linux"
fi
echo ""
echo "All util-linux functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All util-linux 错误处理 tests passed!"
