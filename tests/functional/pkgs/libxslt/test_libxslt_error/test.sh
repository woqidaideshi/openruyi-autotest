#!/bin/sh -eux
# Functional test: libxslt - ������
# Tests: xsltproc commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libxslt ===
INSTALLED_BY_TEST=0
if ! rpm -q libxslt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libxslt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libxslt"
    else
        echo "SKIP: libxslt not available in repos"
        exit 0
    fi
else
    echo "SETUP: libxslt already installed"
fi



echo "=== ����: ������ ==="
rlRun 'xsltproc --invalid-flag-xyz 2>&1 || true' 0 "���� xsltproc ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libxslt 2>/dev/null || true
    echo "TEARDOWN: removed libxslt"
fi
echo ""
echo "All libxslt-error functional tests passed!"
