rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bash-completion ===
INSTALLED_BY_TEST=0
if ! rpm -q bash-completion 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bash-completion 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bash-completion"
    else
        echo "SKIP: bash-completion not available in repos"
        exit 0
    fi
else
    echo "SETUP: bash-completion already installed"
fi
