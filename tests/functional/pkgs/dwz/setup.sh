rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install dwz ===
INSTALLED_BY_TEST=0
if ! rpm -q dwz 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y dwz 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed dwz"
    else
        echo "SKIP: dwz not available in repos"
        exit 0
    fi
else
    echo "SETUP: dwz already installed"
fi
