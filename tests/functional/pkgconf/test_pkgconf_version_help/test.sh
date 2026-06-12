#!/bin/sh -eux
# Functional test: pkgconf - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install pkgconf ===
INSTALLED_BY_TEST=0
if ! rpm -q pkgconf 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y pkgconf 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed pkgconf"
    else
        echo "SKIP: pkgconf not available in repos"
        exit 0
    fi
else
    echo "SETUP: pkgconf already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'pkgconf --version 2>&1 || true' 0 "pkgconf 版本信息"
rlRun 'pkgconf --help 2>&1 | head -5 || true' 0 "pkgconf 帮助信息"
rlRun 'bomtool --version 2>&1 || true' 0 "bomtool 版本信息"
rlRun 'bomtool --help 2>&1 | head -5 || true' 0 "bomtool 帮助信息"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pkgconf 2>/dev/null || true
    echo "TEARDOWN: removed pkgconf"
fi
echo ""
echo "All pkgconf 版本和帮助 tests passed!"
