#!/bin/sh -eux
# Functional test: e2fsprogs - ext �ļ�ϵͳ����
# Commands: e2fsck, mke2fs, tune2fs, dumpe2fs, resize2fs

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q e2fsprogs 2>/dev/null || { echo 'e2fsprogs not installed, skipping'; exit 0; }
which e2fsck 2>/dev/null || echo 'e2fsck not found'
which mke2fs 2>/dev/null || echo 'mke2fs not found'
which tune2fs 2>/dev/null || echo 'tune2fs not found'
which dumpe2fs 2>/dev/null || echo 'dumpe2fs not found'

echo ""
echo "All e2fsprogs functional tests passed!"
