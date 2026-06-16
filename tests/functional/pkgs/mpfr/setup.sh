rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install mpfr ===
INSTALLED_BY_TEST=0
if ! rpm -q mpfr 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y mpfr 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed mpfr"
    else
        echo "SKIP: mpfr not available in repos"
        exit 0
    fi
else
    echo "SETUP: mpfr already installed"
fi
