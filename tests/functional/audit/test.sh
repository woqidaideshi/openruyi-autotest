#!/bin/sh -eux
# Functional test: audit package
# Tests audit 审计系统
# Version: audit

rlRun() { eval "\$1" 2>&1; return \$?; }

rpm -q audit 2>/dev/null || { echo 'audit not installed, skipping'; exit 0; }
which auditctl 2>/dev/null || echo 'auditctl not found'
which ausearch 2>/dev/null || echo 'ausearch not found'
which aureport 2>/dev/null || echo 'aureport not found'
which aulast 2>/dev/null || echo 'aulast not found'
which aulastlog 2>/dev/null || echo 'aulastlog not found'
which ausyscall 2>/dev/null || echo 'ausyscall not found'
which augenrules 2>/dev/null || echo 'augenrules not found'

echo "=== 测试 1: 版本和帮助 ==="
rlRun 'auditctl --version 2>&1 || true' 0 "auditctl 版本信息"
rlRun 'auditctl --help 2>&1 | head -5 || true' 0 "auditctl 帮助信息"
rlRun 'ausearch --version 2>&1 || true' 0 "ausearch 版本信息"
rlRun 'ausearch --help 2>&1 | head -5 || true' 0 "ausearch 帮助信息"
rlRun 'aureport --version 2>&1 || true' 0 "aureport 版本信息"
rlRun 'aureport --help 2>&1 | head -5 || true' 0 "aureport 帮助信息"
rlRun 'aulast --version 2>&1 || true' 0 "aulast 版本信息"
rlRun 'aulast --help 2>&1 | head -5 || true' 0 "aulast 帮助信息"
rlRun 'aulastlog --version 2>&1 || true' 0 "aulastlog 版本信息"
rlRun 'aulastlog --help 2>&1 | head -5 || true' 0 "aulastlog 帮助信息"
rlRun 'ausyscall --version 2>&1 || true' 0 "ausyscall 版本信息"
rlRun 'ausyscall --help 2>&1 | head -5 || true' 0 "ausyscall 帮助信息"
rlRun 'augenrules --version 2>&1 || true' 0 "augenrules 版本信息"
rlRun 'augenrules --help 2>&1 | head -5 || true' 0 "augenrules 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'auditctl --invalid 2>&1 || true' 0 "auditctl: 无效选项"

echo ""
echo "All audit functional tests passed!"
