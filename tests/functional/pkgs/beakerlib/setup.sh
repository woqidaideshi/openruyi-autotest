rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install beakerlib ===
INSTALLED_BY_TEST=0
if ! rpm -q beakerlib 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y beakerlib 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed beakerlib"
    else
        echo "SKIP: beakerlib not available in repos"
        exit 0
    fi
else
    echo "SETUP: beakerlib already installed"
fi
