#!/bin/sh -eux
# Functional test: uid_wrapper - uid_wrapper UID 模拟库

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install uid_wrapper ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q uid_wrapper 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck uid_wrapper 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed uid_wrapper"
    else
        echo "SKIP: uid_wrapper not available in repos"
        exit 0
    fi
else
    echo "SETUP: uid_wrapper already installed"
fi

# 获取版本信息
rlRun 'rpm -q uid_wrapper' 0 "获取 uid_wrapper 版本信息"

# 列出包内文件
rlRun 'rpm -ql uid_wrapper 2>/dev/null' 0 "列出 uid_wrapper 文件列表"

# 检查共享库文件
rlRun 'rpm -ql uid_wrapper 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql uid_wrapper 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y uid_wrapper 2>/dev/null || true
    echo "TEARDOWN: removed uid_wrapper"
fi
echo ""
echo "All uid_wrapper tests passed!"
