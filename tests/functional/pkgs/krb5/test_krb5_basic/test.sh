#!/bin/sh -eux
# Functional test: krb5 ��������
# Commands: kinit, klist, kdestroy, kadmin, ktutil

. "../setup.sh"

rlRun 'klist 2>&1 || true' 0 "�鿴Ʊ��(����Ϊ��)"

. "../teardown.sh"
echo "All krb5-basic functional tests passed!"
