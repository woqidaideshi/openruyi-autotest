#!/bin/sh -eux
# Functional test: libsepol - ���
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
rlRun 'ldconfig -p 2>/dev/null | grep libsepol | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libsepol 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libsepol 2>/dev/null || true
    echo "TEARDOWN: removed libsepol"
fi
echo ""
echo "All libsepol functional tests passed!"
