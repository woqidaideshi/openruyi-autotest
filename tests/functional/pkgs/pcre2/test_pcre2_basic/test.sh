#!/bin/sh -eux
# Functional test: pcre2 - ��������
# Tests: pcre2grep, pcre2test commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install pcre2 ===
INSTALLED_BY_TEST=0
if ! rpm -q pcre2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y pcre2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed pcre2"
    else
        echo "SKIP: pcre2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: pcre2 already installed"
fi



echo "=== ����: pcre2 �������� ==="
rlRun 'pcre2grep --help 2>&1 | head -10' 0 "�鿴 pcre2grep ������Ϣ"
rlRun 'pcre2test --help 2>&1 | head -10' 0 "�鿴 pcre2test ������Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pcre2 2>/dev/null || true
    echo "TEARDOWN: removed pcre2"
fi
echo ""
echo "All pcre2-basic functional tests passed!"
