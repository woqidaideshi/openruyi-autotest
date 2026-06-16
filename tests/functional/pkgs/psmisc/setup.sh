rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install psmisc ===
INSTALLED_BY_TEST=0
if ! rpm -q psmisc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y psmisc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed psmisc"
    else
        echo "SKIP: psmisc not available in repos"
        exit 0
    fi
else
    echo "SETUP: psmisc already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir
