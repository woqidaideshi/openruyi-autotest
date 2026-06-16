rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install filesystem ===
INSTALLED_BY_TEST=0
if ! rpm -q filesystem 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y filesystem 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed filesystem"
    else
        echo "SKIP: filesystem not available in repos"
        exit 0
    fi
else
    echo "SETUP: filesystem already installed"
fi
