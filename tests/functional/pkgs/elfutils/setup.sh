rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install elfutils ===
INSTALLED_BY_TEST=0
if ! rpm -q elfutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y elfutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed elfutils"
    else
        echo "SKIP: elfutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: elfutils already installed"
fi
