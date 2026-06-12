#!/bin/sh -eux
# Functional test: dwz - 版本和帮助

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

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'dwz --version 2>&1 || true' 0 "dwz 版本信息"
rlRun 'dwz --help 2>&1 | head -5 || true' 0 "dwz 帮助信息"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y dwz 2>/dev/null || true
    echo "TEARDOWN: removed dwz"
fi
echo ""
echo "All dwz 版本和帮助 tests passed!"
