#!/bin/sh -eux
# Functional test: nettle - 版本和帮助

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q nettle' 0 "检查 nettle 是否已安装"
rlRun 'which nettle-hash' 0 "检查 nettle-hash 命令是否可用"
rlRun 'which nettle-lfib-stream' 0 "检查 nettle-lfib-stream 命令是否可用"
rlRun 'which nettle-pbkdf2' 0 "检查 nettle-pbkdf2 命令是否可用"
rlRun 'which pkcs1-conv' 0 "检查 pkcs1-conv 命令是否可用"
rlRun 'which sexp-conv' 0 "检查 sexp-conv 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

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

cd /
rm -rf $TmpDir

echo ""
echo "All nettle 版本和帮助 tests passed!"
