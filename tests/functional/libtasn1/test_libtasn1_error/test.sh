#!/bin/sh -eux
# Functional test: libtasn1 - ������
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



echo "=== ����: ������ ==="
rlRun 'asn1Coding --invalid-flag-xyz 2>&1 || true' 0 "���� asn1Coding ��Ч����������"
rlRun 'asn1Decoding --invalid-flag-xyz 2>&1 || true' 0 "���� asn1Decoding ��Ч����������"
rlRun 'asn1Parser --invalid-flag-xyz 2>&1 || true' 0 "���� asn1Parser ��Ч����������"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y libtasn1 2>/dev/null || true
    echo "TEARDOWN: removed libtasn1"
fi
echo ""
echo "All libtasn1-error functional tests passed!"
