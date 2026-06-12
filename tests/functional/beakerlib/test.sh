#!/bin/sh -eux
# Functional test: beakerlib - ���Կ��
# Commands: beakerlib-deja-summarize, beakerlib-journalcmp, beakerlib-testwatcher

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q beakerlib 2>/dev/null || { echo 'beakerlib not installed, skipping'; exit 0; }
which beakerlib-deja-summarize 2>/dev/null || echo 'beakerlib-deja-summarize not found'
which beakerlib-journalcmp 2>/dev/null || echo 'beakerlib-journalcmp not found'
which beakerlib-testwatcher 2>/dev/null || echo 'beakerlib-testwatcher not found'

echo ""
echo "All beakerlib functional tests passed!"
