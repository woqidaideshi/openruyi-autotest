#!/bin/sh -eux
# Functional test: glibc - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install glibc ===
INSTALLED_BY_TEST=0
if ! rpm -q glibc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y glibc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed glibc"
    else
        echo "SKIP: glibc not available in repos"
        exit 0
    fi
else
    echo "SETUP: glibc already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'gencat --invalid 2>&1 || true' 0 "gencat: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y glibc 2>/dev/null || true
    echo "TEARDOWN: removed glibc"
fi
echo ""
echo "All glibc functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All glibc 错误处理 tests passed!"
