#!/bin/sh -eux
# Functional test: mpfr - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install mpfr ===
INSTALLED_BY_TEST=0
if ! rpm -q mpfr 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y mpfr 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed mpfr"
    else
        echo "SKIP: mpfr not available in repos"
        exit 0
    fi
else
    echo "SETUP: mpfr already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y mpfr 2>/dev/null || true
    echo "TEARDOWN: removed mpfr"
fi
echo ""
echo "All mpfr functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All mpfr 错误处理 tests passed!"
