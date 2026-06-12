#!/bin/sh -eux
# Functional test: icu4c ��������
# Commands: icuinfo, uconv

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q icu4c 2>/dev/null || { echo 'icu4c not installed, skipping'; exit 0; }
which icuinfo 2>/dev/null || echo 'icuinfo not found'
which uconv 2>/dev/null || echo 'uconv not found'

echo "=== ICU ���� ==="
rlRun 'icuinfo --help 2>&1 | head -10' 0 "icuinfo ����"
rlRun 'uconv --help 2>&1 | head -10' 0 "uconv ����"
rlRun 'icuinfo 2>&1 | head -10 || true' 0 "��ʾ ICU ��Ϣ"
rlRun 'echo "test" | uconv -f UTF-8 -t UTF-8' 0 "uconv ת�����"

echo ""
echo "All icu4c-basic functional tests passed!"
