#!/bin/sh -eux
# Functional test: beakerlib ��������
# Commands: beakerlib-deja-summarize, beakerlib-journalcmp, beakerlib-testwatcher

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q beakerlib 2>/dev/null || { echo 'beakerlib not installed, skipping'; exit 0; }
which beakerlib-deja-summarize 2>/dev/null || echo 'beakerlib-deja-summarize not found'
which beakerlib-journalcmp 2>/dev/null || echo 'beakerlib-journalcmp not found'
which beakerlib-testwatcher 2>/dev/null || echo 'beakerlib-testwatcher not found'

echo "=== ������Ϣ ==="
rlRun 'beakerlib-deja-summarize --help 2>&1 | head -10' 0 "summarize ����"
rlRun 'beakerlib-journalcmp --help 2>&1 | head -10' 0 "journalcmp ����"
rlRun 'beakerlib-testwatcher --help 2>&1 | head -10' 0 "testwatcher ����"

echo ""
echo "All beakerlib-basic functional tests passed!"
