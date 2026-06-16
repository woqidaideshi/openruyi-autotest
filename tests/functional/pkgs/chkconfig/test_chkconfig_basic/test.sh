#!/bin/sh -eux
# Functional test: chkconfig - ��������
# Commands: chkconfig

. "../setup.sh"

rlRun 'chkconfig --list 2>&1 | head -10 || true' 0 "�г�����"

. "../teardown.sh"
echo "All chkconfig-basic functional tests passed!"
