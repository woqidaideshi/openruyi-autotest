rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gcc ===
INSTALLED_BY_TEST=0
if ! rpm -q gcc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y gcc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gcc"
    else
        echo "SKIP: gcc not available in repos"
        exit 0
    fi
else
    echo "SETUP: gcc already installed"
fi



rlRun 'gcc --version' 0 "Get gcc version info"
rlRun 'g++ --version' 0 "Get g++ version info"

TmpDir=$(mktemp -d)
cd $TmpDir
