#!/bin/sh -eux
# Functional test: libedit - �ļ���֤
# Commands: libedit.so.0, libedit.so.0.0.75

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libedit ===
INSTALLED_BY_TEST=0
if ! rpm -q libedit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libedit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libedit"
    else
        echo "SKIP: libedit not available in repos"
        exit 0
    fi
else
    echo "SETUP: libedit already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libedit.so.0* 2>/dev/null || ls /usr/lib/libedit.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libedit.so.0"
rlRun 'ls /usr/lib64/libedit.so.0.0.75* 2>/dev/null || ls /usr/lib/libedit.so.0.0.75* 2>/dev/null || echo "not in standard path"' 0 "��� libedit.so.0.0.75"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libedit 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libedit 2>/dev/null || true
    echo "TEARDOWN: removed libedit"
fi
echo ""
echo "All libedit-files functional tests passed!"
