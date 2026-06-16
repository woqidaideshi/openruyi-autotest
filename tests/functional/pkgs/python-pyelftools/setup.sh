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
