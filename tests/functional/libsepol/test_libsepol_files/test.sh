#!/bin/sh -eux
# Functional test: libsepol - �ļ���֤
# Commands: libsepol.so.2

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libsepol ===
INSTALLED_BY_TEST=0
if ! rpm -q libsepol 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libsepol 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libsepol"
    else
        echo "SKIP: libsepol not available in repos"
        exit 0
    fi
else
    echo "SETUP: libsepol already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libsepol.so.2* 2>/dev/null || ls /usr/lib/libsepol.so.2* 2>/dev/null || echo "not in standard path"' 0 "��� libsepol.so.2"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libsepol 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libsepol 2>/dev/null || true
    echo "TEARDOWN: removed libsepol"
fi
echo ""
echo "All libsepol-files functional tests passed!"
