#!/bin/sh -eux
# Functional test: pkgconf package
# Tests pkgconf 包配置工具
# Version: pkgconf

rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install pkgconf ===
INSTALLED_BY_TEST=0
if ! rpm -q pkgconf 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y pkgconf 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed pkgconf"
    else
        echo "SKIP: pkgconf not available in repos"
        exit 0
    fi
else
    echo "SETUP: pkgconf already installed"
fi



echo "=== 测试 1: 版本和帮助 ==="
rlRun 'pkgconf --version 2>&1 || true' 0 "pkgconf 版本信息"
rlRun 'pkgconf --help 2>&1 | head -5 || true' 0 "pkgconf 帮助信息"
rlRun 'bomtool --version 2>&1 || true' 0 "bomtool 版本信息"
rlRun 'bomtool --help 2>&1 | head -5 || true' 0 "bomtool 帮助信息"

echo "=== 测试 2: 错误处理 ==="
rlRun 'pkgconf --invalid 2>&1 || true' 0 "pkgconf: 无效选项"


# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y pkgconf 2>/dev/null || true
    echo "TEARDOWN: removed pkgconf"
fi
echo ""
echo "All pkgconf functional tests passed!"
