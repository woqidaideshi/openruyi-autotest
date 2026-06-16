#!/bin/sh -eux
# Functional test: perl - ��������
# Commands: perl

. "../setup.sh"

rlRun 'perl -e "print \"hello\n\""' 0 "ִ�м� Perl ����"
rlRun 'perl -v 2>&1 | head -5' 0 "�鿴�汾����"

. "../teardown.sh"
echo "All perl-basic functional tests passed!"
