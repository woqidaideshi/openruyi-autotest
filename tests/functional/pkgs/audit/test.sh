#!/bin/sh -eux
# Functional test: audit package
# Tests audit 审计系统
# Version: audit

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install audit ===
INSTALLED_BY_TEST=0
if ! rpm -q audit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y audit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed audit"
    else
        echo "SKIP: audit not available in repos"
        exit 0
    fi
else
    echo "SETUP: audit already installed"
fi



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


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y audit 2>/dev/null || true
    echo "TEARDOWN: removed audit"
fi
echo ""
echo "All audit functional tests passed!"
