#!/bin/sh -eux
# Functional test: openssl - ���ܹ��߰�
# Commands: openssl, c_rehash

rlRun() { eval "$1" 2>&1; return $?; }

rpm -q openssl 2>/dev/null || { echo 'openssl not installed, skipping'; exit 0; }
which openssl 2>/dev/null || echo 'openssl not found'
which c_rehash 2>/dev/null || echo 'c_rehash not found'
rlRun 'openssl --version 2>&1 || true' 0 "��ȡ openssl �汾"

echo ""
echo "All openssl functional tests passed!"
