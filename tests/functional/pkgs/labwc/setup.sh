rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install labwc ===
INSTALLED_BY_TEST=0
if ! rpm -q labwc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y labwc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed labwc"
    else
        echo "SKIP: labwc not available in repos"
        exit 0
    fi
else
    echo "SETUP: labwc already installed"
fi
