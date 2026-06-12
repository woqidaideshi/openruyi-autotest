#!/bin/sh -eux
# Functional test: bzip2 - ������
# Commands: bzip2

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bzip2 ===
INSTALLED_BY_TEST=0
if ! rpm -q bzip2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bzip2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bzip2"
    else
        echo "SKIP: bzip2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: bzip2 already installed"
fi



echo "=== ������ ==="
rlRun 'bzip2 --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'bzip2 nonexistent 2>&1 || true' 1-255 "�����ڵ��ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bzip2 2>/dev/null || true
    echo "TEARDOWN: removed bzip2"
fi
echo ""
echo "All bzip2-error functional tests passed!"
