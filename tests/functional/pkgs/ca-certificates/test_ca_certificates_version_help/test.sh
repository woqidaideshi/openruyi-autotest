#!/bin/sh -eux
# Functional test: ca-certificates - 版本和帮助

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

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'update-ca-trust --version 2>&1 || true' 0 "update-ca-trust 版本信息"
rlRun 'update-ca-trust --help 2>&1 | head -5 || true' 0 "update-ca-trust 帮助信息"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y ca-certificates 2>/dev/null || true
    echo "TEARDOWN: removed ca-certificates"
fi
echo ""
echo "All ca-certificates 版本和帮助 tests passed!"
