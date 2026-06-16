rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install xz ===
INSTALLED_BY_TEST=0
if ! rpm -q xz 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y xz 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed xz"
    else
        echo "SKIP: xz not available in repos"
        exit 0
    fi
else
    echo "SETUP: xz already installed"
fi
