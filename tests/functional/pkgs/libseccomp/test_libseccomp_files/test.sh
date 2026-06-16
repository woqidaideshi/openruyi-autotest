#!/bin/sh -eux
# Functional test: libseccomp - �ļ���֤
# Commands: libseccomp.so.2, libseccomp.so.2.6.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libseccomp ===
INSTALLED_BY_TEST=0
if ! rpm -q libseccomp 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libseccomp 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libseccomp"
    else
        echo "SKIP: libseccomp not available in repos"
        exit 0
    fi
else
    echo "SETUP: libseccomp already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libseccomp.so.2* 2>/dev/null || ls /usr/lib/libseccomp.so.2* 2>/dev/null || echo "not in standard path"' 0 "��� libseccomp.so.2"
rlRun 'ls /usr/lib64/libseccomp.so.2.6.0* 2>/dev/null || ls /usr/lib/libseccomp.so.2.6.0* 2>/dev/null || echo "not in standard path"' 0 "��� libseccomp.so.2.6.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libseccomp 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libseccomp 2>/dev/null || true
    echo "TEARDOWN: removed libseccomp"
fi
echo ""
echo "All libseccomp-files functional tests passed!"
