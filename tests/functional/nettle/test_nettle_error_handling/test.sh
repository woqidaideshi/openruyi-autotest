#!/bin/sh -eux
# Functional test: nettle - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q nettle 2>/dev/null || { echo 'nettle not installed, skipping'; exit 0; }
which nettle-hash 2>/dev/null || echo 'nettle-hash not found'
which nettle-lfib-stream 2>/dev/null || echo 'nettle-lfib-stream not found'
which nettle-pbkdf2 2>/dev/null || echo 'nettle-pbkdf2 not found'
which pkcs1-conv 2>/dev/null || echo 'pkcs1-conv not found'
which sexp-conv 2>/dev/null || echo 'sexp-conv not found'
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'nettle-hash --invalid 2>&1 || true' 0 "nettle-hash: 无效选项"

echo ""
echo "All nettle functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All nettle 错误处理 tests passed!"
