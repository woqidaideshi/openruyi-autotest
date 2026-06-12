#!/bin/sh -eux
# Functional test: findutils - find-执行操作

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q findutils' 0 "检查 findutils 是否已安装"
rlRun 'which find' 0 "检查 find 命令是否可用"
rlRun 'which xargs' 0 "检查 xargs 命令是否可用"
rlRun 'find --version' 0 "find 版本"
rlRun 'xargs --version' 0 "xargs 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 3: find 执行操作 ==="
rlRun 'find . -name "f1.txt" -exec cat {} \;' 0 "find -exec: 执行命令"
rlRun 'find . -name "*.txt" -delete' 0 "find -delete: 删除文件"
rlRun 'test ! -f a/f1.txt' 0 "find -delete: 验证删除"


echo ""
echo "All findutils find-执行操作 tests passed!"
