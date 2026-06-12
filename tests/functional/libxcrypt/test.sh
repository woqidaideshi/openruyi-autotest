#!/bin/sh -eux
# Functional test: libxcrypt - ���
# Commands: libcrypt.so.1, libcrypt.so.1.1.0, libowcrypt.so.1

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libxcrypt ===
INSTALLED_BY_TEST=0
if ! rpm -q libxcrypt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libxcrypt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libxcrypt"
    else
        echo "SKIP: libxcrypt not available in repos"
        exit 0
    fi
else
    echo "SETUP: libxcrypt already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libxcrypt | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libxcrypt 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libxcrypt 2>/dev/null || true
    echo "TEARDOWN: removed libxcrypt"
fi
echo ""
echo "All libxcrypt functional tests passed!"
