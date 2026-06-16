rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install util-linux ===
INSTALLED_BY_TEST=0
if ! rpm -q util-linux 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y util-linux 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed util-linux"
    else
        echo "SKIP: util-linux not available in repos"
        exit 0
    fi
else
    echo "SETUP: util-linux already installed"
fi
