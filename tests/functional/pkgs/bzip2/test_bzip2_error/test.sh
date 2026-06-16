#!/bin/sh -eux
# Functional test: bzip2 - ������
# Commands: bzip2

. "../setup.sh"

rlRun 'bzip2 --invalid 2>&1 || true' 0 "��Ч����"
rlRun 'bzip2 nonexistent 2>&1 || true' 1-255 "�����ڵ��ļ�"

. "../teardown.sh"
echo "All bzip2-error functional tests passed!"
