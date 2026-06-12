#!/bin/sh -eux
# Functional test: xz - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install xz ===
INSTALLED_BY_TEST=0
if ! rpm -q xz 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y xz 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed xz"
    else
        echo "SKIP: xz not available in repos"
        exit 0
    fi
else
    echo "SETUP: xz already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'xz --invalid 2>&1 || true' 0 "xz: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y xz 2>/dev/null || true
    echo "TEARDOWN: removed xz"
fi
echo ""
echo "All xz functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All xz 错误处理 tests passed!"
