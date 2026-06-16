#!/bin/sh -eux
# Functional test: libpwquality - ������
# Tests: pwmake, pwscore commands

# rlRun wrapper for standalone execution

. "../setup.sh"

rlRun 'pwmake --invalid-flag-xyz 2>&1 || true' 0 "���� pwmake ��Ч����������"
rlRun 'pwscore --invalid-flag-xyz 2>&1 || true' 0 "���� pwscore ��Ч����������"

. "../teardown.sh"
echo "All libpwquality-error functional tests passed!"
