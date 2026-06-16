rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install rpm ===
INSTALLED_BY_TEST=0
if ! rpm -q rpm 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y rpm 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed rpm"
    else
        echo "SKIP: rpm not available in repos"
        exit 0
    fi
else
    echo "SETUP: rpm already installed"
fi



echo "=== ������ ==="
