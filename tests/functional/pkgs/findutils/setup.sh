rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install findutils ===
INSTALLED_BY_TEST=0
if ! rpm -q findutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y findutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed findutils"
    else
        echo "SKIP: findutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: findutils already installed"
fi



rlRun 'find --version' 0 "find 版本"
rlRun 'xargs --version' 0 "xargs 版本"

TmpDir=$(mktemp -d); cd $TmpDir
