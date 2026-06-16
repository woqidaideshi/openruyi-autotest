rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install publicsuffix-list ===
INSTALLED_BY_TEST=0
if ! rpm -q publicsuffix-list 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y publicsuffix-list 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed publicsuffix-list"
    else
        echo "SKIP: publicsuffix-list not available in repos"
        exit 0
    fi
else
    echo "SETUP: publicsuffix-list already installed"
fi
