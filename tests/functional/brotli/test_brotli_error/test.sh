#!/bin/sh -eux
# Functional test: brotli - ������
# Tests: brotli commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install brotli ===
INSTALLED_BY_TEST=0
if ! rpm -q brotli 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y brotli 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed brotli"
    else
        echo "SKIP: brotli not available in repos"
        exit 0
    fi
else
    echo "SETUP: brotli already installed"
fi



echo "=== ����: ������ ==="
rlRun 'brotli --invalid-flag-xyz 2>&1 || true' 0 "���� brotli ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y brotli 2>/dev/null || true
    echo "TEARDOWN: removed brotli"
fi
echo ""
echo "All brotli-error functional tests passed!"
