rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install linux-headers ===
INSTALLED_BY_TEST=0
if ! rpm -q linux-headers 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y linux-headers 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed linux-headers"
    else
        echo "SKIP: linux-headers not available in repos"
        exit 0
    fi
else
    echo "SETUP: linux-headers already installed"
fi
