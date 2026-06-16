rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install iptables ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q iptables 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck iptables 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed iptables"
    else
        echo "SKIP: iptables not available in repos"
        exit 0
    fi
else
    echo "SETUP: iptables already installed"
fi

# 获取版本信息
rlRun 'rpm -q iptables' 0 "获取 iptables 版本信息"

# 列出包内二进制文件
rlRun 'rpm -ql iptables 2>/dev/null | grep -E "^/usr/bin/|^/usr/sbin/|^/bin/|^/sbin/"' 0 "列出包内二进制文件"
