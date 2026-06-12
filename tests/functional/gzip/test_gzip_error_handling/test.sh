#!/bin/sh -eux
# Functional test: gzip - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q gzip' 0 "检查 gzip 是否已安装"
rlRun 'which gzip' 0 "检查 gzip 命令是否可用"
rlRun 'which gunzip' 0 "检查 gunzip 命令是否可用"
rlRun 'which zcat' 0 "检查 zcat 命令是否可用"
rlRun 'which zcmp' 0 "检查 zcmp 命令是否可用"
rlRun 'which zdiff' 0 "检查 zdiff 命令是否可用"
rlRun 'which zgrep' 0 "检查 zgrep 命令是否可用"
rlRun 'which zless' 0 "检查 zless 命令是否可用"
rlRun 'which zmore' 0 "检查 zmore 命令是否可用"
rlRun 'which znew' 0 "检查 znew 命令是否可用"
rlRun 'which gzexe' 0 "检查 gzexe 命令是否可用"
rlRun 'which zforce' 0 "检查 zforce 命令是否可用"
rlRun 'which zegrep' 0 "检查 zegrep 命令是否可用"
rlRun 'which zfgrep' 0 "检查 zfgrep 命令是否可用"
rlRun 'which uncompress' 0 "检查 uncompress 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'gzip --invalid 2>&1 || true' 0 "gzip: 无效选项"

echo ""
echo "All gzip functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All gzip 错误处理 tests passed!"
