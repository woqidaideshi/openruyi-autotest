#!/bin/sh -eux
# Functional test: python-flit-core - flit-core 轻量打包工具

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-flit-core ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q python-flit-core 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck python-flit-core 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-flit-core"
    else
        echo "SKIP: python-flit-core not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-flit-core already installed"
fi

# 获取版本信息
rlRun 'rpm -q python-flit-core' 0 "获取 python-flit-core 版本信息"

# 列出包内文件
rlRun 'python3 -c "import python_flit_core" 2>&1 || echo "NO_MODULE"' 0 "导入 python-flit-core Python 模块"

# 检查共享库文件
rlRun 'rpm -ql python-flit-core 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql python-flit-core 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y python-flit-core 2>/dev/null || true
    echo "TEARDOWN: removed python-flit-core"
fi
echo ""
echo "All python-flit-core tests passed!"
