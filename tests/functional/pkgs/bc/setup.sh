rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install bc ===
INSTALLED_BY_TEST=0
if ! rpm -q bc 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y bc 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed bc"
    else
        echo "SKIP: bc not available in repos"
        exit 0
    fi
else
    echo "SETUP: bc already installed"
fi



echo "=== ����: bc �������� ==="
