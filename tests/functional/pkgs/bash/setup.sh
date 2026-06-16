rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install bash ===
INSTALLED_BY_TEST=0
if ! rpm -q bash 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bash 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bash"
    else
        echo "SKIP: bash not available in repos"
        exit 0
    fi
else
    echo "SETUP: bash already installed"
fi



rlRun 'bash --version' 0 "bash 版本"
rlRun 'sh --version 2>&1 || true' 0 "sh 版本"

TmpDir=$(mktemp -d); cd $TmpDir
