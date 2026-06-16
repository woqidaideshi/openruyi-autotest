rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install dnf5-plugins ===
INSTALLED_BY_TEST=0
if ! rpm -q dnf5-plugins 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y dnf5-plugins 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed dnf5-plugins"
    else
        echo "SKIP: dnf5-plugins not available in repos"
        exit 0
    fi
else
    echo "SETUP: dnf5-plugins already installed"
fi
