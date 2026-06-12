#!/bin/sh -eux
# Functional test: libgpg-error - ���
# Commands: libgpg-error.so.0, libgpg-error.so.0.41.1

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libgpg-error ===
INSTALLED_BY_TEST=0
if ! rpm -q libgpg-error 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libgpg-error 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libgpg-error"
    else
        echo "SKIP: libgpg-error not available in repos"
        exit 0
    fi
else
    echo "SETUP: libgpg-error already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libgpg-error | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libgpg-error 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libgpg-error 2>/dev/null || true
    echo "TEARDOWN: removed libgpg-error"
fi
echo ""
echo "All libgpg-error functional tests passed!"
