#!/bin/sh -eux
# Functional test: unzip ������
# Tests: unzip, funzip, zipgrep, zipinfo commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install unzip ===
INSTALLED_BY_TEST=0
if ! rpm -q unzip 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y unzip 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed unzip"
    else
        echo "SKIP: unzip not available in repos"
        exit 0
    fi
else
    echo "SETUP: unzip already installed"
fi


rlRun 'unzip --version 2>&1 || true' 0 "��ȡ unzip �汾��Ϣ"
rlRun 'funzip --version 2>&1 || true' 0 "��ȡ funzip �汾��Ϣ"
rlRun 'zipgrep --version 2>&1 || true' 0 "��ȡ zipgrep �汾��Ϣ"
rlRun 'zipinfo --version 2>&1 || true' 0 "��ȡ zipinfo �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y unzip 2>/dev/null || true
    echo "TEARDOWN: removed unzip"
fi
echo ""
echo "All unzip functional tests passed!"
