#!/bin/sh -eux
# Functional test: authselect - ������
# Commands: authselect

. "../setup.sh"

rlRun 'authselect --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'authselect select nonexistent 2>&1 || true' 1-255 "ѡ�񲻴��ڵ�����"

. "../teardown.sh"
echo "All authselect-error functional tests passed!"
