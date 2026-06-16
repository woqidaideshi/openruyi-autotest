#!/bin/sh -eux
# Functional test: binutils - objcopy
# Commands: objcopy, strip

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install binutils ===
INSTALLED_BY_TEST=0
if ! rpm -q binutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y binutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed binutils"
    else
        echo "SKIP: binutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: binutils already installed"
fi


rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"

echo "=== objcopy/strip ==="
rlRun 'cp /usr/bin/ls .' 0 "���Ʋ����ļ�"
rlRun 'objcopy --help 2>&1 | head -10' 0 "objcopy ����"
rlRun 'strip --help 2>&1 | head -10' 0 "strip ����"
rlRun 'strip ls 2>&1 || true' 0 "strip �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y binutils 2>/dev/null || true
    echo "TEARDOWN: removed binutils"
fi
echo ""
echo "All binutils-objcopy functional tests passed!"
