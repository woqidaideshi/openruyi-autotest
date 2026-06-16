rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install libselinux ===
INSTALLED_BY_TEST=0
if ! rpm -q libselinux 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y libselinux 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed libselinux"
    else
        echo "SKIP: libselinux not available in repos"
        exit 0
    fi
else
    echo "SETUP: libselinux already installed"
fi
