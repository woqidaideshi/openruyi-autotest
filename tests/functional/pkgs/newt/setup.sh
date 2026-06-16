rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install newt ===
INSTALLED_BY_TEST=0
if ! rpm -q newt 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y newt 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed newt"
    else
        echo "SKIP: newt not available in repos"
        exit 0
    fi
else
    echo "SETUP: newt already installed"
fi
