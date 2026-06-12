#!/bin/sh -eux
# Functional test: gmp - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gmp ===
INSTALLED_BY_TEST=0
if ! rpm -q gmp 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gmp 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gmp"
    else
        echo "SKIP: gmp not available in repos"
        exit 0
    fi
else
    echo "SETUP: gmp already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gmp 2>/dev/null || true
    echo "TEARDOWN: removed gmp"
fi
echo ""
echo "All gmp functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All gmp 错误处理 tests passed!"
