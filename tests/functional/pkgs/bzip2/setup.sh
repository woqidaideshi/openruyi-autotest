rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bzip2 ===
INSTALLED_BY_TEST=0
if ! rpm -q bzip2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bzip2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bzip2"
    else
        echo "SKIP: bzip2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: bzip2 already installed"
fi
