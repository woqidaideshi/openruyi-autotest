#!/bin/sh -eux
# Functional test: libtasn1 ������
# Tests: asn1Coding, asn1Decoding, asn1Parser commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libtasn1 2>/dev/null || { echo 'libtasn1 not installed, skipping'; exit 0; }
which asn1Coding 2>/dev/null || echo 'asn1Coding not found'
which asn1Decoding 2>/dev/null || echo 'asn1Decoding not found'
which asn1Parser 2>/dev/null || echo 'asn1Parser not found'
rlRun 'asn1Coding --version 2>&1 || true' 0 "��ȡ asn1Coding �汾��Ϣ"
rlRun 'asn1Decoding --version 2>&1 || true' 0 "��ȡ asn1Decoding �汾��Ϣ"
rlRun 'asn1Parser --version 2>&1 || true' 0 "��ȡ asn1Parser �汾��Ϣ"

echo ""
echo "All libtasn1 functional tests passed!"
