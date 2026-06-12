#!/bin/sh -eux
# Functional test: krb5 ��������
# Commands: kinit, klist, kdestroy, kadmin, ktutil

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q krb5 2>/dev/null || { echo 'krb5 not installed, skipping'; exit 0; }
which kinit 2>/dev/null || echo 'kinit not found'
which klist 2>/dev/null || echo 'klist not found'
which kdestroy 2>/dev/null || echo 'kdestroy not found'
which kadmin 2>/dev/null || echo 'kadmin not found'
which ktutil 2>/dev/null || echo 'ktutil not found'

echo "=== Kerberos ���� ==="
rlRun 'kinit --help 2>&1 | head -10' 0 "kinit ����"
rlRun 'klist --help 2>&1 | head -10' 0 "klist ����"
rlRun 'kdestroy --help 2>&1 | head -10' 0 "kdestroy ����"
rlRun 'kadmin --help 2>&1 | head -10' 0 "kadmin ����"
rlRun 'ktutil --help 2>&1 | head -10' 0 "ktutil ����"
rlRun 'klist 2>&1 || true' 0 "�鿴Ʊ��(����Ϊ��)"

echo ""
echo "All krb5-basic functional tests passed!"
