rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install python-rpm-macros ===
INSTALLED_BY_TEST=0
if ! rpm -q python-rpm-macros 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python-rpm-macros 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python-rpm-macros"
    else
        echo "SKIP: python-rpm-macros not available in repos"
        exit 0
    fi
else
    echo "SETUP: python-rpm-macros already installed"
fi
