rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install mpdecimal ===
INSTALLED_BY_TEST=0
if ! rpm -q mpdecimal 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y mpdecimal 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed mpdecimal"
    else
        echo "SKIP: mpdecimal not available in repos"
        exit 0
    fi
else
    echo "SETUP: mpdecimal already installed"
fi
