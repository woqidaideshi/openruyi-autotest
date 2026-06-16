#!/bin/sh -eux
# Functional test: gcc16 ��������
# Commands: gcc-16, g++-16

. "../setup.sh"

rlRun 'TmpDir=$(mktemp -d)' 0 "������ʱĿ¼"
rlRun 'cd $TmpDir' 0 "�������Ŀ¼"
rlRun 'echo "int main(){return 0;}" > test.c' 0 "��������Դ��"
rlRun 'gcc-16 -o test test.c' 0 "���� C ����"
rlRun './test' 0 "���б����ĳ���"

. "../teardown.sh"
echo "All gcc16-basic functional tests passed!"
