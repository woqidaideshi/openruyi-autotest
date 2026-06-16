rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install gzip ===
INSTALLED_BY_TEST=0
if ! rpm -q gzip 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gzip 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gzip"
    else
        echo "SKIP: gzip not available in repos"
        exit 0
    fi
else
    echo "SETUP: gzip already installed"
fi
