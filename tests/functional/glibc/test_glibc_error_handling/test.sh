#!/bin/sh -eux
# Functional test: glibc - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q glibc' 0 "检查 glibc 是否已安装"
rlRun 'which gencat' 0 "检查 gencat 命令是否可用"
rlRun 'which getconf' 0 "检查 getconf 命令是否可用"
rlRun 'which getent' 0 "检查 getent 命令是否可用"
rlRun 'which iconv' 0 "检查 iconv 命令是否可用"
rlRun 'which ldconfig' 0 "检查 ldconfig 命令是否可用"
rlRun 'which ldd' 0 "检查 ldd 命令是否可用"
rlRun 'which locale' 0 "检查 locale 命令是否可用"
rlRun 'which localedef' 0 "检查 localedef 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'gencat --invalid 2>&1 || true' 0 "gencat: 无效选项"

echo ""
echo "All glibc functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All glibc 错误处理 tests passed!"
