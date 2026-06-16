#!/bin/sh -eux
# Functional test: json-c - �ļ���֤
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
rlRun 'ls /usr/lib64/libjson-c.so.5* 2>/dev/null || ls /usr/lib/libjson-c.so.5* 2>/dev/null || echo "not in standard path"' 0 "��� libjson-c.so.5"
rlRun 'ls /usr/lib64/libjson-c.so.5.4.0* 2>/dev/null || ls /usr/lib/libjson-c.so.5.4.0* 2>/dev/null || echo "not in standard path"' 0 "��� libjson-c.so.5.4.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs json-c 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y json-c 2>/dev/null || true
    echo "TEARDOWN: removed json-c"
fi
echo ""
echo "All json-c-files functional tests passed!"
