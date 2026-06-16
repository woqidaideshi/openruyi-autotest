rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install pam ===
INSTALLED_BY_TEST=0
if ! rpm -q pam 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y pam 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed pam"
    else
        echo "SKIP: pam not available in repos"
        exit 0
    fi
else
    echo "SETUP: pam already installed"
fi
