rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install gmp ===
INSTALLED_BY_TEST=0
if ! rpm -q gmp 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gmp 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gmp"
    else
        echo "SKIP: gmp not available in repos"
        exit 0
    fi
else
    echo "SETUP: gmp already installed"
fi
