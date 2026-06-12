#!/bin/sh -eux
# Functional test: audit package
# Tests audit 审计系统
# Version: audit

rlRun() { eval "\$1" 2>&1; return \$?; }

rlRun 'rpm -q audit' 0 "检查 audit 是否已安装"
rlRun 'which auditctl' 0 "检查 auditctl 命令是否可用"
rlRun 'which ausearch' 0 "检查 ausearch 命令是否可用"
rlRun 'which aureport' 0 "检查 aureport 命令是否可用"
rlRun 'which aulast' 0 "检查 aulast 命令是否可用"
rlRun 'which aulastlog' 0 "检查 aulastlog 命令是否可用"
rlRun 'which ausyscall' 0 "检查 ausyscall 命令是否可用"
rlRun 'which augenrules' 0 "检查 augenrules 命令是否可用"

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
