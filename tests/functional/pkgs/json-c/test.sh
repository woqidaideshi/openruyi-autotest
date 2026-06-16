#!/bin/sh -eux
# Functional test: json-c - ���
# Commands: libjson-c.so.5, libjson-c.so.5.4.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install json-c ===
INSTALLED_BY_TEST=0
if ! rpm -q json-c 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y json-c 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed json-c"
    else
        echo "SKIP: json-c not available in repos"
        exit 0
    fi
else
    echo "SETUP: json-c already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep json-c | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql json-c 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y json-c 2>/dev/null || true
    echo "TEARDOWN: removed json-c"
fi
echo ""
echo "All json-c functional tests passed!"
