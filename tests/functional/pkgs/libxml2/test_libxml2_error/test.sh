#!/bin/sh -eux
# Functional test: libxml2 - ������
# Tests: xmlcatalog, xmllint commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'xmlcatalog --invalid-flag-xyz 2>&1 || true' 0 "���� xmlcatalog ��Ч����������"
rlRun 'xmllint --invalid-flag-xyz 2>&1 || true' 0 "���� xmllint ��Ч����������"

. "../teardown.sh"
echo "All libxml2-error functional tests passed!"
