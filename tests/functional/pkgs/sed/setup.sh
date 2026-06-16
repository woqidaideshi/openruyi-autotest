rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install sed ===
INSTALLED_BY_TEST=0
if ! rpm -q sed 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y sed 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed sed"
    else
        echo "SKIP: sed not available in repos"
        exit 0
    fi
else
    echo "SETUP: sed already installed"
fi



rlRun 'sed --version' 0 "sed 版本"

TmpDir=$(mktemp -d); cd $TmpDir
