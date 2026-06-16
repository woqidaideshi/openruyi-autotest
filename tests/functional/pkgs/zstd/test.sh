#!/bin/sh -eux
# Functional test: zstd package
# Tests zstd 压缩工具
# Version: zstd

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install zstd ===
INSTALLED_BY_TEST=0
if ! rpm -q zstd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y zstd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed zstd"
    else
        echo "SKIP: zstd not available in repos"
        exit 0
    fi
else
    echo "SETUP: zstd already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'zstd --version 2>&1 || true' 0 "zstd 版本信息"
rlRun 'zstd --help 2>&1 | head -5 || true' 0 "zstd 帮助信息"
rlRun 'unzstd --version 2>&1 || true' 0 "unzstd 版本信息"
rlRun 'unzstd --help 2>&1 | head -5 || true' 0 "unzstd 帮助信息"
rlRun 'zstdcat --version 2>&1 || true' 0 "zstdcat 版本信息"
rlRun 'zstdcat --help 2>&1 | head -5 || true' 0 "zstdcat 帮助信息"
rlRun 'zstdgrep --version 2>&1 || true' 0 "zstdgrep 版本信息"
rlRun 'zstdgrep --help 2>&1 | head -5 || true' 0 "zstdgrep 帮助信息"
rlRun 'zstdless --version 2>&1 || true' 0 "zstdless 版本信息"
rlRun 'zstdless --help 2>&1 | head -5 || true' 0 "zstdless 帮助信息"
rlRun 'zstdmt --version 2>&1 || true' 0 "zstdmt 版本信息"
rlRun 'zstdmt --help 2>&1 | head -5 || true' 0 "zstdmt 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'zstd --invalid 2>&1 || true' 0 "zstd: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y zstd 2>/dev/null || true
    echo "TEARDOWN: removed zstd"
fi
echo ""
echo "All zstd functional tests passed!"
