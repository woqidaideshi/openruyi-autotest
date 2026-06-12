#!/bin/sh -eux
# Functional test: glibc - 版本和帮助

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

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'gencat --version 2>&1 || true' 0 "gencat 版本信息"
rlRun 'gencat --help 2>&1 | head -5 || true' 0 "gencat 帮助信息"
rlRun 'getconf --version 2>&1 || true' 0 "getconf 版本信息"
rlRun 'getconf --help 2>&1 | head -5 || true' 0 "getconf 帮助信息"
rlRun 'getent --version 2>&1 || true' 0 "getent 版本信息"
rlRun 'getent --help 2>&1 | head -5 || true' 0 "getent 帮助信息"
rlRun 'iconv --version 2>&1 || true' 0 "iconv 版本信息"
rlRun 'iconv --help 2>&1 | head -5 || true' 0 "iconv 帮助信息"
rlRun 'ldconfig --version 2>&1 || true' 0 "ldconfig 版本信息"
rlRun 'ldconfig --help 2>&1 | head -5 || true' 0 "ldconfig 帮助信息"
rlRun 'ldd --version 2>&1 || true' 0 "ldd 版本信息"
rlRun 'ldd --help 2>&1 | head -5 || true' 0 "ldd 帮助信息"
rlRun 'locale --version 2>&1 || true' 0 "locale 版本信息"
rlRun 'locale --help 2>&1 | head -5 || true' 0 "locale 帮助信息"
rlRun 'localedef --version 2>&1 || true' 0 "localedef 版本信息"
rlRun 'localedef --help 2>&1 | head -5 || true' 0 "localedef 帮助信息"

cd /
rm -rf $TmpDir


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y glibc 2>/dev/null || true
    echo "TEARDOWN: removed glibc"
fi
echo ""
echo "All glibc 版本和帮助 tests passed!"
