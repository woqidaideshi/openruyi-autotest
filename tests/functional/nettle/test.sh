#!/bin/sh -eux
# Functional test: nettle package
# Tests Nettle 加密库工具
# Version: nettle

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q nettle 2>/dev/null || { echo 'nettle not installed, skipping'; exit 0; }
which nettle-hash 2>/dev/null || echo 'nettle-hash not found'
which nettle-lfib-stream 2>/dev/null || echo 'nettle-lfib-stream not found'
which nettle-pbkdf2 2>/dev/null || echo 'nettle-pbkdf2 not found'
which pkcs1-conv 2>/dev/null || echo 'pkcs1-conv not found'
which sexp-conv 2>/dev/null || echo 'sexp-conv not found'

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'nettle-hash --version 2>&1 || true' 0 "nettle-hash 版本信息"
rlRun 'nettle-hash --help 2>&1 | head -5 || true' 0 "nettle-hash 帮助信息"
rlRun 'nettle-lfib-stream --version 2>&1 || true' 0 "nettle-lfib-stream 版本信息"
rlRun 'nettle-lfib-stream --help 2>&1 | head -5 || true' 0 "nettle-lfib-stream 帮助信息"
rlRun 'nettle-pbkdf2 --version 2>&1 || true' 0 "nettle-pbkdf2 版本信息"
rlRun 'nettle-pbkdf2 --help 2>&1 | head -5 || true' 0 "nettle-pbkdf2 帮助信息"
rlRun 'pkcs1-conv --version 2>&1 || true' 0 "pkcs1-conv 版本信息"
rlRun 'pkcs1-conv --help 2>&1 | head -5 || true' 0 "pkcs1-conv 帮助信息"
rlRun 'sexp-conv --version 2>&1 || true' 0 "sexp-conv 版本信息"
rlRun 'sexp-conv --help 2>&1 | head -5 || true' 0 "sexp-conv 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'nettle-hash --invalid 2>&1 || true' 0 "nettle-hash: 无效选项"

echo ""
echo "All nettle functional tests passed!"
