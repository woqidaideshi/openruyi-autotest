rlRun() { eval "\$1" 2>&1; return \$?; }
# === SETUP: check/install python ===
INSTALLED_BY_TEST=0
if ! rpm -q python 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y python 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed python"
    else
        echo "SKIP: python not available in repos"
        exit 0
    fi
else
    echo "SETUP: python already installed"
fi



rlRun 'python3 --version' 0 "Python 版本"
