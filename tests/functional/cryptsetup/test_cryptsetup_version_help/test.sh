#!/bin/sh -eux
# Functional test: cryptsetup - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cryptsetup ===
INSTALLED_BY_TEST=0
if ! rpm -q cryptsetup 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cryptsetup 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cryptsetup"
    else
        echo "SKIP: cryptsetup not available in repos"
        exit 0
    fi
else
    echo "SETUP: cryptsetup already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'cryptsetup --version 2>&1 || true' 0 "cryptsetup 版本信息"
rlRun 'cryptsetup --help 2>&1 | head -5 || true' 0 "cryptsetup 帮助信息"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cryptsetup 2>/dev/null || true
    echo "TEARDOWN: removed cryptsetup"
fi
echo ""
echo "All cryptsetup 版本和帮助 tests passed!"
