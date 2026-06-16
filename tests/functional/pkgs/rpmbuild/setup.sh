rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install rpmbuild ===
INSTALLED_BY_TEST=0
if ! rpm -q rpmbuild 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y rpmbuild 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed rpmbuild"
    else
        echo "SKIP: rpmbuild not available in repos"
        exit 0
    fi
else
    echo "SETUP: rpmbuild already installed"
fi


TmpDir=$(mktemp -d)
cd $TmpDir
