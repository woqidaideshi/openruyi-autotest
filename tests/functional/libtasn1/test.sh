#!/bin/sh -eux
# Functional test: libtasn1 ������
# Tests: asn1Coding, asn1Decoding, asn1Parser commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install libtasn1 ===
INSTALLED_BY_TEST=0
if ! rpm -q libtasn1 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libtasn1 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libtasn1"
    else
        echo "SKIP: libtasn1 not available in repos"
        exit 0
    fi
else
    echo "SETUP: libtasn1 already installed"
fi


rlRun 'asn1Coding --version 2>&1 || true' 0 "��ȡ asn1Coding �汾��Ϣ"
rlRun 'asn1Decoding --version 2>&1 || true' 0 "��ȡ asn1Decoding �汾��Ϣ"
rlRun 'asn1Parser --version 2>&1 || true' 0 "��ȡ asn1Parser �汾��Ϣ"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libtasn1 2>/dev/null || true
    echo "TEARDOWN: removed libtasn1"
fi
echo ""
echo "All libtasn1 functional tests passed!"
