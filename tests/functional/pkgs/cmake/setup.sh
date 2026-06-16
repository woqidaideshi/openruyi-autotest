rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install cmake ===
INSTALLED_BY_TEST=0
if ! rpm -q cmake 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y cmake 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed cmake"
    else
        echo "SKIP: cmake not available in repos"
        exit 0
    fi
else
    echo "SETUP: cmake already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir
