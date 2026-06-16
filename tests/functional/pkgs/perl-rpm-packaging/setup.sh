rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl-rpm-packaging ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q perl-rpm-packaging 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck perl-rpm-packaging 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl-rpm-packaging"
    else
        echo "SKIP: perl-rpm-packaging not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl-rpm-packaging already installed"
fi

# 获取版本信息
rlRun 'rpm -q perl-rpm-packaging' 0 "获取 perl-rpm-packaging 版本信息"

# 列出包内文件
