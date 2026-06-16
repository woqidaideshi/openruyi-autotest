rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install audit ===
INSTALLED_BY_TEST=0
if ! rpm -q audit 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y audit 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed audit"
    else
        echo "SKIP: audit not available in repos"
        exit 0
    fi
else
    echo "SETUP: audit already installed"
fi
