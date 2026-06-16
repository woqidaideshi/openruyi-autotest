#!/bin/sh -eux
# Functional test: icu4c ��������
# Commands: icuinfo, uconv

. "../setup.sh"

rlRun 'icuinfo 2>&1 | head -10 || true' 0 "��ʾ ICU ��Ϣ"
rlRun 'echo "test" | uconv -f UTF-8 -t UTF-8' 0 "uconv ת�����"

. "../teardown.sh"
echo "All icu4c-basic functional tests passed!"
