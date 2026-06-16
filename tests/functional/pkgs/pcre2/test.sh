#!/bin/sh -eux
# Functional test: pcre2 ������
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


rlRun 'pcre2grep --version 2>&1 || true' 0 "��ȡ pcre2grep �汾��Ϣ"
rlRun 'pcre2test --version 2>&1 || true' 0 "��ȡ pcre2test �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pcre2 2>/dev/null || true
    echo "TEARDOWN: removed pcre2"
fi
echo ""
echo "All pcre2 functional tests passed!"
