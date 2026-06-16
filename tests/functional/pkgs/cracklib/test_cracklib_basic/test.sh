#!/bin/sh -eux
# Functional test: cracklib - ��������
# Commands: cracklib-check

. "../setup.sh"

rlRun 'echo "password" | cracklib-check' 0 "���������"
rlRun 'echo "Str0ng!Pass" | cracklib-check' 0 "���ǿ����"
rlRun 'echo "abc" | cracklib-check' 0 "��������"

. "../teardown.sh"
echo "All cracklib-basic functional tests passed!"
