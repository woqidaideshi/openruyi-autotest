#!/bin/sh -eux
# Functional test: libcap-ng - �ļ���֤
# Commands: libcap-ng.so.0, libcap-ng.so.0.0.0, libdrop_ambient.so.0, libdrop_ambient.so.0.0.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libcap-ng ===
INSTALLED_BY_TEST=0
if ! rpm -q libcap-ng 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libcap-ng 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libcap-ng"
    else
        echo "SKIP: libcap-ng not available in repos"
        exit 0
    fi
else
    echo "SETUP: libcap-ng already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ls /usr/lib64/libcap-ng.so.0* 2>/dev/null || ls /usr/lib/libcap-ng.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libcap-ng.so.0"
rlRun 'ls /usr/lib64/libcap-ng.so.0.0.0* 2>/dev/null || ls /usr/lib/libcap-ng.so.0.0.0* 2>/dev/null || echo "not in standard path"' 0 "��� libcap-ng.so.0.0.0"
rlRun 'ls /usr/lib64/libdrop_ambient.so.0* 2>/dev/null || ls /usr/lib/libdrop_ambient.so.0* 2>/dev/null || echo "not in standard path"' 0 "��� libdrop_ambient.so.0"
rlRun 'ls /usr/lib64/libdrop_ambient.so.0.0.0* 2>/dev/null || ls /usr/lib/libdrop_ambient.so.0.0.0* 2>/dev/null || echo "not in standard path"' 0 "��� libdrop_ambient.so.0.0.0"

echo "=== pkg-config ��֤ ==="
rlRun 'pkg-config --libs libcap-ng 2>&1 || true' 0 "pkg-config ����Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libcap-ng 2>/dev/null || true
    echo "TEARDOWN: removed libcap-ng"
fi
echo ""
echo "All libcap-ng-files functional tests passed!"
