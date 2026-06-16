rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install nettle ===
INSTALLED_BY_TEST=0
if ! rpm -q nettle 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y nettle 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed nettle"
    else
        echo "SKIP: nettle not available in repos"
        exit 0
    fi
else
    echo "SETUP: nettle already installed"
fi
