rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-packaging ===
INSTALLED_BY_TEST=0
if ! rpm -q python-packaging 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-packaging 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-packaging"
    else
        echo "SKIP: python-packaging not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-packaging already installed"
fi
