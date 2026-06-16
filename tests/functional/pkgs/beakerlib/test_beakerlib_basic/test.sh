#!/bin/sh -eux
# Functional test: beakerlib ��������
# Commands: beakerlib-deja-summarize, beakerlib-journalcmp, beakerlib-testwatcher

. "../setup.sh"

echo "=== ������Ϣ ==="
rlRun 'beakerlib-deja-summarize --help 2>&1 | head -10' 0 "summarize ����"
rlRun 'beakerlib-journalcmp --help 2>&1 | head -10' 0 "journalcmp ����"
rlRun 'beakerlib-testwatcher --help 2>&1 | head -10' 0 "testwatcher ����"

. "../teardown.sh"
echo "All beakerlib-basic functional tests passed!"
