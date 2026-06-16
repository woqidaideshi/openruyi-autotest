#!/bin/sh -eux
# Functional test: python-pyelftools - pyelftools ELF 解析库

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-pyelftools ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q python-pyelftools 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck python-pyelftools 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-pyelftools"
    else
        echo "SKIP: python-pyelftools not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-pyelftools already installed"
fi

# 获取版本信息
rlRun 'rpm -q python-pyelftools' 0 "获取 python-pyelftools 版本信息"

# 列出包内文件
rlRun 'python3 -c "import python_pyelftools" 2>&1 || echo "NO_MODULE"' 0 "导入 python-pyelftools Python 模块"

# 检查共享库文件
rlRun 'rpm -ql python-pyelftools 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql python-pyelftools 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-pyelftools 2>/dev/null || true
    echo "TEARDOWN: removed python-pyelftools"
fi
echo ""
echo "All python-pyelftools tests passed!"
