rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gpm ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q gpm 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck gpm 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gpm"
    else
        echo "SKIP: gpm not available in repos"
        exit 0
    fi
else
    echo "SETUP: gpm already installed"
fi
