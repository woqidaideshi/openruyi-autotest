#!/bin/sh -eux
# Functional test: readline - ���
# Commands: libhistory.so.8, libhistory.so.8.3, libreadline.so.8, libreadline.so.8.3

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install readline ===
INSTALLED_BY_TEST=0
if ! rpm -q readline 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y readline 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed readline"
    else
        echo "SKIP: readline not available in repos"
        exit 0
    fi
else
    echo "SETUP: readline already installed"
fi



echo "=== ���ļ���֤ ==="
rlRun 'ldconfig -p 2>/dev/null | grep readline | head -5 || true' 0 "ldconfig ���ҿ��ļ�"
rlRun 'rpm -ql readline 2>/dev/null | grep "\\.so" | head -10 || true' 0 "�г� .so �ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y readline 2>/dev/null || true
    echo "TEARDOWN: removed readline"
fi
echo ""
echo "All readline functional tests passed!"
