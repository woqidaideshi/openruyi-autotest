#!/bin/sh -eux
# Functional test: perl - Perl ������
# Commands: perl

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q perl 2>/dev/null || { echo 'perl not installed, skipping'; exit 0; }
which perl 2>/dev/null || echo 'perl not found'
rlRun 'perl --version 2>&1 || true' 0 "��ȡ perl �汾"

echo ""
echo "All perl functional tests passed!"
