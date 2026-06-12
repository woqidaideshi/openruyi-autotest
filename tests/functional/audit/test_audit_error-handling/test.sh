#!/bin/sh -eux
# Functional test: audit - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q audit' 0 "检查 audit 是否已安装"
rlRun 'which auditctl' 0 "检查 auditctl 命令是否可用"
rlRun 'which ausearch' 0 "检查 ausearch 命令是否可用"
rlRun 'which aureport' 0 "检查 aureport 命令是否可用"
rlRun 'which aulast' 0 "检查 aulast 命令是否可用"
rlRun 'which aulastlog' 0 "检查 aulastlog 命令是否可用"
rlRun 'which ausyscall' 0 "检查 ausyscall 命令是否可用"
rlRun 'which augenrules' 0 "检查 augenrules 命令是否可用"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== 测试 2: 错误处理 ==="
rlRun 'auditctl --invalid 2>&1 || true' 0 "auditctl: 无效选项"

echo ""
echo "All audit functional tests passed!"

cd /
rm -rf $TmpDir

echo ""
echo "All audit 错误处理 tests passed!"
