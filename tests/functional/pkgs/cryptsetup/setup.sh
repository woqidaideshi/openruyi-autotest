rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install cryptsetup ===
INSTALLED_BY_TEST=0
if ! rpm -q cryptsetup 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cryptsetup 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cryptsetup"
    else
        echo "SKIP: cryptsetup not available in repos"
        exit 0
    fi
else
    echo "SETUP: cryptsetup already installed"
fi
