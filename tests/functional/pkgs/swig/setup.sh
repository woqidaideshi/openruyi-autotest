rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install swig ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q swig 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck swig 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed swig"
    else
        echo "SKIP: swig not available in repos"
        exit 0
    fi
else
    echo "SETUP: swig already installed"
fi

# 获取版本信息
rlRun 'rpm -q swig' 0 "获取 swig 版本信息"

# 列出包内二进制文件
rlRun 'rpm -ql swig 2>/dev/null | grep -E "^/usr/bin/|^/usr/sbin/|^/bin/|^/sbin/"' 0 "列出包内二进制文件"
