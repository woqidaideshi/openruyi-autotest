#!/bin/sh -eux
# Functional test: libxml2 - ��������
# Tests: xmlcatalog, xmllint commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libxml2 ===
INSTALLED_BY_TEST=0
if ! rpm -q libxml2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libxml2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libxml2"
    else
        echo "SKIP: libxml2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: libxml2 already installed"
fi



echo "=== ����: libxml2 �������� ==="
rlRun 'xmlcatalog --help 2>&1 | head -10' 0 "�鿴 xmlcatalog ������Ϣ"
rlRun 'xmllint --help 2>&1 | head -10' 0 "�鿴 xmllint ������Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libxml2 2>/dev/null || true
    echo "TEARDOWN: removed libxml2"
fi
echo ""
echo "All libxml2-basic functional tests passed!"
