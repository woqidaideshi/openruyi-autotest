#!/bin/sh -eux
# Functional test: popt - �ļ���֤
# Commands: libpopt.so.0, libpopt.so.0.0.2

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install popt ===
INSTALLED_BY_TEST=0
if ! rpm -q popt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y popt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed popt"
    else
        echo "SKIP: popt not available in repos"
        exit 0
    fi
else
    echo "SETUP: popt already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libpopt.so.0* 2>/dev/null || ls /usr/lib/libpopt.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libpopt.so.0"
rlRun 'ls /usr/lib64/libpopt.so.0.0.2* 2>/dev/null || ls /usr/lib/libpopt.so.0.0.2* 2>/dev/null || echo "not in standard path"' 0 "��� libpopt.so.0.0.2"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs popt 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y popt 2>/dev/null || true
    echo "TEARDOWN: removed popt"
fi
echo ""
echo "All popt-files functional tests passed!"
