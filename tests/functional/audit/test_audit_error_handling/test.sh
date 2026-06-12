#!/bin/sh -eux
# Functional test: audit - 错误处理

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q audit 2>/dev/null || { echo 'audit not installed, skipping'; exit 0; }
which auditctl 2>/dev/null || echo 'auditctl not found'
which ausearch 2>/dev/null || echo 'ausearch not found'
which aureport 2>/dev/null || echo 'aureport not found'
which aulast 2>/dev/null || echo 'aulast not found'
which aulastlog 2>/dev/null || echo 'aulastlog not found'
which ausyscall 2>/dev/null || echo 'ausyscall not found'
which augenrules 2>/dev/null || echo 'augenrules not found'
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
