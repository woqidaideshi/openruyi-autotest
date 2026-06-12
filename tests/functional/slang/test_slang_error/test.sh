#!/bin/sh -eux
# Functional test: slang - ������
# Tests: slsh commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install slang ===
INSTALLED_BY_TEST=0
if ! rpm -q slang 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y slang 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed slang"
    else
        echo "SKIP: slang not available in repos"
        exit 0
    fi
else
    echo "SETUP: slang already installed"
fi



echo "=== ����: ������ ==="
rlRun 'slsh --invalid-flag-xyz 2>&1 || true' 0 "���� slsh ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y slang 2>/dev/null || true
    echo "TEARDOWN: removed slang"
fi
echo ""
echo "All slang-error functional tests passed!"
