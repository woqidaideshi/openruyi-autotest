#!/bin/sh -eux
# Functional test: dc - �沨��������
# Tests: dc commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'echo "1 1 + p" | dc' 0 "dc �ӷ�"
rlRun 'echo "10 3 - p" | dc' 0 "dc ����"
rlRun 'echo "6 7 * p" | dc' 0 "dc �˷�"
rlRun 'echo "100 3 / p" | dc' 0 "dc ����"
rlRun 'echo "4 k 1 3 / p" | dc' 0 "dc ��������"

. "../teardown.sh"
echo "All dc-basic functional tests passed!"
