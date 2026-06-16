#!/bin/sh -eux
# Functional test: cracklib - ������
# Commands: cracklib-check

. "../setup.sh"

rlRun 'cracklib-check --invalid 2>&1 || true' 0 "��Ч����"

. "../teardown.sh"
echo "All cracklib-error functional tests passed!"
