rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install make ===
INSTALLED_BY_TEST=0
if ! rpm -q make 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y make 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed make"
    else
        echo "SKIP: make not available in repos"
        exit 0
    fi
else
    echo "SETUP: make already installed"
fi



rlRun 'make --version' 0 "make version"
rlRun 'gmake --version' 0 "gmake version"

TmpDir=$(mktemp -d)
cd $TmpDir
