rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install binutils ===
INSTALLED_BY_TEST=0
if ! rpm -q binutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y binutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed binutils"
    else
        echo "SKIP: binutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: binutils already installed"
fi
