#!/bin/sh -eux
# Functional test: sed - 全局和正则

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q sed' 0 "检查 sed 是否已安装"
rlRun 'which sed' 0 "检查 sed 命令是否可用"
rlRun 'sed --version' 0 "sed 版本"
TmpDir=$(mktemp -d); cd $TmpDir

echo "=== 测试 3: 全局和正则 ==="
rlRun 'echo "aaa" | sed "s/a/b/g"' 0 "sed g: 全局替换"
rlRun 'echo "abc123" | sed "s/[0-9]/X/g"' 0 "sed: 正则替换"


echo ""
echo "All sed 全局和正则 tests passed!"
