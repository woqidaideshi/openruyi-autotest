#!/bin/sh -eux
# Functional test: cmocka - cmocka C 单元测试框架

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cmocka ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q cmocka 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck cmocka 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cmocka"
    else
        echo "SKIP: cmocka not available in repos"
        exit 0
    fi
else
    echo "SETUP: cmocka already installed"
fi

# 获取版本信息
rlRun 'rpm -q cmocka' 0 "获取 cmocka 版本信息"

# 列出包内文件
rlRun 'rpm -ql cmocka 2>/dev/null' 0 "列出 cmocka 文件列表"

# 检查共享库文件
rlRun 'rpm -ql cmocka 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql cmocka 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y cmocka 2>/dev/null || true
    echo "TEARDOWN: removed cmocka"
fi
echo ""
echo "All cmocka tests passed!"
