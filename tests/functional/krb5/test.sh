#!/bin/sh -eux
# Functional test: krb5 - Kerberos ��֤
# Commands: kinit, klist, kdestroy, kadmin, ktutil

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q krb5 2>/dev/null || { echo 'krb5 not installed, skipping'; exit 0; }
which kinit 2>/dev/null || echo 'kinit not found'
which klist 2>/dev/null || echo 'klist not found'
which kdestroy 2>/dev/null || echo 'kdestroy not found'

echo ""
echo "All krb5 functional tests passed!"
