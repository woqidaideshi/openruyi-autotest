rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install mpc ===
INSTALLED_BY_TEST=0
if ! rpm -q mpc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y mpc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed mpc"
    else
        echo "SKIP: mpc not available in repos"
        exit 0
    fi
else
    echo "SETUP: mpc already installed"
fi
