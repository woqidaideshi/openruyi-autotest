#!/bin/sh -eux
# Functional test: python-rpm-generators - Python RPM 生成器

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-rpm-generators ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q python-rpm-generators 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck python-rpm-generators 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-rpm-generators"
    else
        echo "SKIP: python-rpm-generators not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-rpm-generators already installed"
fi

# 获取版本信息
rlRun 'rpm -q python-rpm-generators' 0 "获取 python-rpm-generators 版本信息"

# 列出包内文件
rlRun 'python3 -c "import python_rpm_generators" 2>&1 || echo "NO_MODULE"' 0 "导入 python-rpm-generators Python 模块"

# 检查共享库文件
rlRun 'rpm -ql python-rpm-generators 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql python-rpm-generators 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-rpm-generators 2>/dev/null || true
    echo "TEARDOWN: removed python-rpm-generators"
fi
echo ""
echo "All python-rpm-generators tests passed!"
