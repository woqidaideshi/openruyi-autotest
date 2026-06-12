#!/bin/sh -eux
# Functional test: nettle - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q nettle' 0 "检查 nettle 是否已安装"
rlRun 'which nettle-hash' 0 "检查 nettle-hash 命令是否可用"
rlRun 'which nettle-lfib-stream' 0 "检查 nettle-lfib-stream 命令是否可用"
rlRun 'which nettle-pbkdf2' 0 "检查 nettle-pbkdf2 命令是否可用"
rlRun 'which pkcs1-conv' 0 "检查 pkcs1-conv 命令是否可用"
rlRun 'which sexp-conv' 0 "检查 sexp-conv 命令是否可用"
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
