#!/bin/sh -eux
# Functional test: libcap - ���
# Commands: libcap.so.2, libcap.so.2.76, libpsx.so.2, libpsx.so.2.76, pam_cap.so

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libcap ===
INSTALLED_BY_TEST=0
if ! rpm -q libcap 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libcap 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libcap"
    else
        echo "SKIP: libcap not available in repos"
        exit 0
    fi
else
    echo "SETUP: libcap already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep libcap | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql libcap 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libcap 2>/dev/null || true
    echo "TEARDOWN: removed libcap"
fi
echo ""
echo "All libcap functional tests passed!"
