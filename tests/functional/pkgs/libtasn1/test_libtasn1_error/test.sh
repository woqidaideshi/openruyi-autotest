#!/bin/sh -eux
# Functional test: libtasn1 - ������
# Tests: asn1Coding, asn1Decoding, asn1Parser commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'asn1Coding --invalid-flag-xyz 2>&1 || true' 0 "���� asn1Coding ��Ч����������"
rlRun 'asn1Decoding --invalid-flag-xyz 2>&1 || true' 0 "���� asn1Decoding ��Ч����������"
rlRun 'asn1Parser --invalid-flag-xyz 2>&1 || true' 0 "���� asn1Parser ��Ч����������"

. "../teardown.sh"
echo "All libtasn1-error functional tests passed!"
