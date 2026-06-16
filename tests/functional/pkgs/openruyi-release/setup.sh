rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install openruyi-release ===
INSTALLED_BY_TEST=0
if ! rpm -q openruyi-release 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y openruyi-release 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed openruyi-release"
    else
        echo "SKIP: openruyi-release not available in repos"
        exit 0
    fi
else
    echo "SETUP: openruyi-release already installed"
fi
