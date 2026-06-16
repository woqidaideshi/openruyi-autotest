rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install ca-certificates ===
INSTALLED_BY_TEST=0
if ! rpm -q ca-certificates 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y ca-certificates 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed ca-certificates"
    else
        echo "SKIP: ca-certificates not available in repos"
        exit 0
    fi
else
    echo "SETUP: ca-certificates already installed"
fi
