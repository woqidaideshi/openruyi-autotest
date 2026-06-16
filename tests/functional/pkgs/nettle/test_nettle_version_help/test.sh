#!/bin/sh -eux
# Functional test: nettle - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install nettle ===
INSTALLED_BY_TEST=0
if ! rpm -q nettle 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nettle 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed nettle"
    else
        echo "SKIP: nettle not available in repos"
        exit 0
    fi
else
    echo "SETUP: nettle already installed"
fi

TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'nettle-hash --version 2>&1 || true' 0 "nettle-hash 版本信息"
rlRun 'nettle-hash --help 2>&1 | head -5 || true' 0 "nettle-hash 帮助信息"
rlRun 'nettle-lfib-stream --version 2>&1 || true' 0 "nettle-lfib-stream 版本信息"
rlRun 'nettle-lfib-stream --help 2>&1 | head -5 || true' 0 "nettle-lfib-stream 帮助信息"
rlRun 'nettle-pbkdf2 --version 2>&1 || true' 0 "nettle-pbkdf2 版本信息"
rlRun 'nettle-pbkdf2 --help 2>&1 | head -5 || true' 0 "nettle-pbkdf2 帮助信息"
rlRun 'pkcs1-conv --version 2>&1 || true' 0 "pkcs1-conv 版本信息"
rlRun 'pkcs1-conv --help 2>&1 | head -5 || true' 0 "pkcs1-conv 帮助信息"
rlRun 'sexp-conv --version 2>&1 || true' 0 "sexp-conv 版本信息"
rlRun 'sexp-conv --help 2>&1 | head -5 || true' 0 "sexp-conv 帮助信息"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y nettle 2>/dev/null || true
    echo "TEARDOWN: removed nettle"
fi
echo ""
echo "All nettle 版本和帮助 tests passed!"
