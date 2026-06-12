#!/bin/sh -eux
# Functional test: perl - ��������
# Commands: perl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q perl 2>/dev/null || { echo 'perl not installed, skipping'; exit 0; }
which perl 2>/dev/null || echo 'perl not found'

echo "=== perl �������� ==="
rlRun 'perl --help 2>&1 | head -10' 0 "perl ����"
rlRun 'perl -e "print \"hello\n\""' 0 "ִ�м� Perl ����"
rlRun 'perl -v 2>&1 | head -5' 0 "�鿴�汾����"

echo ""
echo "All perl-basic functional tests passed!"
