rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl-Locale-gettext ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q perl-Locale-gettext 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck perl-Locale-gettext 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl-Locale-gettext"
    else
        echo "SKIP: perl-Locale-gettext not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl-Locale-gettext already installed"
fi

# 获取版本信息
rlRun 'rpm -q perl-Locale-gettext' 0 "获取 perl-Locale-gettext 版本信息"

# 列出包内文件
