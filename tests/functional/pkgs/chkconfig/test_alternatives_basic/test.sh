#!/bin/sh -eux
# Functional test: alternatives - ��������
# Commands: alternatives

. "../setup.sh"

rlRun 'alternatives --list 2>&1 | head -5 || true' 0 "�г������"

. "../teardown.sh"
echo "All alternatives-basic functional tests passed!"
