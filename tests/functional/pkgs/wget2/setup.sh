rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install wget2 ===
INSTALLED_BY_TEST=0
if ! rpm -q wget2 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y wget2 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed wget2"
    else
        echo "SKIP: wget2 not available in repos"
        exit 0
    fi
else
    echo "SETUP: wget2 already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir
