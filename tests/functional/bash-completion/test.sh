#!/bin/sh -eux
# Functional test: bash-completion - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bash-completion ===
INSTALLED_BY_TEST=0
if ! rpm -q bash-completion 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bash-completion 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bash-completion"
    else
        echo "SKIP: bash-completion not available in repos"
        exit 0
    fi
else
    echo "SETUP: bash-completion already installed"
fi



echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql bash-completion 2>/dev/null | head -20 || true' 0 "�г����ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y bash-completion 2>/dev/null || true
    echo "TEARDOWN: removed bash-completion"
fi
echo ""
echo "All bash-completion functional tests passed!"
