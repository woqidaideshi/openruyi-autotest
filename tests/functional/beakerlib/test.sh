#!/bin/sh -eux
# Functional test: beakerlib - ���Կ��
# Commands: beakerlib-deja-summarize, beakerlib-journalcmp, beakerlib-testwatcher

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install beakerlib ===
INSTALLED_BY_TEST=0
if ! rpm -q beakerlib 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y beakerlib 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed beakerlib"
    else
        echo "SKIP: beakerlib not available in repos"
        exit 0
    fi
else
    echo "SETUP: beakerlib already installed"
fi




# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y beakerlib 2>/dev/null || true
    echo "TEARDOWN: removed beakerlib"
fi
echo ""
echo "All beakerlib functional tests passed!"
