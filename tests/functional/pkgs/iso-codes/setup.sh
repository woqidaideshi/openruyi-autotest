rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install iso-codes ===
INSTALLED_BY_TEST=0
if ! rpm -q iso-codes 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y iso-codes 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed iso-codes"
    else
        echo "SKIP: iso-codes not available in repos"
        exit 0
    fi
else
    echo "SETUP: iso-codes already installed"
fi
