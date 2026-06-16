#!/bin/sh -eux
# Functional test: openssl - ��������
# Commands: openssl

. "../setup.sh"

rlRun 'openssl version' 0 "�鿴�汾"
rlRun 'openssl help 2>&1 | head -20' 0 "�鿴����"
rlRun 'openssl list -standard-commands 2>&1 | head -10' 0 "�г���׼����"
rlRun 'openssl list -cipher-commands 2>&1 | head -10' 0 "�г���������"
rlRun 'openssl list -digest-commands 2>&1 | head -10' 0 "�г�ժҪ����"

. "../teardown.sh"
echo "All openssl-basic functional tests passed!"
