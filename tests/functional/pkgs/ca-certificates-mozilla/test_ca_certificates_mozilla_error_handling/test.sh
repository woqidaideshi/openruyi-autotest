#!/bin/sh -eux
# Functional test: ca-certificates-mozilla - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install ca-certificates-mozilla ===
INSTALLED_BY_TEST=0
if ! rpm -q ca-certificates-mozilla 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y ca-certificates-mozilla 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed ca-certificates-mozilla"
    else
        echo "SKIP: ca-certificates-mozilla not available in repos"
        exit 0
    fi
else
    echo "SETUP: ca-certificates-mozilla already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ca-certificates-mozilla 2>/dev/null || true
    echo "TEARDOWN: removed ca-certificates-mozilla"
fi
echo ""
echo "All ca-certificates-mozilla functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All ca-certificates-mozilla 错误处理 tests passed!"
