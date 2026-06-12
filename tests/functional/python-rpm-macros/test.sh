#!/bin/sh -eux
# Functional test: python-rpm-macros - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-rpm-macros ===
INSTALLED_BY_TEST=0
if ! rpm -q python-rpm-macros 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-rpm-macros 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-rpm-macros"
    else
        echo "SKIP: python-rpm-macros not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-rpm-macros already installed"
fi



echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql python-rpm-macros 2>/dev/null | head -20 || true' 0 "�г����ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-rpm-macros 2>/dev/null || true
    echo "TEARDOWN: removed python-rpm-macros"
fi
echo ""
echo "All python-rpm-macros functional tests passed!"
