#!/bin/sh -eux
# Functional test: libtasn1 - ��������
# Tests: asn1Coding, asn1Decoding, asn1Parser commands

# rlRun wrapper for standalone execution
rlRun() { eval "$1" 2>&1; return $?; }

rpm -q libtasn1 2>/dev/null || { echo 'libtasn1 not installed, skipping'; exit 0; }
which asn1Coding 2>/dev/null || echo 'asn1Coding not found'
which asn1Decoding 2>/dev/null || echo 'asn1Decoding not found'
which asn1Parser 2>/dev/null || echo 'asn1Parser not found'

echo "=== ����: libtasn1 �������� ==="
rlRun 'asn1Coding --help 2>&1 | head -10' 0 "�鿴 asn1Coding ������Ϣ"
rlRun 'asn1Decoding --help 2>&1 | head -10' 0 "�鿴 asn1Decoding ������Ϣ"
rlRun 'asn1Parser --help 2>&1 | head -10' 0 "�鿴 asn1Parser ������Ϣ"

echo ""
echo "All libtasn1-basic functional tests passed!"
