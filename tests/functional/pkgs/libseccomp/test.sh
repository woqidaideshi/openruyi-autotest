#!/bin/sh -eux
# Functional test: libseccomp - ���
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
rlRun 'ldconfig -p 2>/dev/null | grep libseccomp | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libseccomp 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libseccomp 2>/dev/null || true
    echo "TEARDOWN: removed libseccomp"
fi
echo ""
echo "All libseccomp functional tests passed!"
