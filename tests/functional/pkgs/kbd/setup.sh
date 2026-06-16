rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install kbd ===
INSTALLED_BY_TEST=0
if ! rpm -q kbd 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y kbd 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed kbd"
    else
        echo "SKIP: kbd not available in repos"
        exit 0
    fi
else
    echo "SETUP: kbd already installed"
fi
