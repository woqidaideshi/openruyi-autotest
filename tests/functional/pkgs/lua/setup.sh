rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install lua ===
INSTALLED_BY_TEST=0
if ! rpm -q lua 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y lua 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed lua"
    else
        echo "SKIP: lua not available in repos"
        exit 0
    fi
else
    echo "SETUP: lua already installed"
fi
