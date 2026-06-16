rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install coreutils ===
INSTALLED_BY_TEST=0
if ! rpm -q coreutils 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y coreutils 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed coreutils"
    else
        echo "SKIP: coreutils not available in repos"
        exit 0
    fi
else
    echo "SETUP: coreutils already installed"
fi



TmpDir=$(mktemp -d)
cd $TmpDir

# ===================================================================
