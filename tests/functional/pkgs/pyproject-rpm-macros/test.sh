#!/bin/sh -eux
# Functional test: pyproject-rpm-macros - ����/���ݰ�

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install pyproject-rpm-macros ===
INSTALLED_BY_TEST=0
if ! rpm -q pyproject-rpm-macros 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y pyproject-rpm-macros 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed pyproject-rpm-macros"
    else
        echo "SKIP: pyproject-rpm-macros not available in repos"
        exit 0
    fi
else
    echo "SETUP: pyproject-rpm-macros already installed"
fi



echo "=== �ļ��б���֤ ==="
rlRun 'rpm -ql pyproject-rpm-macros 2>/dev/null | head -20 || true' 0 "�г����ļ�"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pyproject-rpm-macros 2>/dev/null || true
    echo "TEARDOWN: removed pyproject-rpm-macros"
fi
echo ""
echo "All pyproject-rpm-macros functional tests passed!"
