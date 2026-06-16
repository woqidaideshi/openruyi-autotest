#!/bin/sh -eux
# Functional test: openssl - ������
# Commands: openssl

. "../setup.sh"

rlRun 'openssl --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'openssl dgst -invalid nonexistent 2>&1 || true' 1-255 "��ЧժҪ�㷨"

. "../teardown.sh"
echo "All openssl-error functional tests passed!"
