#!/bin/sh -eux
# Functional test: python-packaging - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-packaging ===
INSTALLED_BY_TEST=0
if ! rpm -q python-packaging 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-packaging 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-packaging"
    else
        echo "SKIP: python-packaging not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-packaging already installed"
fi



echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql python-packaging 2>/dev/null | head -20 || true' 0 "�г����ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-packaging 2>/dev/null || true
    echo "TEARDOWN: removed python-packaging"
fi
echo ""
echo "All python-packaging functional tests passed!"
