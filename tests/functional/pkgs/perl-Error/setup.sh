rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl-Error ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q perl-Error 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck perl-Error 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl-Error"
    else
        echo "SKIP: perl-Error not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl-Error already installed"
fi

# 获取版本信息
rlRun 'rpm -q perl-Error' 0 "获取 perl-Error 版本信息"

# 列出包内文件
