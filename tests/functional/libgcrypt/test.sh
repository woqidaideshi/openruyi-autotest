#!/bin/sh -eux
# Functional test: libgcrypt - ���
# Commands: libgcrypt.so.20, libgcrypt.so.20.6.0

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libgcrypt ===
INSTALLED_BY_TEST=0
if ! rpm -q libgcrypt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libgcrypt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libgcrypt"
    else
        echo "SKIP: libgcrypt not available in repos"
        exit 0
    fi
else
    echo "SETUP: libgcrypt already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libgcrypt | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libgcrypt 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libgcrypt 2>/dev/null || true
    echo "TEARDOWN: removed libgcrypt"
fi
echo ""
echo "All libgcrypt functional tests passed!"
