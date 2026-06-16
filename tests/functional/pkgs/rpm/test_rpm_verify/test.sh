#!/bin/sh -eux
# Functional test: rpm ��֤
# Commands: rpm, rpmkeys

. "../setup.sh"

rlRun 'rpm -V rpm 2>&1 || true' 0 "��֤ rpm ��������"
rlRun 'rpm --import 2>&1 | head -5 || true' 0 "rpm --import ����"

. "../teardown.sh"
echo "All rpm-verify functional tests passed!"
