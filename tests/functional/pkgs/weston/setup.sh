rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install weston ===
INSTALLED_BY_TEST=0
if ! rpm -q weston 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y weston 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed weston"
    else
        echo "SKIP: weston not available in repos"
        exit 0
    fi
else
    echo "SETUP: weston already installed"
fi
