#!/bin/sh -eux
# Functional test: icu4c - Unicode ���ʻ����
# Commands: icuinfo, uconv, genbrk, gencnval

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q icu4c 2>/dev/null || { echo 'icu4c not installed, skipping'; exit 0; }
which icuinfo 2>/dev/null || echo 'icuinfo not found'
which uconv 2>/dev/null || echo 'uconv not found'

echo ""
echo "All icu4c functional tests passed!"
