rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install debugedit ===
INSTALLED_BY_TEST=0
if ! rpm -q debugedit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y debugedit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed debugedit"
    else
        echo "SKIP: debugedit not available in repos"
        exit 0
    fi
else
    echo "SETUP: debugedit already installed"
fi
