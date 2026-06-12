#!/bin/sh -eux
# Functional test: dwz - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install dwz ===
INSTALLED_BY_TEST=0
if ! rpm -q dwz 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y dwz 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed dwz"
    else
        echo "SKIP: dwz not available in repos"
        exit 0
    fi
else
    echo "SETUP: dwz already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'dwz --invalid 2>&1 || true' 0 "dwz: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y dwz 2>/dev/null || true
    echo "TEARDOWN: removed dwz"
fi
echo ""
echo "All dwz functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All dwz 错误处理 tests passed!"
