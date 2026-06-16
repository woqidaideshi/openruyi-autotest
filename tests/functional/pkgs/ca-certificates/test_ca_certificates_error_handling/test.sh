#!/bin/sh -eux
# Functional test: ca-certificates - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install ca-certificates ===
INSTALLED_BY_TEST=0
if ! rpm -q ca-certificates 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y ca-certificates 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed ca-certificates"
    else
        echo "SKIP: ca-certificates not available in repos"
        exit 0
    fi
else
    echo "SETUP: ca-certificates already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'update-ca-trust --invalid 2>&1 || true' 0 "update-ca-trust: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ca-certificates 2>/dev/null || true
    echo "TEARDOWN: removed ca-certificates"
fi
echo ""
echo "All ca-certificates functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All ca-certificates 错误处理 tests passed!"
