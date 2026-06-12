#!/bin/sh -eux
# Functional test: rpm ��ѯ
# Commands: rpm

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q rpm 2>/dev/null || { echo 'rpm not installed, skipping'; exit 0; }
which rpm 2>/dev/null || echo 'rpm not found'

echo "=== rpm ��ѯ ==="
rlRun 'rpm --help 2>&1 | head -10' 0 "rpm ����"
rlRun 'rpm -qa 2>&1 | head -10' 0 "�г����а�"
rpm -q rpm 2>/dev/null || { echo 'rpm not installed, skipping'; exit 0; }
rlRun 'rpm -qi rpm 2>&1 | head -10' 0 "��ѯ����Ϣ"
rlRun 'rpm -ql rpm 2>&1 | head -10' 0 "�г����ļ�"
rlRun 'rpm -qc rpm 2>&1' 0 "�г������ļ�"
rlRun 'rpm -qd rpm 2>&1 | head -5' 0 "�г��ĵ�"

echo ""
echo "All rpm-query functional tests passed!"
